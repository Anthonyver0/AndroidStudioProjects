package com.example.practicaexamenbbdd

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView

class AdaptadorUsuarios : RecyclerView.Adapter<ViewHolderUsuario> {
    private var usuarios: MutableList<Usuario>

    constructor(applicationContext: Context) {
        usuarios = ArrayList()
    }

    private lateinit var listener: AdaptadorCallback
    interface AdaptadorCallback{
        fun onDeleteUsuario(usu: Usuario)
    }
    fun setAdaptadorCallback(listener: AdaptadorCallback) {
        this.listener = listener
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolderUsuario {
        val vista: View =
            LayoutInflater.from(parent.context).inflate(R.layout.fila_usuarios, parent, false)
        val viewHolder = ViewHolderUsuario(vista)
        viewHolder.menucard.inflateMenu(R.menu.menu_fila)
        return viewHolder
    }
    override fun getItemCount(): Int {
        return this.usuarios.size
    }
    override fun onBindViewHolder(holder: ViewHolderUsuario, position: Int) {
        val usu: Usuario = this.usuarios[position]
        holder.textViewnombre.text =usu.nombre
        holder.textViewmail.text=usu.correo
        holder.menucard.setOnMenuItemClickListener{
            when(it.itemId){
                R.id.action_borrar->{
                    listener.onDeleteUsuario(usu)
                    true
                }
                else -> {true}
            }
        }
    }

    fun changeList(usuarios: MutableList<Usuario>) {
        this.usuarios=usuarios
        notifyDataSetChanged()

    }
}
