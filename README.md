# 📱 Product Management App

A simple ecommerce mobile application built with Flutter that allows users to create, view, update, and delete products. This app demonstrates core Flutter concepts including navigation, routing, state management, and CRUD operations.

---

## 🚀 Features

- ✅ **Create** – Add new products with title, description, and price
- ✅ **Read** – View all products in a list and view individual product details
- ✅ **Update** – Edit existing product information
- ✅ **Delete** – Remove products from the list
- ✅ **Navigation** – Smooth navigation between screens with named routes
- ✅ **Data Passing** – Seamless data transfer between screens using arguments
- ✅ **State Management** – Real-time UI updates using `setState()`

---

## 📸 Screens

| Home Screen | Add/Edit Screen | Detail Screen |
| :---: | :---: | :---: |
| Displays all products in a list | Form to add or edit a product | Shows product details with edit/delete options |
| FAB to add new products | Pre-filled when editing | Edit button in AppBar |
| Tap a product to view details | Save/Cancel buttons | Delete button at bottom |

---

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: `setState()`
- **Navigation**: Named Routes with `Navigator`

---

## 📁 Project Structure

```
📁 lib/
├── 📁 models/
│   └── 📄 product.dart          # Product model class
├── 📁 screens/
│   ├── 📄 home.dart             # Home screen (product list)
│   ├── 📄 add_edit.dart         # Add/Edit product screen
│   └── 📄 detail.dart           # Product detail screen
├── 📄 main.dart                 # App entry point & route configuration
└── 📄 README.md                 # Project documentation
```

---

## 🔧 Installation & Setup

### Prerequisites

- Flutter SDK (3.x or higher)
- Dart SDK (3.x or higher)
- Android Studio / VS Code
- Android Emulator or physical device

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Bereket-Ketema/2026-project-phase-mobile-tasks-/tree/main/on-boarding/product_7.com
   cd product_7
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Build for production**
   ```bash
   flutter build apk --release
   ```

---

## 🧭 Navigation Structure

| Route | Screen | Description |
| :--- | :--- | :--- |
| `/` | Home | Main screen displaying all products |
| `/add-edit` | AddEdit | Form to add or edit a product |
| `/detail` | Detail | View product details with edit/delete |

### Navigation Examples

```dart
// Navigate to Add/Edit (Add mode)
Navigator.pushNamed(context, '/add-edit', arguments: null);

// Navigate to Add/Edit (Edit mode)
Navigator.pushNamed(context, '/add-edit', arguments: product);

// Navigate to Detail
Navigator.pushNamed(context, '/detail', arguments: product);
```

---

## 📊 Data Flow

```
┌─────────────┐     pushNamed()     ┌─────────────┐
│   Home      │ ─────────────────▶ │  Add/Edit   │
│   Screen    │ ◀───────────────── │   Screen    │
└─────────────┘     pop(Product)   └─────────────┘
       │
       │ pushNamed()
       ▼
┌─────────────┐     pushNamed()     ┌─────────────┐
│   Detail    │ ─────────────────▶ │  Add/Edit   │
│   Screen    │ ◀───────────────── │   Screen    │
└─────────────┘     pop(Product)   └─────────────┘
       │
       │ pop('delete')
       ▼
┌─────────────┐
│   Home      │ ◀── Removes product
│   Screen    │
└─────────────┘
```

---

## 🎯 Key Features Implementation

### Product Model

```dart
class Product {
  final String id;
  String title;
  String description;
  double price;

  Product({required this.id, required this.title, required this.description, required this.price});

  factory Product.create({required String title, required String description, required double price}) {
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      price: price,
    );
  }
}
```

### Named Routes

```dart
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const Home(),
    '/add-edit': (context) => const AddEdit(),
    '/detail': (context) => const Detail(),
  },
)
```

### Passing Data

```dart
// Sending data
Navigator.pushNamed(context, '/detail', arguments: product);

// Receiving data
final product = ModalRoute.of(context)?.settings.arguments as Product;
```

---

## 🧪 Testing

Run the following commands to test the app:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart
```

---

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
| :--- | :--- |
| **"NoSuchMethodError"** | Check if arguments are correctly passed using `ModalRoute.of(context)?.settings.arguments` |
| **Navigation not working** | Ensure routes are properly defined in `MaterialApp` |
| **Data not updating** | Make sure you're calling `setState()` after modifying the list |
| **Emulator not starting** | Check if virtualization is enabled in BIOS |

---

## 📝 Submission Guidelines

This project fulfills the following requirements:

| Requirement | Status |
| :--- | :--- |
| Home screen with product list | ✅ |
| Add/Edit product screen | ✅ |
| View product detail screen | ✅ |
| Named routes | ✅ |
| Passing data between screens | ✅ |
| Navigation animations | ✅ (PageRouteBuilder) |
| Handle back button | ✅ |
| CRUD operations | ✅ |

---

## 👨‍💻 Author

- **Bereket Ketema** – [Bereket-Ketema](https://github.com/Bereket-Ketema)

---

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- Dart Team for the powerful language
- All contributors and reviewers

---

## 📬 Contact

For any questions or feedback, please reach out at:
- **Email**: bekishet@gmail.com
- **GitHub**: [bereket-ketema](https://github.com/bereket-ketema)

---

**Built with ❤️ using Flutter**
```