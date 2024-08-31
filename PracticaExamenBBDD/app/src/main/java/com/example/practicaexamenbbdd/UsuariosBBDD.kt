package com.example.practicaexamenbbdd

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(entities = [Usuario::class], version = 1, exportSchema = false)
abstract class UsuariosBBDD: RoomDatabase(){
    abstract fun usuarioDAO(): UsuarioDAO
    companion object DatabaseBuilder {
        private var INSTANCE: UsuariosBBDD? = null
        fun getInstance(context: Context): UsuariosBBDD {
            if (INSTANCE == null) synchronized(Usuario::class) {
                INSTANCE = buildRoomDB(context)
            }
            return INSTANCE!!
        }

        private fun buildRoomDB(contexto: Context) =
            Room.databaseBuilder(
                contexto.applicationContext, UsuariosBBDD::class.java, "usuarios.db"
            ).build()
        }
    }