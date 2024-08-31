package com.example.practicabbddapi

import com.google.gson.annotations.SerializedName

class Autores (var key: String, @SerializedName("birth_date") var naci: String, var name: String){
}