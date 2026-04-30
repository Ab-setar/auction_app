# 📱 Online Auction System (Flutter Mobile App)

A Flutter mobile application that simulates an auction platform with product browsing, bidding, fraud detection, notifications, and persistent user data.

---

## 📌 Project Description

The **Online Auction System** is a mobile application developed using Flutter that allows users to:

* Browse auction items
* Place bids
* Receive real-time feedback
* Store user data locally

This project was developed following the Mobile Application Development course guidelines and demonstrates key concepts such as UI design, navigation, API integration, local storage, and plugin usage.

---

## 🚀 Features

* 🔐 **Login System** — username validation with Snackbar feedback
* 🛍️ **Product Listing** — fetches live data from Fake Store API
* 📄 **Product Detail** — view product info and place bids
* 💰 **Bidding System** — validates bid against current price
* 🧠 **Fraud Detection** — detects rapid bidding behavior
* 🔔 **Local Notifications** — alerts user on successful bid
* 💾 **Persistent Storage** — saves username and last bid
* 👤 **Profile Screen** — displays stored user data
* 🚫 **Blacklist Simulation** — restricts suspicious users (if implemented)
* ⭐ **Recommendation System** — highlights selected items (simple logic)

---

## 📱 Application Screens

1. Login Screen
2. Home Screen
3. Product List Screen
4. Product Detail Screen
5. Profile Screen

---

## 🔄 Use Case Trace: Place Bid (MANDATORY)

### 1. User Interaction

User enters bid amount and clicks "Place Bid" button
Handled in:

```dart
onPressed: placeBid
```

### 2. UI Response

Snackbar displays success or error message:

```dart
ScaffoldMessenger.of(context).showSnackBar(...)
```

### 3. Logic Execution

Bid validation logic:

```dart
if (bid > currentPrice)
```

### 4. Data Processing

UI updated using:

```dart
setState(() { ... })
```

### 5. Storage / API Action

Bid saved locally using SharedPreferences

### 6. Final Result

* Updated bid displayed
* Notification triggered
* Data stored for later use

---

## 🧱 Project Structure

```
lib/
├── main.dart
├── models/
│   └── product.dart
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── products_screen.dart
│   ├── product_detail_screen.dart
│   └── profile_screen.dart
└── services/
    ├── product_service.dart
    ├── prefs_service.dart
    ├── notification_service.dart
    └── fraud_detector.dart
```

---

## 🌐 API Used

* https://fakestoreapi.com/products

---

## ⚙️ Technologies Used

* Flutter (Dart)
* HTTP (API requests)
* SharedPreferences (local storage)
* flutter_local_notifications (device feature)

---

## 📦 APK File

Location:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🎥 Presentation Video

👉 Paste your Loom video link here

---

## 👥 Group Members

| Name     | ID    |
| -------- | ----- |
| Abdulaziz mustefa | 0030/15 |
| Abdusetar mohammed | 0053/15 |
| Behailu Birhanu | 0199/15 |
| Eyuel Eyasu |0393 |
| Nihan Wemaye | 0915/15 |

---

## 🧠 Fraud Detection Logic

* Detects **3 bids within 10 seconds**
* Blocks further bidding temporarily
* Shows warning dialog
* Implemented in:

```
lib/services/fraud_detector.dart
```

---

## 📝 Notes

* Advanced features like AI and blockchain are simulated for demonstration
* Focus is on fulfilling course requirements with working functionality

---

## ✅ Status

✔ Completed and ready for submission
