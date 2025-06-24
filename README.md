# 📱 Flutter User Directory App – Codebase Assignment

A **Flutter-based User Directory App** that fetches user data from an API, supports **pagination**, **offline caching via Hive**, and **real-time internet connectivity detection using Bloc** — all built with **Clean Architecture** and **GetIt for DI**.

---

## 🚀 Features

- **Infinite Scrolling – Loads users dynamically as you scroll** 
- **Bloc for State Management – No setState(), fully reactive**
- **GetIt for DI – Clean and scalable dependency injection**
- **Dio for API Calls – Efficient and powerful networking**
- **Hive Caching – Works offline with local data**
- **Real-Time Connectivity Detection – UI auto-updates on network changes**
- **Clean Architecture – Structured and maintainable codebase**
- **Localization Ready – Easily add multi-language support**

---

## 🏠 Project Structure

```
lib/
├── core/
│   ├── connectivity_bloc/        # Bloc for connectivity state
│   ├── constants/                # colors
│   ├── di/                       # Dependency injection setup
│   ├── error/                    # Error handling classes
│   ├── network/                  # Network status checker
│   ├── service/                  # Common app services
│   ├── theme/                    # App themes and styles
│   ├── utils/                    # Helpers and utility functions

├── feature/user_list/
│   ├── data/
│   │   ├── api/                  # API services (Dio)
│   │   ├── mapper/               # Model ↔ Entity mappers
│   │   ├── models/               # API response models
│   │   ├── repositories/         # Repository implementations
│   │   ├── source/               # Local and remote data sources

│   ├── domain/
│   │   ├── entities/             # Domain models (UserEntity, etc.)
│   │   ├── mapper/               # Domain-specific mappers
│   │   ├── repositories/         # Repository interfaces
│   │   ├── use_cases/            # Business logic layer

│   ├── presentation/
│   │   ├── bloc/                 # Bloc classes (events, states)
│   │   ├── pages/                # Screens/UI views
│   │   ├── widgets/              # Reusable UI components

├── main.dart                     # Application entry point
```

---

## 📺 Setup & Installation

### **1️⃣ Clone the Repository**
```sh
git clone https://github.com/ravneet-neosoft/codebase_project_assignment.git
```

### **2️⃣ Install Dependencies**
```sh
flutter pub get
```

### **3️⃣ Setup Hive for Local Storage**
Run the following command to generate `.g.dart` files for Hive models:
```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

### **4️⃣ Run the App**
```sh
flutter run
```
---


