# Kurikulum Laravel

Kurikulum ini mengikuti `CURRICULUM.md`: **12 bab utama** dan **235 sub bab** yang dikerjakan
berurutan, dari dasar web dan PHP sampai arsitektur profesional. Versi framework: **Laravel 13.x**.

!!! info "Status"
    Bab utama pertama sudah memiliki draf untuk seluruh 24 sub bab beserta proyek praktiknya,
    dan bab utama kedua juga sudah memiliki 15 sub bab beserta proyek praktiknya. Belum ada sub bab yang berstatus VERIFIED.
    Bab utama lain masih **NOT_STARTED**. Status diperbarui hanya setelah file benar-benar ada dan memenuhi
    kriteria penyelesaiannya. Judul mengikuti dokumen kurikulum.

## Ringkasan

| Bab utama | Tingkat | Sub bab | Status |
|---|---|---|---|
| Web Development and PHP Fundamentals | Beginner | 24 | DRAFT (24 dari 24 sub bab) |
| Introduction to Laravel | Beginner | 15 | DRAFT (15 dari 15 sub bab) |
| Routing, Controller, and Request Handling | Beginner | 20 | NOT_STARTED |
| Blade Template and Frontend Integration | Beginner | 18 | NOT_STARTED |
| Database and Eloquent ORM | Beginner–Intermediate | 28 | NOT_STARTED |
| Form Validation, Authentication, and Security | Intermediate | 25 | NOT_STARTED |
| REST API Development | Intermediate | 22 | NOT_STARTED |
| Advanced Laravel Features | Advanced | 21 | NOT_STARTED |
| Laravel Testing | Intermediate–Advanced | 14 | NOT_STARTED |
| Performance and Scalability | Advanced | 13 | NOT_STARTED |
| Deployment and DevOps | Advanced | 20 | NOT_STARTED |
| Professional Laravel Architecture | Advanced | 15 | NOT_STARTED |

## Daftar sub bab

??? note "Web Development and PHP Fundamentals"
    **Prasyarat:** Tidak ada  
    **Proyek praktik:** Student Management System using PHP Native.

    - Introduction to Web Development
    - Understanding Client-Server Architecture
    - HTTP and HTTPS Fundamentals
    - Understanding Request and Response
    - Introduction to PHP
    - PHP Installation and Development Environment
    - PHP Syntax
    - Variables and Constants
    - PHP Data Types
    - PHP Operators
    - Conditional Statements
    - Loops
    - Arrays
    - Functions
    - String Manipulation
    - PHP Form Handling
    - Include and Require
    - Object-Oriented Programming
    - Classes and Objects
    - Inheritance, Encapsulation, and Polymorphism
    - Exception Handling
    - Namespace and Autoloading
    - Composer and Package Management
    - Git and GitHub Fundamentals

??? note "Introduction to Laravel"
    **Prasyarat:** Web Development and PHP Fundamentals  
    **Proyek praktik:** First Laravel Application.

    - Introduction to Laravel
    - Why Use Laravel?
    - MVC Architecture
    - Laravel vs PHP Native
    - Laravel System Requirements
    - Installing Laravel
    - Creating a Laravel Project
    - Running Laravel Development Server
    - Laravel Directory Structure
    - Laravel Configuration
    - Environment Variables
    - Laravel Artisan CLI
    - Laravel Request Lifecycle
    - Service Container Overview
    - Application Configuration

??? note "Routing, Controller, and Request Handling"
    **Prasyarat:** Introduction to Laravel  
    **Proyek praktik:** Article Routing and Controller.

    - Introduction to Routing
    - Basic Routing
    - Route Parameters
    - Optional Route Parameters
    - Named Routes
    - Route Groups
    - Route Prefix
    - Route Middleware
    - Route Constraints
    - Route Model Binding
    - Introduction to Controllers
    - Creating Controllers
    - Resource Controllers
    - Single Action Controllers
    - Request Object
    - Response Object
    - Redirect Responses
    - JSON Responses
    - File Download Responses
    - Error Handling and HTTP Status Codes

??? note "Blade Template and Frontend Integration"
    **Prasyarat:** Routing, Controller, and Request Handling  
    **Proyek praktik:** Admin Dashboard using Blade.

    - Introduction to Blade
    - Blade Syntax
    - Displaying Data
    - Conditional Directives
    - Loop Directives
    - Blade Layouts
    - Template Inheritance
    - Blade Components
    - Anonymous Components
    - Passing Data to Components
    - Blade Include
    - Blade Forms
    - Form Method Spoofing
    - CSRF Protection
    - Form Error Messages
    - Asset Management
    - Vite Integration
    - CSS and JavaScript Integration

??? note "Database and Eloquent ORM"
    **Prasyarat:** Blade Template and Frontend Integration  
    **Proyek praktik:** Article Management System with Categories, Users, and Comments.

    - Introduction to Databases
    - Relational Database Fundamentals
    - MySQL Installation and Configuration
    - Database Connection
    - Database Migration
    - Creating Migrations
    - Database Column Types
    - Modifying Database Tables
    - Migration Rollback and Refresh
    - Database Seeder
    - Model Factories
    - Introduction to Eloquent ORM
    - Creating Models
    - CRUD Operations
    - Query Builder
    - Eloquent Queries
    - Primary Keys and Foreign Keys
    - One-to-One Relationships
    - One-to-Many Relationships
    - Many-to-Many Relationships
    - Has One Through and Has Many Through
    - Polymorphic Relationships
    - Eager Loading
    - N+1 Query Problem
    - Pagination
    - Database Transactions
    - Soft Deletes
    - Model Events and Observers

