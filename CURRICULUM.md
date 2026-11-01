# Laravel Learning Hub — Curriculum

## 1. Curriculum Overview

### 1.1 Description

Laravel Learning Hub is a structured learning program designed to teach Laravel web application development from beginner to advanced levels.

The curriculum starts with web development and PHP fundamentals before progressing to Laravel fundamentals, database management, application security, REST API development, testing, performance optimization, deployment, and professional software architecture.

### 1.2 Target Audience

- Absolute beginners who want to learn Laravel.
- PHP developers who want to learn Laravel.
- Students learning backend web development.
- Developers who want to build REST APIs.
- Developers who want to understand Laravel application architecture.

### 1.3 Learning Outcomes

After completing the curriculum, learners should be able to:

1. Understand PHP and web development fundamentals.
2. Understand Laravel architecture and its application lifecycle.
3. Build web applications using Laravel.
4. Implement MVC architecture.
5. Manage relational databases using Eloquent ORM.
6. Implement authentication and authorization.
7. Develop REST APIs.
8. Apply application security practices.
9. Write automated tests.
10. Optimize Laravel application performance.
11. Deploy Laravel applications to production servers.
12. Design maintainable Laravel application architectures.

### 1.4 Technical Stack

| Component | Technology |
|---|---|
| Programming Language | PHP |
| Backend Framework | Laravel 13.x |
| Database | MySQL / SQLite |
| Database ORM | Eloquent ORM |
| Frontend Template | Blade |
| CSS | CSS / Tailwind CSS |
| JavaScript | JavaScript |
| Dependency Manager | Composer |
| Build Tool | Vite |
| API Authentication | Laravel Sanctum |
| Cache | Redis |
| Testing | PHPUnit / Pest |
| Version Control | Git / GitHub |
| Containerization | Docker |
| Web Server | Nginx |
| Documentation | MkDocs |

All version-sensitive examples must follow the versions selected in PRD.md.

---

## 2. Learning Path

The curriculum consists of 12 progressive levels.

| Level | Title | Difficulty |
|---|---|---|
| 00 | Web Development and PHP Fundamentals | Beginner |
| 01 | Introduction to Laravel | Beginner |
| 02 | Routing, Controller, and Request Handling | Beginner |
| 03 | Blade Template and Frontend Integration | Beginner |
| 04 | Database and Eloquent ORM | Beginner–Intermediate |
| 05 | Form Validation, Authentication, and Security | Intermediate |
| 06 | REST API Development | Intermediate |
| 07 | Advanced Laravel Features | Advanced |
| 08 | Laravel Testing | Intermediate–Advanced |
| 09 | Performance and Scalability | Advanced |
| 10 | Deployment and DevOps | Advanced |
| 11 | Professional Laravel Architecture | Advanced |

---

## 3. Detailed Curriculum

# LEVEL 00 — Web Development and PHP Fundamentals

**Difficulty:** Beginner

**Learning Objectives:**
Understand web development fundamentals and acquire the PHP knowledge required to learn Laravel.

**Prerequisites:** None.

### Chapters

- 00.01 Introduction to Web Development
- 00.02 Understanding Client-Server Architecture
- 00.03 HTTP and HTTPS Fundamentals
- 00.04 Understanding Request and Response
- 00.05 Introduction to PHP
- 00.06 PHP Installation and Development Environment
- 00.07 PHP Syntax
- 00.08 Variables and Constants
- 00.09 PHP Data Types
- 00.10 PHP Operators
- 00.11 Conditional Statements
- 00.12 Loops
- 00.13 Arrays
- 00.14 Functions
- 00.15 String Manipulation
- 00.16 PHP Form Handling
- 00.17 Include and Require
- 00.18 Object-Oriented Programming
- 00.19 Classes and Objects
- 00.20 Inheritance, Encapsulation, and Polymorphism
- 00.21 Exception Handling
- 00.22 Namespace and Autoloading
- 00.23 Composer and Package Management
- 00.24 Git and GitHub Fundamentals

