package com.example.myapplication

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView

class MainActivity : AppCompatActivity() {

    private lateinit var sum: Button
    private lateinit var res: Button
    private lateinit var mul: Button
    private lateinit var divi: Button

    private lateinit var edit1 : EditText
    private lateinit var edit2 : EditText

    private lateinit var resultado: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        edit1 = findViewById(R.id.edit1)
        edit2 = findViewById(R.id.edit2)

        sum = findViewById(R.id.button_id1)
        res = findViewById(R.id.button_id2)
        mul = findViewById(R.id.button_id3)
        divi = findViewById(R.id.button_id4)

        resultado = findViewById(R.id.rseulta)

        sum.setOnClickListener {
            resultado.setText(edit1.text.toString().toInt()+ edit2.text.toString().toInt())

        }


        res.setOnClickListener {
            resultado.text = res.toString()

        }

        mul.setOnClickListener {
            resultado.text = res.toString()

        }

        divi.setOnClickListener {
            resultado.text = res.toString()

        }



    }
}
