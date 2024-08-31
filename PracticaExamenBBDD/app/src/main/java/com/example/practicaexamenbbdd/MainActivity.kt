package com.example.practicaexamenbbdd

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.inputmethod.InputMethodManager
import android.widget.Button
import android.widget.EditText
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : AppCompatActivity() {
    private lateinit var nombre: EditText
    private lateinit var mail: EditText
    private lateinit var agregar: Button
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        //binding
        nombre = findViewById(R.id.editTnombre)
        mail = findViewById(R.id.editTemail)
        agregar = findViewById(R.id.butAgregar)

        //recyclerview
        val recyclerViewpeliculas: RecyclerView
        recyclerViewpeliculas = findViewById(R.id.recyclerViewPeliculas)
        val adaptadorRecyclerView = AdaptadorUsuarios(applicationContext)
        recyclerViewpeliculas.layoutManager = LinearLayoutManager(
            applicationContext,
            LinearLayoutManager.VERTICAL, false
        )
        recyclerViewpeliculas.setAdapter(adaptadorRecyclerView)
        var datos_usuarios: MutableList<Usuario>
        //cargar datos al recycler
        GlobalScope.launch(Dispatchers.IO) {
            val database = UsuariosBBDD.getInstance(applicationContext)
            //database.usuarioDAO().insert(Usuario("Daniel", "daniel.amiguet@murciaeduca.es"))
            datos_usuarios = database.usuarioDAO().selectAll() as MutableList<Usuario>
            withContext(Dispatchers.Main) {
                adaptadorRecyclerView.changeList(datos_usuarios as MutableList<Usuario>)
             }
            }
        agregar.setOnClickListener{
            GlobalScope.launch(Dispatchers.IO) {
                    val database = UsuariosBBDD.getInstance(applicationContext)
                    database.usuarioDAO().insert(Usuario(nombre.text.toString(), mail.text.toString()))
                    val nueva_lista = database.usuarioDAO().selectAll();
                    withContext(Dispatchers.Main) {
                        adaptadorRecyclerView.changeList(nueva_lista as MutableList<Usuario>)
                    }
                 }
                val inputMethodManager = getSystemService(INPUT_METHOD_SERVICE) as
                        InputMethodManager
                inputMethodManager.hideSoftInputFromWindow(agregar.getWindowToken(), 0)
            }

        adaptadorRecyclerView.setAdaptadorCallback(object:AdaptadorUsuarios.AdaptadorCallback{
            override fun onDeleteUsuario(usu: Usuario) {
                GlobalScope.launch(Dispatchers.IO) {
                    val database = UsuariosBBDD.getInstance(applicationContext)
                    database.usuarioDAO().delete(usu)
                    var datos = database?.usuarioDAO()?.selectAll() as MutableList<Usuario>
                    withContext(Dispatchers.Main) {
                        adaptadorRecyclerView.changeList(datos as MutableList<Usuario>)
                    }
                }
            }
        })


        }
    }