**Practical Project:** Student Management System using PHP Native.

**Completion Criteria:**
- Understand PHP fundamentals.
- Build a simple PHP application.
- Understand basic OOP.
- Use Composer and Git.

---

# LEVEL 01 — Introduction to Laravel

**Difficulty:** Beginner

**Learning Objectives:**
Understand Laravel framework fundamentals, installation, project structure, and application lifecycle.

**Prerequisites:** Level 00.

### Chapters

- 01.01 Introduction to Laravel
- 01.02 Why Use Laravel?
- 01.03 MVC Architecture
- 01.04 Laravel vs PHP Native
- 01.05 Laravel System Requirements
- 01.06 Installing Laravel
- 01.07 Creating a Laravel Project
- 01.08 Running Laravel Development Server
- 01.09 Laravel Directory Structure
- 01.10 Laravel Configuration
- 01.11 Environment Variables
- 01.12 Laravel Artisan CLI
- 01.13 Laravel Request Lifecycle
- 01.14 Service Container Overview
- 01.15 Application Configuration

**Practical Project:** First Laravel Application.

**Completion Criteria:**
- Successfully install Laravel.
- Understand the Laravel directory structure.
- Execute common Artisan commands.
- Understand the basic application lifecycle.

---

# LEVEL 02 — Routing, Controller, and Request Handling

**Difficulty:** Beginner

**Learning Objectives:**
Understand how Laravel receives HTTP requests and generates responses.

**Prerequisites:** Level 01.

### Chapters

- 02.01 Introduction to Routing
- 02.02 Basic Routing
- 02.03 Route Parameters
- 02.04 Optional Route Parameters
- 02.05 Named Routes
- 02.06 Route Groups
- 02.07 Route Prefix
- 02.08 Route Middleware
- 02.09 Route Constraints
- 02.10 Route Model Binding
- 02.11 Introduction to Controllers
- 02.12 Creating Controllers
- 02.13 Resource Controllers
- 02.14 Single Action Controllers
- 02.15 Request Object
- 02.16 Response Object
- 02.17 Redirect Responses
- 02.18 JSON Responses
- 02.19 File Download Responses
- 02.20 Error Handling and HTTP Status Codes

**Practical Project:** Article Routing and Controller.

**Completion Criteria:**
- Create application routes.
- Implement controllers.
- Handle HTTP requests and responses.
- Understand route model binding.

---

# LEVEL 03 — Blade Template and Frontend Integration

**Difficulty:** Beginner

**Learning Objectives:**
Build dynamic user interfaces using Laravel Blade.

**Prerequisites:** Level 02.

### Chapters

- 03.01 Introduction to Blade
- 03.02 Blade Syntax
- 03.03 Displaying Data
- 03.04 Conditional Directives
- 03.05 Loop Directives
- 03.06 Blade Layouts
- 03.07 Template Inheritance
- 03.08 Blade Components
- 03.09 Anonymous Components
- 03.10 Passing Data to Components
- 03.11 Blade Include
- 03.12 Blade Forms
- 03.13 Form Method Spoofing
- 03.14 CSRF Protection
- 03.15 Form Error Messages
- 03.16 Asset Management
- 03.17 Vite Integration
- 03.18 CSS and JavaScript Integration

**Practical Project:** Admin Dashboard using Blade.

**Completion Criteria:**
- Build reusable Blade layouts.
- Create dynamic pages.
- Implement forms.
- Integrate frontend assets.

---

# LEVEL 04 — Database and Eloquent ORM

**Difficulty:** Beginner–Intermediate

**Learning Objectives:**
Understand relational databases and manage application data using Laravel Eloquent ORM.

**Prerequisites:** Level 03.

### Chapters

