package com.example.practicaexamenbbdd

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query

@Dao
interface UsuarioDAO{
    @Query("Select * from users")
    fun selectAll(): List<Usuario>
    @Insert
    fun insert(usuario: Usuario): Long
    @Delete
    fun delete(usuario: Usuario)
}
