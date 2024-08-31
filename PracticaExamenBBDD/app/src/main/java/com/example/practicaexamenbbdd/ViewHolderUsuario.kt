package com.example.practicaexamenbbdd

import android.view.View
import android.widget.TextView
import androidx.appcompat.widget.Toolbar
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView

class ViewHolderUsuario(itemView: View) : RecyclerView.ViewHolder(itemView) {
    val textViewnombre: TextView
    val textViewmail: TextView
    var card: CardView
    var menucard: Toolbar
    init {
        textViewnombre = itemView.findViewById(R.id.filaNombre)
        textViewmail = itemView.findViewById(R.id.filaEmail)
        menucard=itemView.findViewById(R.id.tbCard)
        card=itemView.findViewById(R.id.card_view)
    }
}