- 04.01 Introduction to Databases
- 04.02 Relational Database Fundamentals
- 04.03 MySQL Installation and Configuration
- 04.04 Database Connection
- 04.05 Database Migration
- 04.06 Creating Migrations
- 04.07 Database Column Types
- 04.08 Modifying Database Tables
- 04.09 Migration Rollback and Refresh
- 04.10 Database Seeder
- 04.11 Model Factories
- 04.12 Introduction to Eloquent ORM
- 04.13 Creating Models
- 04.14 CRUD Operations
- 04.15 Query Builder
- 04.16 Eloquent Queries
- 04.17 Primary Keys and Foreign Keys
- 04.18 One-to-One Relationships
- 04.19 One-to-Many Relationships
- 04.20 Many-to-Many Relationships
- 04.21 Has One Through and Has Many Through
- 04.22 Polymorphic Relationships
- 04.23 Eager Loading
- 04.24 N+1 Query Problem
- 04.25 Pagination
- 04.26 Database Transactions
- 04.27 Soft Deletes
- 04.28 Model Events and Observers

**Practical Project:** Article Management System with Categories, Users, and Comments.

**Completion Criteria:**
- Create and manage migrations.
- Implement database relationships.
- Build CRUD operations.
- Use Eloquent efficiently.

---

# LEVEL 05 — Form Validation, Authentication, and Security

**Difficulty:** Intermediate

**Learning Objectives:**
Implement validation, authentication, authorization, and security mechanisms.

**Prerequisites:** Level 04.

### Chapters

- 05.01 Introduction to Form Validation
- 05.02 Basic Validation
- 05.03 Validation Rules
- 05.04 Custom Validation Messages
- 05.05 Form Request Validation
- 05.06 Conditional Validation
- 05.07 File Upload Validation
- 05.08 Introduction to Authentication
- 05.09 Laravel Authentication
- 05.10 Login and Logout
- 05.11 User Registration
- 05.12 Password Hashing
- 05.13 Password Reset
- 05.14 Email Verification
- 05.15 Authentication Middleware
- 05.16 Authorization
- 05.17 Gates
- 05.18 Policies
- 05.19 Role-Based Access Control
- 05.20 CSRF Protection
- 05.21 XSS Prevention
- 05.22 SQL Injection Prevention
- 05.23 Mass Assignment Protection
- 05.24 Rate Limiting
- 05.25 Secure File Upload

**Practical Project:** Role-Based Article Management Dashboard.

**Completion Criteria:**
- Implement form validation.
- Implement authentication.
- Implement role-based authorization.
- Apply secure coding practices.

---

# LEVEL 06 — REST API Development

**Difficulty:** Intermediate

**Learning Objectives:**
Build RESTful APIs using Laravel.

**Prerequisites:** Level 04 and Level 05.

### Chapters

- 06.01 Introduction to REST API
- 06.02 REST Architecture
- 06.03 HTTP Methods
- 06.04 HTTP Status Codes
- 06.05 JSON Data Format
- 06.06 API Routing
- 06.07 API Controllers
- 06.08 API Resource Controllers
- 06.09 API Resource Transformation
- 06.10 API Request Validation
- 06.11 API Error Handling
- 06.12 API Pagination
- 06.13 API Filtering and Searching
- 06.14 API Authentication
- 06.15 Laravel Sanctum
- 06.16 Token-Based Authentication
- 06.17 API Authorization
- 06.18 API Rate Limiting
- 06.19 API Versioning Concepts
- 06.20 API Documentation
- 06.21 API Testing with Postman
- 06.22 Frontend API Integration

**Practical Project:** Article Management REST API.

**Completion Criteria:**
- Build REST API endpoints.
- Implement API authentication.
- Handle JSON responses and errors.
- Test API endpoints.

---

# LEVEL 07 — Advanced Laravel Features

**Difficulty:** Advanced

**Learning Objectives:**
Understand advanced Laravel services and application capabilities.

**Prerequisites:** Levels 01–06.

### Chapters

