# Percon Travel App Case Study (Flutter ile Firebase Tabanlı Seyahat Uygulaması Geliştirme)

A Flutter travel application developed as a case study to demonstrate best practices in mobile app development, focusing on clean architecture, state management, and persistent data storage.

## 🌟 Features

- Travel Exploration: Browse and discover various travel destinations
- Favorites System: Save your favorite travels with persistent storage using SharedPreferences
- Dynamic UI: Toggle between list and grid views for travel listings
- Clean Architecture: Well-structured codebase following SOLID principles
- State Management: Cubit-based state management for predictable UI updates
- Comprehensive Testing: Unit tests for critical business logic

## 🛠 Tech Stack

- Framework: Flutter/Dart
- State Management: Cubit (flutter_bloc)
- Local Storage: SharedPreferences
- Architecture: Clean Architecture (Service → Repository → Cubit → UI)
- Testing: flutter_test

## 🏗 Architecture

The app follows a layered architecture pattern:

lib/
├── core/          # Core utilities, helpers, and shared components
├── feat/          # Feature modules
│   ├── data/      # Data models, services, and repositories
│   └── presentation/ # UI components, Cubits, and pages


### Key Components

- TravelService: Handles data operations and SharedPreferences integration
- TravelRepository: Abstracts data sources and provides clean APIs
- TravelCubit: Manages application state for travel listings and favorites
- CacheHelper: Utility class for SharedPreferences operations

## 🚀 Getting Started

1. Clone the repository:
   bash
   git clone <repository-url>
   cd percon_travel_app
   

2. Install dependencies:
   bash
   flutter pub get
   

3. Run the app:
   bash
   flutter run
   

## 🧪 Testing

Run the test suite:
bash
flutter test


## 📱 Key Implementations

### Persistent Favorites
Favorites are stored using SharedPreferences to ensure data persistence across app sessions. The implementation follows these principles:
- Only travel IDs are stored (not full objects) for efficiency
- Migration logic handles legacy data formats
- Cache inspection capabilities for debugging

### State Management
- Cubit manages all UI state without using setState
- BlocBuilder and BlocConsumer for reactive UI updates
- Proper state immutability with copyWith patterns

## 📁 Project Structure


lib/
├── core/
│   ├── utils/
│   │   └── helper/
│   │       └── cache_helper.dart
│   └── ...
├── feat/
│   ├── data/
│   │   ├── model/
│   │   │   └── travel/
│   │   │       └── travel_model.dart
│   │   ├── repository/
│   │   │   └── travel/
│   │   │       ├── i_travel_repository.dart
│   │   │       └── travel_repository.dart
│   │   └── service/
│   │       └── travel/
│   │           └── travel_service.dart
│   └── presentation/
│       ├── cubit/
│       │   └── home/
│       │       └── travel_cubit.dart
│       └── pages/
│           └── favorite/
│               └── favorite_page.dart




## 🙏 Acknowledgments

- Built with Flutter
- State management powered by flutter_bloc
- Local storage using shared_preferences

---

Developed with ❤ using Flutter
