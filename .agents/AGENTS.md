# Project Rules - pg_managment

This file defines the project-specific rules, architectural patterns, and development guidelines for the `pg_managment` Flutter application. Follow these rules strictly when adding features, refactoring, or updating files.

## 1. Environment & Commands

- **Flutter Management:** The project uses **FVM (Flutter Version Management)** with Flutter version `3.35.0` (as specified in `.fvmrc`).
- **Command Prefixing:** Prefix all Flutter/Dart CLI commands with `fvm`.
  - Fetch dependencies: `fvm flutter pub get`
  - Run code analyzer: `fvm flutter analyze`
  - Run code formatter: `fvm flutter format .`
  - Run project: `fvm flutter run`
- **SDK Constraints:** Target Dart SDK is `^3.8.0` (as specified in `pubspec.yaml`).

## 2. Package Name & Imports

- **Important Spelling:** The Flutter package name is spelled **`pg_managment`** (missing the first 'e' in management).
- **Imports:** Always use package-relative imports with the correct spelling:
  `import 'package:pg_managment/...';`
  Avoid relative imports that traverse out of the `lib` folder structure.

## 3. Architecture & State Management (GetX)

The project utilizes a structured model-view-controller-binding pattern powered by the **GetX** framework.

### Screen Structure
Every screen must reside in its own folder under `lib/presentation/<screen_name>_screen/`. The directory structure for a screen:
- `<screen_name>_screen.dart` (The view file, holds the widget layout and uses `Obx` for reactive rendering)
- `binding/`
  - `<screen_name>_screen_binding.dart` (Defines screen bindings and dependency injections using `Get.lazyPut`)
- `controller/`
  - `<screen_name>_screen_controller.dart` (Holds business logic, reactive state variables, and network requests)
- `model/`
  - Screen-specific models (if they are unique/scoped to this screen)
- `widgets/`
  - Custom UI widgets specific to the screen

### State Reactivity
- Always use `Rx` variables (e.g. `RxBool`, `RxInt`, `Rx<Model>`, `.obs`) inside the controllers.
- Wrap responsive UI elements in screens using `Obx(...)` widgets to observe state changes.

### Routing
- Routes are managed in `lib/routes/app_routes.dart`.
- When adding a new screen:
  1. Define a route name constant (e.g., `static const String myNewScreenRoute = '/my_new_screen';`).
  2. Add the corresponding `GetPage` entry with its builder, bindings, and transition style in the `pages` list.

## 4. Networking & Local Storage

- **API Requests:** Do not make raw HTTP requests directly in controllers or widgets. Always use the central `ApiService` (located in `lib/ApiServices/api_service.dart`) which extends `GetConnect`.
  - For GET requests: `ApiService().callGetApi(...)`
  - For POST requests: `ApiService().callPostApi(...)`
  - For PUT requests: `ApiService().callPutApi(...)`
  - For DELETE requests: `ApiService().callDeleteApi(...)`
- **Local Settings / Persistence:** Use `PrefUtils` (located in `lib/core/utils/pref_utils.dart`) for reading/writing persistence data using `SharedPreferences`. All method calls should be static (e.g., `PrefUtils.getString(key)`).

## 5. Styling, Constants & Assets

- **Colors:** Define and access colors using `ColorConstant` in `lib/core/utils/color_constant.dart`. Avoid hardcoded Hex values or Material color classes in UI code.
- **Typography & Styling:** Define styles in `lib/theme/app_style.dart`. Font family used is `Inter` or `Gilroy` variants.
- **Images/Icons:** Register constant strings for asset paths in `lib/core/utils/image_constant.dart`.
- **Assets Registration:** Any new image, animation, font, or icon added must be declared in `pubspec.yaml` under the `flutter: assets` section.

## 6. Code Style & Formatting

- Maintain trailing commas in widget trees to preserve clean formatting.
- Check code analyzer warnings regularly with `fvm flutter analyze` and fix any issues immediately.
