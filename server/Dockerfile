# ============================================================
# Stage 1: Install dependencies
# ============================================================
FROM node:22-alpine AS deps

WORKDIR /app

# Copy only package files first for better layer caching
COPY package.json package-lock.json* ./

# Install all dependencies (including devDependencies for Prisma CLI)
RUN npm ci

# ============================================================
# Stage 2: Generate Prisma Client
# ============================================================
FROM deps AS build

WORKDIR /app

# Copy Prisma schema and config (needed for prisma generate)
COPY prisma ./prisma
COPY prisma.config.ts ./
COPY src/config/env.js ./src/config/env.js

# Generate Prisma Client artifacts
# We need dotenv available and a dummy DATABASE_URL for generate to succeed
RUN DATABASE_URL="postgresql://dummy:dummy@localhost:5432/dummy" \
    JWT_ACCESS_SECRET="build-placeholder" \
    JWT_REFRESH_SECRET="build-placeholder" \
    CLOUDINARY_CLOUD_NAME="build-placeholder" \
    CLOUDINARY_API_KEY="build-placeholder" \
    CLOUDINARY_API_SECRET="build-placeholder" \
    npx prisma generate

# ============================================================
# Stage 3: Production image
# ============================================================
FROM node:22-alpine AS production

WORKDIR /app

# Install production dependencies and the Prisma CLI (needed for npx prisma migrate deploy)
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev && npm install prisma && npm cache clean --force

# Copy generated Prisma Client from build stage
COPY --from=build /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=build /app/node_modules/@prisma ./node_modules/@prisma

# Copy application source code
COPY src ./src
COPY prisma ./prisma
COPY prisma.config.ts ./

# Create non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

USER appuser

# Expose the application port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5000/api/v1/health || exit 1

# Start the application
CMD ["npm", "run", "start:prod"]
