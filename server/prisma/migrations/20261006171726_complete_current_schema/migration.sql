-- CreateEnum
CREATE TYPE "ClientStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "VendorType" AS ENUM ('CONTRACTOR', 'SUPPLIER', 'SERVICE_PROVIDER', 'CONSULTANT', 'OTHER');

-- CreateEnum
CREATE TYPE "VendorStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "MeetingType" AS ENUM ('ONLINE', 'IN_PERSON', 'HYBRID');

-- CreateEnum
CREATE TYPE "MeetingStatus" AS ENUM ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "AttendeeType" AS ENUM ('EMPLOYEE', 'CLIENT', 'VENDOR');

-- CreateEnum
CREATE TYPE "DocumentScope" AS ENUM ('COMPANY', 'PROJECT', 'CLIENT', 'VENDOR');

-- CreateEnum
CREATE TYPE "DocumentCategory" AS ENUM ('CONTRACT', 'INVOICE', 'REPORT', 'AGREEMENT', 'POLICY', 'OTHER');

-- AlterTable
ALTER TABLE "projects" ADD COLUMN     "clientId" TEXT;

-- AlterTable
ALTER TABLE "tasks" ADD COLUMN     "completedAt" TIMESTAMP(3);

-- CreateTable
CREATE TABLE "clients" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "contactName" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "website" TEXT,
    "address" TEXT,
    "industry" TEXT,
    "status" "ClientStatus" NOT NULL DEFAULT 'ACTIVE',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "clients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vendors" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "VendorType" NOT NULL DEFAULT 'OTHER',
    "contactName" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "website" TEXT,
    "address" TEXT,
    "taxId" TEXT,
    "paymentTerms" TEXT,
    "status" "VendorStatus" NOT NULL DEFAULT 'ACTIVE',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vendors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "meetings" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "organizerId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "type" "MeetingType" NOT NULL DEFAULT 'ONLINE',
    "status" "MeetingStatus" NOT NULL DEFAULT 'SCHEDULED',
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "location" TEXT,
    "meetingUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "meetings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "meeting_attendees" (
    "id" TEXT NOT NULL,
    "meetingId" TEXT NOT NULL,
    "type" "AttendeeType" NOT NULL,
    "employeeId" TEXT,
    "clientId" TEXT,
    "vendorId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "meeting_attendees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "uploaderId" TEXT NOT NULL,
    "scope" "DocumentScope" NOT NULL DEFAULT 'COMPANY',
    "category" "DocumentCategory" NOT NULL DEFAULT 'OTHER',
    "title" TEXT NOT NULL,
    "description" TEXT,
    "fileName" TEXT NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "publicId" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "sizeBytes" INTEGER NOT NULL,
    "projectId" TEXT,
    "clientId" TEXT,
    "vendorId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "companyId" TEXT,
    "actorId" TEXT,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "changes" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "clients_companyId_name_key" ON "clients"("companyId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "vendors_companyId_name_key" ON "vendors"("companyId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "meeting_attendees_meetingId_employeeId_key" ON "meeting_attendees"("meetingId", "employeeId");

-- CreateIndex
CREATE UNIQUE INDEX "meeting_attendees_meetingId_clientId_key" ON "meeting_attendees"("meetingId", "clientId");

-- CreateIndex
CREATE UNIQUE INDEX "meeting_attendees_meetingId_vendorId_key" ON "meeting_attendees"("meetingId", "vendorId");

-- CreateIndex
CREATE INDEX "audit_logs_companyId_entityType_idx" ON "audit_logs"("companyId", "entityType");

-- CreateIndex
CREATE INDEX "audit_logs_companyId_actorId_idx" ON "audit_logs"("companyId", "actorId");

-- CreateIndex
CREATE INDEX "audit_logs_createdAt_idx" ON "audit_logs"("createdAt");

-- CreateIndex
CREATE INDEX "tasks_projectId_status_idx" ON "tasks"("projectId", "status");

-- CreateIndex
CREATE INDEX "tasks_createdAt_idx" ON "tasks"("createdAt");

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "clients"("id") ON DELETE SET NULL ON UPDATE CASCADE NOT VALID;

-- AddForeignKey
ALTER TABLE "clients" ADD CONSTRAINT "clients_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vendors" ADD CONSTRAINT "vendors_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meetings" ADD CONSTRAINT "meetings_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meetings" ADD CONSTRAINT "meetings_organizerId_fkey" FOREIGN KEY ("organizerId") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meeting_attendees" ADD CONSTRAINT "meeting_attendees_meetingId_fkey" FOREIGN KEY ("meetingId") REFERENCES "meetings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meeting_attendees" ADD CONSTRAINT "meeting_attendees_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meeting_attendees" ADD CONSTRAINT "meeting_attendees_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "clients"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meeting_attendees" ADD CONSTRAINT "meeting_attendees_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "vendors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_uploaderId_fkey" FOREIGN KEY ("uploaderId") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "projects"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "clients"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "vendors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;