??? note "Form Validation, Authentication, and Security"
    **Prasyarat:** Database and Eloquent ORM  
    **Proyek praktik:** Role-Based Article Management Dashboard.

    - Introduction to Form Validation
    - Basic Validation
    - Validation Rules
    - Custom Validation Messages
    - Form Request Validation
    - Conditional Validation
    - File Upload Validation
    - Introduction to Authentication
    - Laravel Authentication
    - Login and Logout
    - User Registration
    - Password Hashing
    - Password Reset
    - Email Verification
    - Authentication Middleware
    - Authorization
    - Gates
    - Policies
    - Role-Based Access Control
    - CSRF Protection
    - XSS Prevention
    - SQL Injection Prevention
    - Mass Assignment Protection
    - Rate Limiting
    - Secure File Upload

??? note "REST API Development"
    **Prasyarat:** Database and Eloquent ORM; Form Validation, Authentication, and Security  
    **Proyek praktik:** Article Management REST API.

    - Introduction to REST API
    - REST Architecture
    - HTTP Methods
    - HTTP Status Codes
    - JSON Data Format
    - API Routing
    - API Controllers
    - API Resource Controllers
    - API Resource Transformation
    - API Request Validation
    - API Error Handling
    - API Pagination
    - API Filtering and Searching
    - API Authentication
    - Laravel Sanctum
    - Token-Based Authentication
    - API Authorization
    - API Rate Limiting
    - API Versioning Concepts
    - API Documentation
    - API Testing with Postman
    - Frontend API Integration

??? note "Advanced Laravel Features"
    **Prasyarat:** Introduction to Laravel sampai REST API Development  
    **Proyek praktik:** Background Email and Notification System.

    - Service Container
    - Service Providers
    - Dependency Injection
    - Contracts and Interfaces
    - Facades
    - Repository Pattern
    - Service Layer Pattern
    - Events and Listeners
    - Jobs and Queues
    - Queue Workers
    - Task Scheduling
    - Cache Management
    - Redis Integration
    - Mail Configuration
    - Notifications
    - File Storage
    - Laravel Filesystem
    - Logging
    - Broadcasting
    - Real-Time Events
    - Localization and Translation

??? note "Laravel Testing"
    **Prasyarat:** Introduction to Laravel sampai Advanced Laravel Features  
    **Proyek praktik:** Automated Testing for Article Management.

    - Introduction to Software Testing
    - Testing Fundamentals
    - PHPUnit and Pest
    - Unit Testing
    - Feature Testing
    - HTTP Testing
    - Database Testing
    - Authentication Testing
    - Authorization Testing
    - API Testing
    - Mocking
    - Factories in Testing
    - Test Coverage
    - Debugging and Error Diagnosis

??? note "Performance and Scalability"
    **Prasyarat:** Introduction to Laravel sampai Laravel Testing  
    **Proyek praktik:** Performance Optimization for Article Management.

    - Performance Fundamentals
    - Laravel Performance Optimization
    - Database Query Optimization
    - Database Indexing
    - Eloquent Optimization
    - Lazy Loading vs Eager Loading
    - Redis Cache
    - HTTP Caching
    - Queue Optimization
    - Session Management
    - Laravel Octane
    - Profiling and Monitoring
    - Application Scalability

??? note "Deployment and DevOps"
    **Prasyarat:** Introduction to Laravel sampai Performance and Scalability  
    **Proyek praktik:** Deploy Laravel to VPS using Nginx, PHP-FPM, MySQL, and Docker.

    - Production Environment
    - Linux Server Fundamentals
    - VPS Preparation
    - Nginx Configuration
    - PHP-FPM
    - MySQL Production Configuration
    - Environment Configuration
    - Laravel Deployment
    - File Permissions
    - Queue Workers with Supervisor
    - Scheduler Configuration
    - SSL and HTTPS
    - Docker Fundamentals
    - Dockerfile for Laravel
    - Docker Compose
    - CI/CD Fundamentals
    - GitHub Actions
    - Application Backup
    - Production Monitoring
    - Deployment Troubleshooting

??? note "Professional Laravel Architecture"
    **Prasyarat:** Introduction to Laravel sampai Deployment and DevOps  
    **Proyek praktik:** Modular Laravel Enterprise Application.

    - Software Architecture Fundamentals
    - Clean Code
    - SOLID Principles
    - Design Patterns
    - Modular Application Architecture
    - Domain-Driven Design Fundamentals
    - Laravel Package Development
    - Custom Artisan Commands
    - Custom Middleware
    - Multi-Tenancy Concepts
    - Event-Driven Architecture
    - Microservices Fundamentals
    - Integration with External Services
    - API Gateway Concepts
    - Laravel Application Architecture Review

## Aturan penyusunan

- Ikuti urutan bab utama dan sub bab; jangan melompati sub bab tanpa persetujuan.
- Satu sub bab dikerjakan dalam satu tugas.
- Tidak ada sub bab ganda; gunakan kembali proyek kumulatif bila sesuai.
- Konsep yang bergantung versi diverifikasi ke dokumentasi resmi Laravel.
