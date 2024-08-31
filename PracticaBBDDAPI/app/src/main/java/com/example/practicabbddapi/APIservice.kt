package com.example.practicabbddapi

import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Url

interface APIservice {
    @GET
    suspend fun getAutores(@Url url:String): Response<AuthorsResponse>
}
