# Tharwat Pharmacy App (تطبيق صيدلية ثروت)

A production-grade cross-platform pharmacy mobile application built with **Flutter** and **GetX**. The app provides a seamless digital healthcare shopping experience, allowing customers to browse medicines, scan barcodes, manage favorites and carts, place prescription orders, and track real-time deliveries.

---

## 🚀 Key Features

- **Product Discovery & Special Offers**:
  - Featured products, trending items, most ordered medicines, and promotional banners.
  - Interactive categories and subcategories browsing with dynamic filtering.
- **Race-Condition Safe Search**:
  - Live query debouncing with incremental request IDs to discard stale search responses.
  - Independent loading and error states for search vs. page content.
- **Optimized Favorite System**:
  - Scoped UI rebuilds using specific card IDs (`fav_$id`).
  - Concurrent tap protection (`_processingFavoriteIds`) guarding against multiple rapid requests.
  - Guaranteed optimistic rollback restoring both product IDs and cached `ProductModel` on failure.
- **Barcode & QR Scanner**:
  - Integrated `mobile_scanner` with proper lifecycle management and cleanup in `onClose()`.
  - Safe code parsing with input validation.
- **Cart & Prescription Checkout**:
  - Quantity increments/decrements with request locks (`isUpdatingCart`).
  - Safe address validation (`cityId`, `countryId`, `districtId`) before placing orders.
  - Support for multiple payment methods: Cash, InstaPay, Credit/Debit Card, Vodafone Cash.
- **Orders & Delivery Workflow**:
  - Real-time order tracking: Pending, Active, Completed, Cancelled.
  - Dedicated delivery representative portal (`OrdersDeliveryController` & views) with retry-safe infinite scroll.
- **Image Compression**:
  - Intelligent image compression using `flutter_image_compress` targeted to system temporary directories, preventing cache pollution.
- **Theme & Localization**:
  - Dark mode and light mode switching.
  - Dynamic runtime localization (`ar` / `en`) with synchronized preferences.

---

## 🏛️ Architecture & Project Structure

The project follows a clean, organized, layered architecture powered by **GetX**:

```
lib/
├── Controller/             # GetX Controllers managing state, UI events, and lifecycle
│   ├── Auth/               # Login, Sign Up, OTP Verification, Password Reset
│   ├── Delivery View/      # Delivery Orders & Navigation
│   └── Home/               # Home, Products, Cart, Favorites, Categories, Profile
├── Core/                   # Foundation layer
│   ├── Class/              # Api client (Either<StatuesRequest, Map>), StatusRequest
│   ├── Constant/           # App colors, images, themes, API endpoints, contact config
│   ├── function/           # Handling data, safe error parsers, alert dialogs
│   └── middleware/         # Auth & onboarding route guards
├── Data/                   # Data layer
│   ├── Data Source/        # Remote API data sources (Auth, Cart, Orders, Categories, etc.)
│   └── Model/              # JSON serializable data models (Products, Cart, Order, User)
└── View/                   # Presentation layer
    ├── DeliveryView/       # Delivery representative screens
    ├── Screeens/           # Customer views (Home, Auth, Cart, Profile, Categories)
    └── Widget/             # Modular, reusable UI components
```

### State Management & Lifecycle:
- State is managed via `GetxController` with targeted updates (`update(['fav_$id'])`).
- API instance is centrally registered as a permanent dependency in `main.dart` (`Get.put<Api>(Api(), permanent: true)`).
- All sensitive operations (checkout, order cancellation, profile update, load-more) utilize `try/finally` blocks to guarantee loading flags reset.

### Networking & Data Handling:
- Built on `http` wrapped with `dartz` `Either<StatuesRequest, dynamic>`.
- Supports all HTTP `2xx` responses including `204 No Content`.
- Safe URL building via `Api.buildUrl` ensuring proper percent-encoding for Arabic queries and special characters.
- Centralized `parseErrorMessage` parsing multiple backend error shapes (`error.message`, `message`, validation maps).

---

## 🛠️ Getting Started

### Prerequisites:
- **Flutter SDK**: `>=3.4.3 <4.0.0`
- **Dart SDK**: `^3.4.3`
- Android Studio / VS Code with Flutter extension
- Android SDK installed (API level 21+)

### Installation:
1. Clone the repository:
   ```bash
   git clone https://github.com/KareemElshnabi2003/Tharwat_Pharamcy_App.git
   cd Tharwat_Pharamcy_App
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis:
   ```bash
   flutter analyze
   ```

4. Run unit tests:
   ```bash
   flutter test
   ```

5. Run the application:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

The test suite covers:
- Scoped Favorite optimistic updates and rollbacks upon API failure.
- Duplicate tap prevention (`_processingFavoriteIds`).
- Search race condition handling with incremental request IDs.
- Retry-safe pagination behavior without skipping page indexes on failure.
- Handling of HTTP 204 No Content and empty response bodies in `Api`.
- Filter stock query mapping (`In-stack` -> `"1"`, `Out-of-stack` -> `"0"`, `All` -> `""`).
- `OrderModel.toJson()` field mapping verification.

To run tests:
```bash
flutter test
```
