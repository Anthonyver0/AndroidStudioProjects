package com.example.ejercicio01thony

import android.annotation.SuppressLint
import android.opengl.Visibility
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast



const val nombre1:String="hola";
const val Contra1:String="123456";

class MainActivity : AppCompatActivity() {


    private lateinit var CodError:TextView
    private lateinit var NombreUser:EditText
    private lateinit var Contraseña:EditText
    private lateinit var Boton:Button

    override fun onCreate(savedInstanceState: Bundle?) {


        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        CodError = findViewById(R.id.Error)
        Boton = findViewById(R.id.button2)
        NombreUser = findViewById(R.id.NombreUser)
        Contraseña = findViewById(R.id.Contraseña)


        val nombre = NombreUser.text;
        val contraseña = Contraseña.text



        Boton.setOnClickListener {
            //Toast.makeText(this, contraseña.toString()+ Contra1, Toast.LENGTH_SHORT).show()

            if ((!nombre.toString().equals(nombre1)) ) {
            //if ((!contraseña.toString().equals(Contra1))) {
                CodError.setVisibility(View.VISIBLE);
                Toast.makeText(this, "Nombre mal puesto", Toast.LENGTH_SHORT).show()

            }
            else if((!contraseña.toString().equals(Contra1)))
            {
                CodError.setVisibility(View.VISIBLE);
                Toast.makeText(this, "Contraseña mal puesta", Toast.LENGTH_SHORT).show()
            }
        }





    }





}

