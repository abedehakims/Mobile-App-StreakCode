package controllers

import (
	"backend_absensi_api/config"
	"backend_absensi_api/models"
	"errors"
	"time"

	"github.com/gofiber/fiber/v2"
	"gorm.io/gorm"
)

func LoginOrRegister(c *fiber.Ctx) error {
	var input struct {
		Nama string `json:"nama"`
	}
	if err := c.BodyParser(&input); err != nil {
		return c.Status(400).JSON(fiber.Map{"message": "Input nama tidak valid"})
	}
	var user models.User
	err := config.DB.Where("nama = ?", input.Nama).First(&user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			user = models.User{Nama: input.Nama, CurrentStreak: 0}
			config.DB.Create(&user)
		} else {
			return c.Status(500).JSON(fiber.Map{"message": "Database Error"})
		}
	}
	return c.Status(200).JSON(fiber.Map{
		"message": "berhasil masuk",
		"data":    user,
	})
}

func ProcessStreak(user *models.User) {
	now := time.Now()
	if user.LastAbsen == nil {
		user.CurrentStreak = 1
	} else {
		diff := now.Sub(*user.LastAbsen).Hours()
		if diff > 24 && diff <= 48 {
			user.CurrentStreak++
		} else if diff > 48 {
			history := models.StreakHistory{
				UserID:  user.ID,
				Streak:  user.CurrentStreak,
				EndedAt: *user.LastAbsen,
			}
			config.DB.Create(&history)

			user.CurrentStreak = 1
		}
	}

	user.LastAbsen = &now
	config.DB.Save(&user)
}
