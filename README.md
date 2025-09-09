# HamsterPOS - Mini E-Commerce Flutter Challenge

This repository contains the complete solution for the Flutter Mini-E-Commerce (Admin + User) coding challenge. The project is structured as a modular monolith with a Spring Boot backend and a Flutter frontend, demonstrating a full-stack application that is clean, scalable, and ready for future microservice extraction.

## Demo

*(A short screen recording demonstrating the user and admin flows has been included in the submission email.)*

---

## Project Overview

The application is a lightweight e-commerce platform with two primary roles: **Customer** and **Admin**.

-   **Customers** can register, log in, browse a product catalog, view product details, manage a shopping cart, place orders, and view their order history.
-   **Admins** can perform all customer actions, plus manage the product catalog (add new products) and view administrative data (all system orders, low-stock items).

### Core Features Implemented

-   **Full Authentication Flow:** Secure JWT-based authentication for both user and admin roles, including registration, login, and logout.
-   **Role-Based UI:** The UI adapts based on user role (e.g., the Admin Panel button is only visible to admins).
-   **Product Catalog:** Dynamic, grid-based product listing from the backend with "Out of Stock" indicators.
-   **Client-Side Shopping Cart:** In-app cart state management with validation against product stock.
-   **Transactional Order Management:** Users can place orders, which atomically decrements stock on the backend.
-   **Order History:** Users can view their past orders.
-   **Complete Admin Panel:** A dedicated, role-protected interface with tabs for adding products, viewing all system orders, and viewing low-stock items.
-   **Robust API:** A well-structured REST API with professional, structured error messages for all scenarios (e.g., 401, 403, 404, 409).

---

## Tech Stack & Architecture

### Backend
-   **Framework:** Spring Boot 3+ (Java 17+)
-   **Database:** PostgreSQL
-   **Security:** Spring Security 6+ with JWT for stateless authentication and BCrypt for password encoding.
-   **Architecture:** **Modular Monolith**. The backend is organized by feature (`user`, `product`, `order`, `admin`) to create clear domain boundaries. This makes the codebase very maintainable and serves as a direct blueprint for future migration to microservices.

### Frontend
-   **Framework:** Flutter (Stable Channel)
-   **State Management:** **Riverpod**.
-   **Networking:** **Dio**.
-   **Navigation:** **GoRouter**.
-   **Local Storage:** **SharedPreferences**.

---

## Getting Started

### Prerequisites
-   Java 17+ / JDK
-   PostgreSQL Server
-   Flutter SDK (Stable Channel)
-   **IDE:** IntelliJ IDEA (for Backend), VS Code (for Frontend)
-   **VS Code Extensions:** The official `Flutter` and `Dart` extensions are required.

### Backend Setup

1.  **Database Setup:** Create a new PostgreSQL database named `hamsterpos` and a user with access credentials.
2.  **Configuration:** In `backend/src/main/resources/application.properties`, update the `spring.datasource.*` properties to match your local PostgreSQL setup. This file also stores the default credentials for the auto-created admin user.
3.  **Run:** Open the `backend` folder in IntelliJ and run the `BackendApplication.java` class. The server will start on `http://localhost:8081`.

### Frontend Setup

1.  **Get Dependencies:**
    -   Navigate to the `frontend` directory in your terminal:
        ```bash
        cd frontend
        flutter pub get
        ```

2.  **Run the Application (Important):**
    -   Ensure your Spring Boot backend is running.

    -   **Primary Method (Web):**
        -   The most reliable way to run this project is on the **Chrome browser**.
        -   Open a terminal in the `frontend` directory and execute the following command:
            ```bash
            flutter run -d chrome --web-port 8088
            ```
        -   This will launch the app on the correct port to communicate with the backend.

    -   **Note:** The `ApiClient` is configured to connect to the backend at `http://localhost:8081` for web and `http://10.0.2.2:8081` for the Android emulator. The backend's CORS policy allows these origins.

---

## Architectural Decisions & Trade-offs

### Time Allocation & Project Strategy

This project was completed over a 5-day period. The strategy was to build and stabilize the backend API first, while concurrently researching and planning the frontend architecture, leading to a rapid and efficient frontend implementation in the final days.

-   **Day 1-2: Backend Foundation & Core APIs**
    -   **Focus:** Establishing a robust, feature-complete backend.
    -   **Tasks:** Set up the Spring Boot project, database, and a `package-by-feature` architecture. Implemented the full Product CRUD API and the core `User` entity and repository.

-   **Day 3: Backend Security & Frontend Research**
    -   **Focus:** Securing the backend and finalizing the frontend technology stack.
    -   **Tasks (Backend):** Implemented a complete, end-to-end JWT authentication system.
    -   **Tasks (Frontend Research):** Researched Flutter state management options and chose the **Riverpod** (`StateNotifier` + `FutureProvider`) stack for its balance of simplicity and power, which was ideal for a developer new to the framework. The core stack (`Dio`, `GoRouter`, `SharedPreferences`) was also finalized.

-   **Day 4: Backend Polish & Frontend Foundation**
    -   **Focus:** Finalizing all backend requirements and scaffolding the Flutter application.
    -   **Tasks (Backend):** Implemented role-based security, the transactional `Order` service, and all admin endpoints. A `GlobalExceptionHandler` and DTOs for all API responses were added to complete the clean, consistent API.
    -   **Tasks (Frontend):** Kicked off the Flutter implementation, setting up the foundational `ApiClient` with JWT interceptors, the router, and core providers.

-   **Day 5: Full Frontend Implementation & Integration**
    -   **Focus:** Rapidly building all UI screens and features on the established foundation.
    -   **Tasks:** Implemented and tested the full end-to-end user and admin flows, including a reusable `MainAppBar` for consistent navigation and UX.

### Key Decisions
-   **Backend (Modular Monolith):** The current structure was chosen for scalability and to serve as a clear blueprint for a potential microservices migration.
-   **API Design (DTOs & Centralized Errors):** Data Transfer Objects (DTOs) are used for all API communication to decouple the API contract from database entities, enhancing security. A `GlobalExceptionHandler` provides consistent, structured JSON error responses for all scenarios.
-   **Frontend State Management :** Riverpod was chosen because it helps keep the code organized and catches errors early. While aware of the modern `AsyncNotifier`, I deliberately used the more explicit `StateNotifier` + `FutureProvider` pattern. This was a strategic choice to ensure the code was highly readable and easy to understand, which I prioritized for this challenge as a newcomer to Flutter.
-   **Frontend Networking (Dio):** Dio was chosen for its interceptor system, which was used to automatically attach the JWT `Authorization` header to every authenticated request.


### Prioritization & Scope Management
Given the 5-day time constraint, I prioritized delivering a robust, end-to-end functional application. This meant making a conscious trade-off to postpone certain non-critical UX polish and a full test suite in favor of a complete feature set. Key areas for future improvement would include:
-   **UX Polish:** Implementing shimmer loading effects and pull-to-refresh on lists.
-   **Testing:** Building out the full suite of unit and widget tests.
-   **Edge Cases:** Adding quantity controls in the cart and automatic redirection on token expiry.

Thank you for the opportunity to take on this challenge.