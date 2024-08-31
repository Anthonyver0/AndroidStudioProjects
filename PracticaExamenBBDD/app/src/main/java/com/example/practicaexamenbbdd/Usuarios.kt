package com.example.practicaexamenbbdd

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "users")
data class Usuario(
    @ColumnInfo(name = "name") var nombre:String,
    @ColumnInfo(name = "email") var correo: String
) {
    @PrimaryKey(autoGenerate = true) var id: Int =0;
}