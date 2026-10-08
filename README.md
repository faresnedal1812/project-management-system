# 🏗️ Project Management System

A comprehensive, production-ready **Project Management System** backend API built with **Node.js**, **Express 5**, and **PostgreSQL**. Designed for multi-tenant organizations to manage projects, tasks, teams, meetings, documents, and more — with real-time updates, background job processing, and role-based access control.

---

## 🌟 Key Features

### Core Business Modules

| Module                     | Description                                                                        |
| -------------------------- | ---------------------------------------------------------------------------------- |
| **Authentication**         | Register, login, email verification, password reset with JWT access/refresh tokens |
| **Organization**           | Multi-tenant company management, employee invitations, membership workflows        |
| **RBAC**                   | Granular role-based access control with 72+ permissions, dynamic role assignment   |
| **Projects**               | Full lifecycle management — create, plan, track, and archive projects              |
| **Tasks**                  | Task assignments, comments, attachments (Cloudinary), status tracking              |
| **Milestones**             | Project milestones with deadline tracking                                          |
| **Time Tracking**          | Log and manage time entries per task                                               |
| **Teams**                  | Team creation, member management, and cross-project collaboration                  |
| **Meetings**               | Schedule, manage, and track meetings with attendees                                |
| **Clients & Vendors**      | CRM-lite client and vendor relationship management                                 |
| **Documents**              | Upload and manage project/company documents                                        |
| **Departments & Branches** | Hierarchical organizational structure management                                   |
| **Notifications**          | In-app notification system with read/unread tracking                               |
| **Activity & Audit Logs**  | Complete audit trail for compliance and debugging                                  |
| **Dashboard**              | Aggregated statistics and KPIs per company                                         |
| **Analytics**              | Project performance, team workload, and trend analysis                             |
| **Reports**                | Export reports in **PDF**, **Excel**, and **CSV** formats                          |

### Infrastructure & Security

| Feature                   | Technology                                                              |
| ------------------------- | ----------------------------------------------------------------------- |
| **Real-Time Engine**      | Socket.IO with JWT auth, room-based broadcasting (user/company/project) |
| **Background Processing** | Redis + BullMQ for async email delivery                                 |
| **Email Templates**       | Welcome, verification, password reset, company invite                   |
| **API Documentation**     | Swagger/OpenAPI auto-generated interactive docs                         |
| **Input Validation**      | Zod schema validation on every endpoint                                 |
| **Security Hardening**    | Helmet, CORS, HPP, rate limiting, bcrypt password hashing               |
| **Structured Logging**    | Pino logger with pretty-print for development                           |
| **Graceful Shutdown**     | SIGTERM/SIGINT handlers with connection draining                        |
| **Docker**                | Multi-stage Dockerfile, docker-compose (App + Postgres + Redis)         |
| **CI/CD Ready**           | Render Blueprint (`render.yaml`) for one-click cloud deployment         |

---

## 🛠️ Tech Stack

| Layer            | Technology              | Version |
| ---------------- | ----------------------- | ------- |
| **Runtime**      | Node.js                 | 22      |
| **Framework**    | Express                 | 5.x     |
| **Database**     | PostgreSQL              | 17      |
| **ORM**          | Prisma                  | 7.x     |
| **Cache/Queue**  | Redis + BullMQ          | 7 / 6.x |
| **WebSockets**   | Socket.IO               | 4.x     |
| **Auth**         | JSON Web Tokens         | -       |
| **Validation**   | Zod                     | 4.x     |
| **File Storage** | Cloudinary              | -       |
| **Email**        | Nodemailer              | -       |
| **Reports**      | PDFKit + ExcelJS        | -       |
| **Docs**         | Swagger UI Express      | -       |
| **Testing**      | Jest + Supertest        | 30.x    |
| **Container**    | Docker + Docker Compose | -       |
| **Deployment**   | Render                  | -       |

---

## 📁 Project Structure

```
server/
├── prisma/
│   ├── schema.prisma              # Database schema (all models)
│   └── migrations/                # Versioned migration history
├── src/
│   ├── config/                    # Environment, database, Redis, Socket.IO, Swagger, Cloudinary, mail
│   ├── controllers/               # Route handlers (28 modules)
│   ├── middlewares/                # Auth, RBAC, validation, security, error handling
│   ├── routes/                    # Express route definitions (21 modules)
│   ├── services/                  # Business logic layer (29 modules)
│   ├── validators/                # Zod schemas for request validation (27 modules)
│   ├── queues/                    # BullMQ queue definitions
│   ├── workers/                   # Background job processors (email worker)
│   ├── templates/                 # HTML email templates
│   ├── utils/                     # Helpers, API error/response classes, exporters (PDF/Excel/CSV)
│   ├── app.js                     # Express application setup
│   └── server.js                  # HTTP server entry point with graceful shutdown
├── tests/
│   ├── integration/               # Integration test suites
│   ├── helpers/                   # Test utilities & DB cleanup
│   └── setup/                     # Jest global setup & env injection
├── Dockerfile                     # Multi-stage production build
├── docker-compose.yml             # Local dev stack (App + Postgres + Redis)
├── render.yaml                    # Render IaC Blueprint
├── .env.example                   # Environment variable template
├── .env.docker                    # Docker-specific env config
└── .dockerignore                  # Docker build exclusions
```

