package models

import (
	"time"
)

type User struct {
	ID            uint       `gorm:"primaryKey" json:"id"`
	Nama          string     `gorm:"type:varchar(100)" json:"nama"`
	CurrentStreak int        `gorm:"default:0" json:"current_streak"`
	LastAbsen     *time.Time `json:"last_absen"`
	CreatedAt     time.Time  `json:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at"`
}

type StreakHistory struct {
	ID      uint      `gorm:"primaryKey" json:"id"`
	UserID  uint      `json:"user_id"`
	Streak  int       `json:"streak"`
	EndedAt time.Time `json:"ended_at"`
}

type Presence struct {
	ID          uint      `gorm:"primaryKey" json:"id"`
	UserID      uint      `json:"user_id"`
	Description string    `gorm:"type:text" json:"description"`
	UpdatedAt   time.Time `json:"updated_at"`
}
