# StreakCode 🚀🔥

**StreakCode** is a mobile application designed to help developers track their daily coding consistency. Built with a focus on building habits, it features a "Streak" system that motivates users to code every day without breaking the chain.

## 📱 Tech Stack

### Frontend (Mobile)
- **Framework:** Flutter (Dart)
- **State Management:** `setState` (Native)
- **Networking:** `http` package
- **Local Features:** - `flutter_local_notifications` (Daily Reminders)
  - `timezone` (Scheduling)
  - `table_calendar` (Visual History)
  - `intl` (Date Formatting)

### Backend (API)
- **Language:** Go (Golang)
- **Framework:** Fiber v2
- **ORM:** GORM
- **Database:** MySQL
- **Architecture:** RESTful API (MVC Pattern)

---

## 🔥 Key Features

1.  **Smart Login System**
    - Auto-detection: Registers new users automatically or logs in existing ones based on username.
  
2.  **Streak Logic Engine**
    - **Increment:** Adds +1 streak if the user checks in consecutively (24-hour window).
    - **Reset:** Resets streak to 0 or 1 if the user skips a day.
    - **Visual Indicator:** The streak box turns **Orange** only if the user has checked in *today*. It remains **Grey** if the user has a streak but hasn't checked in yet for the current day.

3.  **Real-time History & Calendar**
    - List view of all coding sessions with descriptions.
    - Interactive Calendar view marking active days.
    - Accurate Timezone handling (WIB/Local Time) ensuring no date shifting between Server and App.

4.  **Daily "Don't Forget" Notifications**
    - Local Push Notification scheduled automatically at **11:00 AM** daily.
    - Handles Android 13+ Permissions (`POST_NOTIFICATIONS`).
    - Implements `RECEIVE_BOOT_COMPLETED` to reschedule alarms after device restart.

---

## 🛠️ Project Challenges & Solutions

During the development, several complex engineering challenges were solved:

-   **Timezone Synchronization:** Fixed a 7-hour discrepancy between the Go server (UTC) and Flutter App (Local) by forcing `loc=Local` in DSN and using `.toLocal()` parsing in Dart.
-   **Streak Color Logic:** Implemented a backend flag `is_today` to synchronize the UI state, ensuring users know exactly when they need to check in.
-   **Android Backward Compatibility:** Enabled **Core Library Desugaring** in Gradle to allow modern Java 8 time APIs (used by notification logic) to run on older Android devices.

---

## 🚀 How to Run

### 1. Backend Setup
1.  Clone the repository.
2.  Import the database schema to MySQL.
3.  Configure `database.go` with your credentials.
4.  Run the server:
    ```bash
    go run main.go
    ```

### 2. Frontend Setup
1.  Navigate to the Flutter project folder.
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the app (Ensure backend is running):
    ```bash
    flutter run
    ```
    *Note: If running on Android Emulator, ensure API URL is set to `10.0.2.2`.*

---

## 📸 Screenshots

![WhatsApp Image 2026-01-12 at 14 07 57](https://github.com/user-attachments/assets/0f4d6c1c-feee-41f7-b334-cec2afd6df09)
![WhatsApp Image 2026-01-12 at 14 07 57 (1)](https://github.com/user-attachments/assets/7b05cdbb-0f3a-4ce2-9471-b284b1833db5)

---

## 👨‍💻 Author : Abedehakims

Built with ❤️ as a portfolio project to demonstrate Fullstack Mobile Development capabilities.
