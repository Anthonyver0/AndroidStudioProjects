package com.example.practicabbddapi

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.appcompat.widget.SearchView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class MainActivity : AppCompatActivity(), SearchView.OnQueryTextListener{
    private lateinit var recy: RecyclerView
    val adaptadorRecyclerView = AdaptadorAutores()
    private lateinit var buscador: SearchView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        buscador=findViewById(R.id.svAutores)
        recy = findViewById(R.id.rvAutores)
        recy.layoutManager = LinearLayoutManager(applicationContext,
            LinearLayoutManager.VERTICAL, false)
        recy.adapter = adaptadorRecyclerView

        buscador.setOnQueryTextListener(this)


    }

    override fun onQueryTextSubmit(query: String?): Boolean {
        if(!query.isNullOrEmpty()){
            busquedaAutores(query.lowercase())
        }
        val imm = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(this.buscador.windowToken, 0)
        return true
    }
    override fun onQueryTextChange(newText: String?): Boolean {
        return true
    }




    private fun getRetrofit(): Retrofit {
        return Retrofit.Builder()
            .baseUrl("https://openlibrary.org/")
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    private fun busquedaAutores(query:String){
        CoroutineScope(Dispatchers.IO).launch {
            val call = getRetrofit().create(APIservice::class.java).getAutores("/search/authors.json?q=$query")
            val autoresAPI = call.body()
            if(call.isSuccessful){
                val autores = autoresAPI?. autores ?: emptyList()
                withContext(Dispatchers.Main) {
                    adaptadorRecyclerView.changelist(autores)
                    adaptadorRecyclerView.notifyDataSetChanged()
                }
            }else{
                Toast.makeText(applicationContext, "error API", Toast.LENGTH_SHORT).show()
            }
        }
    }



}