- 07.01 Service Container
- 07.02 Service Providers
- 07.03 Dependency Injection
- 07.04 Contracts and Interfaces
- 07.05 Facades
- 07.06 Repository Pattern
- 07.07 Service Layer Pattern
- 07.08 Events and Listeners
- 07.09 Jobs and Queues
- 07.10 Queue Workers
- 07.11 Task Scheduling
- 07.12 Cache Management
- 07.13 Redis Integration
- 07.14 Mail Configuration
- 07.15 Notifications
- 07.16 File Storage
- 07.17 Laravel Filesystem
- 07.18 Logging
- 07.19 Broadcasting
- 07.20 Real-Time Events
- 07.21 Localization and Translation

**Practical Project:** Background Email and Notification System.

**Completion Criteria:**
- Implement background jobs.
- Use queues and caching.
- Implement events and notifications.
- Understand dependency injection.

---

# LEVEL 08 — Laravel Testing

**Difficulty:** Intermediate–Advanced

**Learning Objectives:**
Implement automated testing and improve application reliability.

**Prerequisites:** Levels 01–07.

### Chapters

- 08.01 Introduction to Software Testing
- 08.02 Testing Fundamentals
- 08.03 PHPUnit and Pest
- 08.04 Unit Testing
- 08.05 Feature Testing
- 08.06 HTTP Testing
- 08.07 Database Testing
- 08.08 Authentication Testing
- 08.09 Authorization Testing
- 08.10 API Testing
- 08.11 Mocking
- 08.12 Factories in Testing
- 08.13 Test Coverage
- 08.14 Debugging and Error Diagnosis

**Practical Project:** Automated Testing for Article Management.

**Completion Criteria:**
- Write unit tests.
- Write feature tests.
- Test API endpoints.
- Verify authentication and authorization behavior.

---

# LEVEL 09 — Performance and Scalability

**Difficulty:** Advanced

**Learning Objectives:**
Optimize Laravel applications for performance and scalability.

**Prerequisites:** Levels 01–08.

### Chapters

- 09.01 Performance Fundamentals
- 09.02 Laravel Performance Optimization
- 09.03 Database Query Optimization
- 09.04 Database Indexing
- 09.05 Eloquent Optimization
- 09.06 Lazy Loading vs Eager Loading
- 09.07 Redis Cache
- 09.08 HTTP Caching
- 09.09 Queue Optimization
- 09.10 Session Management
- 09.11 Laravel Octane
- 09.12 Profiling and Monitoring
- 09.13 Application Scalability

**Practical Project:** Performance Optimization for Article Management.

**Completion Criteria:**
- Identify performance bottlenecks.
- Optimize database queries.
- Implement caching.
- Understand application scaling.

---

# LEVEL 10 — Deployment and DevOps

**Difficulty:** Advanced

**Learning Objectives:**
Deploy and maintain Laravel applications in production environments.

**Prerequisites:** Levels 01–09.

### Chapters

- 10.01 Production Environment
- 10.02 Linux Server Fundamentals
- 10.03 VPS Preparation
- 10.04 Nginx Configuration
- 10.05 PHP-FPM
- 10.06 MySQL Production Configuration
- 10.07 Environment Configuration
- 10.08 Laravel Deployment
- 10.09 File Permissions
- 10.10 Queue Workers with Supervisor
- 10.11 Scheduler Configuration
- 10.12 SSL and HTTPS
- 10.13 Docker Fundamentals
- 10.14 Dockerfile for Laravel
- 10.15 Docker Compose
- 10.16 CI/CD Fundamentals
- 10.17 GitHub Actions
- 10.18 Application Backup
- 10.19 Production Monitoring
- 10.20 Deployment Troubleshooting

**Practical Project:** Deploy Laravel to VPS using Nginx, PHP-FPM, MySQL, and Docker.

**Completion Criteria:**
- Deploy Laravel to a production server.
- Configure web server and database.
- Configure background workers.
- Understand backup and monitoring.

---

# LEVEL 11 — Professional Laravel Architecture

**Difficulty:** Advanced

**Learning Objectives:**
Design maintainable, modular, and scalable Laravel applications.

**Prerequisites:** Levels 01–10.

### Chapters

