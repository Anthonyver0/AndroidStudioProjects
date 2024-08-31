package com.example.repeticion

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast








class MainActivity : AppCompatActivity() {

    private lateinit var nombre: EditText
    private lateinit var Error: TextView
    private lateinit var contra: EditText
    private lateinit var Boton: Button
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        val user1 = "hola";
        val pass1 = "1234";


        nombre = findViewById(R.id.NombreUser);
        contra = findViewById(R.id.Contraseña);
        Boton = findViewById(R.id.BotLog);
        Error = findViewById(R.id.Error);

        Boton.setOnClickListener {

            if(nombre.text.toString() != user1)
            {
                Toast.makeText(this, "Error de nombre" + nombre.text.toString(), Toast.LENGTH_SHORT).show()
                Error.setVisibility(View.VISIBLE)
            }

            if(contra.text.toString() != pass1)
            {
                Toast.makeText(this, "Error de conbtra", Toast.LENGTH_SHORT).show()
                Error.setVisibility(View.VISIBLE)
            }
        }



    }
}