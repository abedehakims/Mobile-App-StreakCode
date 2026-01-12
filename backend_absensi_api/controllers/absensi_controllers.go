package controllers

import (
	"backend_absensi_api/config"
	"backend_absensi_api/models"
	"time"

	"github.com/gofiber/fiber/v2"
)

func SubmitAbsen(c *fiber.Ctx) error {
	var input struct {
		UserID      uint   `json:"user_id"`
		Description string `json:"description"`
	}
	if err := c.BodyParser(&input); err != nil {
		return c.Status(400).JSON(fiber.Map{"message": "User ID tidak valid"})
	}
	var user models.User
	if err := config.DB.First(&user, input.UserID).Error; err != nil {
		return c.Status(404).JSON(fiber.Map{"message": "User tidak ditemukan"})
	}
	location, _ := time.LoadLocation("Asia/Jakarta")
	now := time.Now().In(location)
	resetStreak := false
	if user.LastAbsen != nil {
		// Selisih hari antara sekarang sama selisih terakhir
		lastAbsenDate := user.LastAbsen.Truncate(24 * time.Hour)
		todayDate := now.Truncate(24 * time.Hour)
		diffInDays := int(todayDate.Sub(lastAbsenDate).Hours() / 24)
		if diffInDays == 0 {
			// Jika user sudah absen hari ini
			return c.Status(400).JSON(fiber.Map{"message": "Kamu sudah melakukan absen hari ini"})
		} else if diffInDays == 1 {
			// Jika user melanjutkan streak untuk besok hari
			user.CurrentStreak += 1
		} else {
			// Putus streak (melewati 1 hari)
			// Simpan streak ke histori
			history := models.StreakHistory{
				UserID:  user.ID,
				Streak:  user.CurrentStreak,
				EndedAt: *user.LastAbsen,
			}
			config.DB.Create(&history)
			user.CurrentStreak = 1
			resetStreak = true
		}
	} else {
		// Absen pertama kali
		user.CurrentStreak = 1
	}
	newPresence := models.Presence{
		UserID:      user.ID,
		Description: input.Description,
		UpdatedAt:   now,
	}
	if err := config.DB.Create(&newPresence).Error; err != nil {
		return c.Status(500).JSON(fiber.Map{"message": "Gagal menyimpan deskripsi ke database"})
	}
	// Melakukan update data streak
	user.LastAbsen = &now
	if err := config.DB.Save(&user).Error; err != nil {
		return c.Status(500).JSON(fiber.Map{
			"message": "Presensi masuk, tetapi gagal update ke streak user:" + err.Error(),
		})
	}
	message := "Absensi coding berhasil!!, Semangat dan terus lanjut ngodingnyaa!!"
	if resetStreak {
		message = "Yah.., Sayang banget, streak coding kamu reset. Ayo mulai lagi ke hari-1!"
	}
	return c.JSON(fiber.Map{
		"message":     message,
		"description": input.Description,
		"data": fiber.Map{
			"id":             user.ID,
			"nama":           user.Nama,
			"current_streak": user.CurrentStreak,
			"last_absen":     user.LastAbsen,
		},
	})
}

func GetUserData(c *fiber.Ctx) error {
	id := c.Params("id")
	var user models.User

	if err := config.DB.First(&user, id).Error; err != nil {
		return c.Status(404).JSON(fiber.Map{"message": "User tidak ditemukan"})
	}
	isAlreadyAbsenToday := false
	if user.LastAbsen != nil {
		todayDate := time.Now().Truncate(24 * time.Hour)
		lastAbsenDate := user.LastAbsen.Truncate(24 * time.Hour)
		if todayDate.Equal(lastAbsenDate) {
			isAlreadyAbsenToday = true
		}
	}

	return c.JSON(fiber.Map{
		"data": fiber.Map{
			"id":             user.ID,
			"nama":           user.Nama,
			"current_streak": user.CurrentStreak,
			"is_today":       isAlreadyAbsenToday,
			"last_absen":     user.LastAbsen,
		},
	})
}

func GetHistori(c *fiber.Ctx) error {
	userID := c.Params("user_id")
	var presences []models.Presence
	err := config.DB.Where("user_id = ?", userID).Order("id desc").Find(&presences).Error
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"message": "Gagal mengambil histori"})
	}
	return c.JSON(fiber.Map{
		"data": presences,
	})
}
