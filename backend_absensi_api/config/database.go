package config

import (
	"backend_absensi_api/models"
	"fmt"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func DatabaseConnection() {
	err := godotenv.Load()
	if err != nil {
		fmt.Println("Error loading .env file")
	}
	dbUSER := os.Getenv("DB_USER")
	dbPASS := os.Getenv("DB_PASS")
	dbHOST := os.Getenv("DB_HOST")
	dbPORT := os.Getenv("DB_PORT")
	dbNAME := os.Getenv("DB_NAME")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local", dbUSER, dbPASS, dbHOST, dbPORT, dbNAME)
	database, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})

	if err != nil {
		fmt.Println("Detail Error DB:", err.Error())
		panic("Koneksi ke Database gagal")
	}
	DB = database
	DB.AutoMigrate(&models.User{}, &models.StreakHistory{}, &models.Presence{})
	fmt.Println("Koneksi ke Database BERHASILLL!! CIHUYY!!")
}
