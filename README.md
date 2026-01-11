# 🌱 GreenEye - Agricultural Intelligence Platform

**GreenEye** is a comprehensive agricultural intelligence platform that leverages machine learning and real-time environmental data to provide farmers and agricultural professionals with actionable insights. The platform offers crop disease detection, crop recommendations, desertification analysis, and forecasting capabilities.

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Getting Started](#-getting-started)
- [API Documentation](#-api-documentation)
- [Configuration](#-configuration)
- [Project Structure](#-project-structure)

## ✨ Features

### 🔐 Authentication & Authorization
- **User Registration** with email verification via OTP
- **JWT-based Authentication** with refresh token support
- **Password Recovery** with OTP verification
- **Role-based Access Control** (Admin, User)
- **Multi-language Support** (English, Arabic)

### 🌾 Crop Disease Detection
- **AI-Powered Disease Detection** from plant images
- **Real-time Image Analysis** using advanced ML models
- **Disease Identification** with confidence scores
- **History Tracking** for all disease detections
- **User-specific History Management**

### 🌿 Crop Recommendation System
- **Intelligent Crop Suggestions** based on:
  - Soil properties (sand, silt, clay, pH, organic carbon)
  - Weather conditions (temperature, humidity, precipitation, solar radiation)
  - Environmental factors (NDVI, land cover type)
  - Nutrient levels (N, P, K)
  - Geographic location
- **Dynamic Feature Extraction** from real-time data sources
- **Location-aware Recommendations** with metadata
- **Recommendation History** for tracking past suggestions

### 🏜️ Desertification Classification
- **Current Desertification Level Assessment**
- **Real-time Environmental Analysis**
- **Geographic-based Classification**
- **Multi-factor Analysis** including:
  - Soil characteristics
  - Vegetation indices (NDVI)
  - Climate data
  - Land cover information

### 📊 Desertification Forecasting
- **Future Desertification Predictions**
- **12-Month Historical Data Analysis**
- **Trend Analysis and Visualization**
- **Location-specific Forecasts**
- **User Forecast History Tracking**

## 🏗️ Architecture

GreenEye follows **Clean Architecture** (Onion Architecture) principles, ensuring:
- **Separation of Concerns**
- **Dependency Inversion**
- **Testability**
- **Maintainability**
- **Scalability**

### Architecture Layers

```
┌─────────────────────────────────────────┐
│     GreenEye.Presentation (API)         │
│  Controllers, Middleware, Localization  │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│      GreenEye.Application               │
│   Services, DTOs, Interfaces, Mapping   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│       GreenEye.Infrastructure           │
│  Data Access, External APIs, Identity   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         GreenEye.Domain                 │
│    Entities, Enums, Interfaces          │
└─────────────────────────────────────────┘
```

## 🛠️ Technology Stack

### Backend Framework
- **.NET 9.0** - Latest .NET framework
- **ASP.NET Core Web API** - RESTful API development
- **Entity Framework Core** - ORM for database operations
- **ASP.NET Core Identity** - Authentication and authorization

### Database
- **SQL Server** - Primary database
- **Entity Framework Core** - Code-first migrations

### Security
- **JWT (JSON Web Tokens)** - Stateless authentication
- **Refresh Tokens** - Extended session management
- **OTP (One-Time Password)** - Email verification
- **Password Hashing** - Secure password storage

### External Integrations
- **Hugging Face ML Models** - AI/ML predictions
- **Real-time Environmental Data APIs** - Weather and soil data
- **SMTP (Gmail)** - Email notifications

### Logging & Monitoring
- **Serilog** - Structured logging
- **File & Console Logging** - Multiple log outputs

### Additional Libraries
- **AutoMapper** - Object-to-object mapping
- **Swagger/OpenAPI** - API documentation
- **CORS** - Cross-origin resource sharing

## 🚀 Getting Started

### Prerequisites

- [.NET 9.0 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) (or SQL Server Express)
- [Visual Studio 2022](https://visualstudio.microsoft.com/) or [VS Code](https://code.visualstudio.com/)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/greeneye-backend.git
   cd greeneye-backend
   ```

2. **Update Connection String**
   
   Edit `appsettings.json` in `GreenEye.Presentation` project:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=YOUR_SERVER;Database=GreenEyeDB;Trusted_Connection=True;TrustServerCertificate=True;"
   }
   ```

3. **Update SMTP Settings**
   
   Configure your email settings in `appsettings.json`:
   ```json
   "SMTP": {
     "Port": 587,
     "Host": "smtp.gmail.com",
     "Email": "your-email@gmail.com",
     "Password": "your-app-password"
   }
   ```

4. **Apply Database Migrations**
   ```bash
   cd GreenEye.Presentation
   dotnet ef database update
   ```

5. **Run the Application**
   ```bash
   dotnet run
   ```

6. **Access Swagger UI**
   
   Navigate to: `https://localhost:7009/swagger`

## 📚 API Documentation

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/Authentication/register` | Register new user with email verification |
| POST | `/api/Authentication/verify-otp` | Verify OTP code |
| POST | `/api/Authentication/login` | User login |
| POST | `/api/Authentication/resend-otp` | Resend OTP code |
| POST | `/api/Authentication/forget-password` | Request password reset |
| POST | `/api/Authentication/reset-password` | Reset password with OTP |
| POST | `/api/Authentication/refresh-token` | Refresh access token |
| POST | `/api/Authentication/revoke-token` | Revoke refresh token |

### Crop Disease Detection

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/CropDisease` | Detect disease from plant image |
| GET | `/api/CropDisease/history` | Get user's detection history |
| DELETE | `/api/CropDisease/delete-history/{id}` | Delete history item |

### Crop Recommendation

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/CropRecommendation/recommend` | Get crop recommendations |
| GET | `/api/CropRecommendation/history` | Get recommendation history |

**Query Parameters:**
- `latitude` (double): Location latitude
- `longitude` (double): Location longitude

### Desertification Classification

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/Classification` | Get current desertification level |

**Query Parameters:**
- `latitude` (double): Location latitude
- `longitude` (double): Location longitude

### Desertification Forecasting

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/Forecasting/forecast` | Get desertification forecast |
| GET | `/api/Forecasting/my-forecasts` | Get user's forecast history |

**Query Parameters:**
- `latitude` (double): Location latitude (-90 to 90)
- `longitude` (double): Location longitude (-180 to 180)

### Response Format

All API responses follow a consistent format:

```json
{
  "isSuccess": true,
  "message": "Success message",
  "data": { /* response data */ }
}
```

## ⚙️ Configuration

### appsettings.json Structure

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Your SQL Server connection string"
  },
  "JWTAuth": {
    "Key": "Your secret key (min 32 characters)",
    "Issuer": "https://localhost:7009",
    "Audience": "https://localhost:7009"
  },
  "SMTP": {
    "Port": 587,
    "Host": "smtp.gmail.com",
    "Email": "your-email@gmail.com",
    "Password": "your-app-password"
  },
  "ExternalApis": {
    "CropDiseaseModelApi": "ML model endpoint",
    "RealTimeDataApi": "Real-time data endpoint",
    "ClassificationModelApi": "Classification model endpoint",
    "ForecastingModelUrl": "Forecasting model endpoint",
    "HistoryDataApi": "Historical data endpoint",
    "CropRecommendationApi": "Crop recommendation endpoint",
    "FeatureExtractionApi": "Feature extraction endpoint"
  }
}
```

### Environment-Specific Configuration

- **Development**: `appsettings.Development.json`
- **Production**: `appsettings.Production.json`

### Localization

The application supports multiple languages:
- English (en-US) - Default
- Arabic (ar-EG)

Language resources are located in `GreenEye.Presentation/Localization/`

## 📁 Project Structure

```
GreenEye/
├── GreenEye.Domain/                 # Core domain layer
│   ├── Entities/                    # Domain entities
│   │   ├── CropRecommendation/
│   │   ├── Forecasting/
│   │   └── PlantDisease/
│   ├── Enums/                       # Enumerations
│   ├── Interfaces/                  # Domain interfaces
│   └── IRepositories/               # Repository interfaces
│
├── GreenEye.Application/            # Application layer
│   ├── DTOs/                        # Data Transfer Objects
│   │   ├── AuthDtos/
│   │   ├── Classification/
│   │   ├── CropRecommendation/
│   │   ├── Forecasting/
│   │   └── PlantDisease/
│   ├── Services/                    # Business logic services
│   │   ├── Authentication/
│   │   ├── Classification/
│   │   ├── CropRecommendation/
│   │   ├── Forecasting/
│   │   └── PlantDisease/
│   ├── IServices/                   # Service interfaces
│   ├── Mapping/                     # AutoMapper profiles
│   ├── Exceptions/                  # Custom exceptions
│   └── Responses/                   # Response models
│
├── GreenEye.Infrastructure/         # Infrastructure layer
│   ├── Data/                        # Database context & migrations
│   ├── Repositories/                # Repository implementations
│   ├── ExternalServices/            # External API integrations
│   ├── Identity/                    # Identity configuration
│   └── DependencyInjection/         # Service registration
│
└── GreenEye.Presentation/           # Presentation layer (API)
    ├── Controllers/                 # API controllers
    │   ├── Classification/
    │   ├── CropRecommendation/
    │   ├── Forecasting/
    │   └── PlantDisease/
    ├── Middlewares/                 # Custom middleware
    ├── Localization/                # Language resources
    ├── Responses/                   # Response wrappers
    └── Program.cs                   # Application entry point
```

## 🔒 Security Features

- **JWT Authentication** with configurable expiration
- **Refresh Token Rotation** for enhanced security
- **OTP Email Verification** for user registration and password reset
- **Password Hashing** using ASP.NET Core Identity
- **Role-based Authorization** (Admin, User roles)
- **CORS Configuration** for controlled cross-origin access
- **HTTPS Enforcement** in production
- **Input Validation** with Data Annotations
- **Exception Handling Middleware** for secure error responses

## 🌍 Localization

The application supports internationalization with:
- **English (en-US)** - Default language
- **Arabic (ar-EG)** - Full RTL support

Language is detected from:
1. `Accept-Language` header
2. Query string parameter
3. Cookie value
4. Default culture (en-US)

## 📝 Logging

Serilog is configured for comprehensive logging:
- **Console Logging** - Development environment
- **File Logging** - All environments (`Logs/logs-.txt`)
- **Structured Logging** - JSON format support
- **Log Enrichment** - Machine name, process ID, thread ID


## 👥 Team

GreenEye is developed by a dedicated team of developers passionate about agricultural technology and sustainability.

## 📧 Contact

For questions, suggestions, or support:
- **Email**: sanadmahmoud968@gmail.com
- **Email**: mahmoudreda4424@gmail.com
- **Email**: s04495320@gmail.com

---

**Made with ❤️ for sustainable agriculture**
