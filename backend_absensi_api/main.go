package main

import (
	"backend_absensi_api/config"
	"backend_absensi_api/controllers"
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func main() {
	app := fiber.New()                                   // menjalankan fungsi app fiber
	config.DatabaseConnection()                          // Koneksi ke database
	app.Use(cors.New(cors.Config{AllowOrigins: "*"}))    // Mengizinkan semua origin untuk akses API
	app.Post("/login", controllers.LoginOrRegister)      // Untuk halaman login
	app.Post("/absen", controllers.SubmitAbsen)          // Untuk fitur 1, absensi
	app.Get("/user/:id", controllers.GetUserData)        // Pemilihan user
	app.Get("/histori/:user_id", controllers.GetHistori) // Untuk fitur 2, histori
	port := os.Getenv("PORT")                            // Mengambil port dari import os
	if port == "" {
		port = "3000" // Default port jika dilakukannya fallback
	}
	log.Fatal(app.Listen(":" + port)) // Port listener supaya dart bisa run di port ini
}