- 11.01 Software Architecture Fundamentals
- 11.02 Clean Code
- 11.03 SOLID Principles
- 11.04 Design Patterns
- 11.05 Modular Application Architecture
- 11.06 Domain-Driven Design Fundamentals
- 11.07 Laravel Package Development
- 11.08 Custom Artisan Commands
- 11.09 Custom Middleware
- 11.10 Multi-Tenancy Concepts
- 11.11 Event-Driven Architecture
- 11.12 Microservices Fundamentals
- 11.13 Integration with External Services
- 11.14 API Gateway Concepts
- 11.15 Laravel Application Architecture Review

**Practical Project:** Modular Laravel Enterprise Application.

**Completion Criteria:**
- Apply SOLID principles.
- Design modular application structures.
- Understand architectural trade-offs.
- Build maintainable applications.

---

## 4. Final Projects

### Project 1 — Student Management System

**Difficulty:** Beginner

Features:
- Student CRUD.
- Department management.
- Form validation.
- Blade templates.
- Database integration.

### Project 2 — Content Management System

**Difficulty:** Intermediate

Features:
- Article management.
- Category management.
- User authentication.
- Role-based authorization.
- REST API.
- File uploads.
- Automated tests.

### Project 3 — Enterprise Application

**Difficulty:** Advanced

Features:
- Modular architecture.
- Background jobs.
- Redis caching.
- Notifications.
- API integrations.
- Performance optimization.
- Docker deployment.
- CI/CD.
- Monitoring.

---

## 5. Learning and Content Production Rules

- Follow the level and chapter sequence.
- Do not skip chapters without approval.
- Every chapter must follow CONTENT_STANDARDS.md.
- Work on one chapter at a time.
- Do not generate the entire curriculum in one task.
- Do not create duplicate chapters.
- Reuse the cumulative project where appropriate.
- Verify version-sensitive Laravel concepts against official documentation.

---

## 6. Curriculum Status Tracking

Use these statuses:

| Status | Meaning |
|---|---|
| NOT_STARTED | Chapter has not been created |
| DRAFT | Initial content is available |
| IN_REVIEW | Content is being reviewed |
| NEEDS_REVISION | Corrections are required |
| VERIFIED | Editorial and technical checks passed |
| PUBLISHED | Approved and published |

### Progress Summary

| Level | Status |
|---|---|
| Level 00 | NOT_STARTED |
| Level 01 | NOT_STARTED |
| Level 02 | NOT_STARTED |
| Level 03 | NOT_STARTED |
| Level 04 | NOT_STARTED |
| Level 05 | NOT_STARTED |
| Level 06 | NOT_STARTED |
| Level 07 | NOT_STARTED |
| Level 08 | NOT_STARTED |
| Level 09 | NOT_STARTED |
| Level 10 | NOT_STARTED |
| Level 11 | NOT_STARTED |

Update progress only after checking the actual files and their completion criteria.

---

## 7. Definition of Done

A chapter is considered complete only when:

1. All required learning objectives are covered.
2. Explanations follow CONTENT_STANDARDS.md.
3. Code examples have correct file paths.
4. Code examples are technically reviewed.
5. Execution instructions and expected behavior are documented.
6. Exercises and knowledge checks are available.
7. Official references are included.
8. Markdown and internal links are validated.
9. Navigation is updated where necessary.
10. The chapter passes editorial review.

A chapter may be marked VERIFIED only after both editorial and technical reviews pass.

A chapter may be marked PUBLISHED only after the documentation has been approved and successfully built for publication.

---

## 8. Official Learning References

- Laravel Documentation: https://laravel.com/docs
- PHP Documentation: https://www.php.net/docs.php
- Composer Documentation: https://getcomposer.org/doc/
- MySQL Documentation: https://dev.mysql.com/doc/
- Git Documentation: https://git-scm.com/doc
- Docker Documentation: https://docs.docker.com/
- PHPUnit Documentation: https://docs.phpunit.de/
- Pest Documentation: https://pestphp.com/docs

All technical references must be checked against the selected framework and dependency versions.