---

## 🚀 Getting Started

### Prerequisites

- **Node.js** 22+
- **PostgreSQL** 17+
- **Redis** 7+ (for background jobs)
- **Docker Desktop** (optional, for containerized setup)

### Local Development Setup

```bash
# 1. Clone the repository
git clone https://github.com/faresnedal1812/project-management-system.git
cd project-management-system/server

# 2. Install dependencies
npm install

# 3. Configure environment
cp .env.example .env
# Edit .env with your database, Redis, JWT, Cloudinary, and SMTP credentials

# 4. Apply database migrations
npx prisma migrate deploy

# 5. Start development server (with hot reload)
npm run dev
```

The API will be available at `http://localhost:5000` and Swagger docs at `http://localhost:5000/api-docs`.

### Docker Setup

```bash
cd server

# 1. Configure Docker environment
# Edit .env.docker with your secrets

# 2. Build and start all services
docker-compose up --build

# 3. Apply migrations (first time only)
docker-compose exec app npx prisma migrate deploy

# 4. Tear down
docker-compose down        # keep data
docker-compose down -v     # clean slate
```

---

## 📜 Available Scripts

| Script         | Command              | Description                                          |
| -------------- | -------------------- | ---------------------------------------------------- |
| **Dev**        | `npm run dev`        | Start with Nodemon (hot reload)                      |
| **Start**      | `npm start`          | Start production server                              |
| **Start Prod** | `npm run start:prod` | Run migrations + start server (for cloud deployment) |
| **Test**       | `npm test`           | Run Jest integration test suite                      |

---

## 🔑 API Endpoints Overview

All endpoints are prefixed with `/api/v1` and documented with Swagger.

| Module           | Endpoints                                                      | Auth Required |
| ---------------- | -------------------------------------------------------------- | ------------- |
| `/auth`          | Register, Login, Refresh, Logout, Verify Email, Reset Password | Partial       |
| `/users`         | Profile management                                             | ✅            |
| `/companies`     | Company CRUD, settings                                         | ✅            |
| `/organizations` | Invitations, membership management                             | ✅            |
| `/employees`     | Employee CRUD, termination                                     | ✅ + RBAC     |
| `/departments`   | Hierarchical department management                             | ✅ + RBAC     |
| `/branches`      | Branch/location management                                     | ✅ + RBAC     |
| `/roles`         | Role CRUD with permission assignment                           | ✅ + RBAC     |
| `/permissions`   | System permission listing                                      | ✅ + RBAC     |
| `/projects`      | Project lifecycle, members, milestones                         | ✅ + RBAC     |
| `/tasks`         | Tasks, assignments, comments, attachments, time entries        | ✅ + RBAC     |
| `/teams`         | Team management with member assignments                        | ✅ + RBAC     |
| `/meetings`      | Meeting scheduling and attendee management                     | ✅ + RBAC     |
| `/clients`       | Client relationship management                                 | ✅ + RBAC     |
| `/vendors`       | Vendor relationship management                                 | ✅ + RBAC     |
| `/documents`     | File upload and document management                            | ✅ + RBAC     |
| `/notifications` | In-app notifications                                           | ✅            |
| `/dashboard`     | Company-wide statistics                                        | ✅            |
| `/analytics`     | Performance analytics and trends                               | ✅ + RBAC     |
| `/reports`       | Generate PDF/Excel/CSV reports                                 | ✅ + RBAC     |
| `/audit-logs`    | System audit trail                                             | ✅ + RBAC     |
| `/activity-logs` | User activity history                                          | ✅            |

---

## 🧪 Testing

The project uses **Jest** and **Supertest** for integration testing with an isolated test database.

```bash
# Run all tests
npm test
```

- Tests automatically seed RBAC permissions (72 CRUD permissions + ADMIN role)
- Database cleanup runs between test suites
- Environment is isolated via `.env.test`

---

## ☁️ Production Deployment (Render)

The project includes a `render.yaml` Blueprint for one-click deployment:

1. Push code to GitHub
2. Create **PostgreSQL** and **Redis** on Render Dashboard
3. Create a **Web Service** → Connect GitHub repo → Set root to `server/` → Choose `Docker` environment
4. Add environment variables in the Render Dashboard
5. Deploy → Run `npx prisma migrate deploy` from the Render Shell tab

> Socket.IO and BullMQ work natively on Render since it provides persistent, always-on containers.

---

## 🔒 Security Features

- **JWT Authentication** with access/refresh token rotation
- **RBAC** with granular permission checks on every protected endpoint
- **Multi-Tenant Isolation** via `x-company-id` header enforcement
- **Helmet** for HTTP security headers
- **HPP** for HTTP parameter pollution protection
- **Rate Limiting** to prevent brute-force attacks
- **Bcrypt** password hashing with configurable salt rounds
- **Input Validation** with Zod schemas on all request bodies/params/queries
- **Non-Root Docker User** for container security

---

## 📄 License

ISC
