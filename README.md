# WhatsApp Clone

A modern, feature-rich real-time messaging application built with Flutter, implementing WhatsApp-like functionality with a focus on performance and user experience.

## Features

- Real-time messaging with typing indicators
- User authentication and profile management
- Chat room creation and management
- Push notifications for new messages
- Profile customization with avatar upload
- User presence status (online, offline)
- Contact listing and searching 
- Dark/Light theme support

## Core Functionalities

### 1. Phone Number Internationalization
The application uses a sophisticated phone number handling system:
- **Standardization**: Uses dlibphonenumber for consistent phone number formatting
- **Contact Integration**: 
  - Fetches phone contacts using FastContacts
  - Filters and processes phone numbers for each contact
  - Maintains a default region code for formatting
- **Caching System**:
  - Static caching of contacts and formatted numbers
  - Memory-efficient handling of large contact lists
  - Duplicate removal through Set operations

### 2. Contact System Integration
A multi-stage process for converting phone contacts to app contacts:
- **Initial Contact Loading**:
  - Retrieves device contacts with essential fields
  - Formats all phone numbers to international format
  - Filters out invalid or empty contacts

- **Profile Matching Process**:
  - Matches formatted phone numbers with registered users
  - Creates AppContact instances with registration status
  - Maintains profile information for matched contacts


### 3. Chat Profile Management
Real-time chat profile system with efficient data handling:
- **Stream-Based Updates**:
  - Real-time chat updates using Firebase streams
  - Automatic profile updates on changes
  - Efficient error handling with cached fallback

- **Profile Synchronization**:
  - Automatic chat member profile updates
  - Last message and timestamp tracking
  - Unread message count management
  - User presence status integration


## Technologies Used

### Frontend
- Flutter SDK for cross-platform development
- Riverpod for state management
- Go Router for navigation
- Freezed for code generation
- Flutter Local Notifications
- Image Picker for media selection

### Backend Services
- Firebase
  - Firebase Authentication for user management
  - Cloud Firestore for real-time database
  - Firebase Cloud Messaging for push notifications
- Supabase Storage for media storage

### Local Storage
- Hive for efficient local data caching

## Technical Architecture

### State Management
- Implementing Repository Pattern for data layer abstraction
- Using Riverpod for reactive and efficient state management
- StateNotifier for immutable state updates

### Data Flow
```
UI Widget -> Provider -> Notifier -> Repository -> API/Database
```

### Code Generation
- Using Freezed for immutable data models
- JSON serialization for API communication
- Build Runner for code generation

### Performance Optimizations
- Lazy loading for chat messages
- Image caching and compression
- Efficient state updates with Riverpod
- Pagination for large data sets

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Android Studio / VS Code
- Firebase account
- Supabase account
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/whats_clone.git
```

2. Navigate to project directory and install dependencies:
```bash
cd whats_clone
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add your Android/iOS app to Firebase project
   - Download and add the configuration files (google-services.json/GoogleService-Info.plist)
   - Enable Authentication, Firestore, and Storage in Firebase Console

4. Configure Supabase:
   - Create a new Supabase project
   - Add your project URL and anon key to environment variables
   - Set up storage buckets for media files

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── theme/          # App theme and styles
│   ├── routes/         # App routes and navigation
│   └── utils/          # Utility functions and classes
├── state/
│   ├── auth/
|   |       ├── backend/ # Authentication backend
|   |       ├── models/  # Authentication models
|   |       ├── notifiers/ # Authentication notifiers
|   |       └── providers/ # Authentication providers
│   ├── chat/           # Chat-related state management
|   |       ├── models/  # Chat models
|   |       ├── notifiers/ # Chat notifiers
|   |       ├── providers/ # Chat providers
|   |       └── services/ # Chat services
│   ├── others/        # other features
│   └── providers/     # general providers
└── view/
    ├── auth/          # Authentication screens
    ├── chats/         # Chat-related screens
    ├── profile/       # Profile management screens
    ├── others/        # other screens
    └── widgets/       # Shared widgets and components
```

## Environment Setup

### Android
- Minimum SDK version: 21
- Target SDK version: 33
- Compile SDK version: 33

### iOS
- Minimum iOS version: 11.0
- Swift version: 5.0

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- Supabase team for storage solutions
- The open-source community for various packages used in this project
