# Use a multi-stage Dockerfile to build and serve the TypeScript app
# Stage 1: Compile TypeScript sources
# Stage 1: Build the static app
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
# This step leverages Docker's layer caching. If these files don't change,
# Docker won't re-run 'npm ci' in subsequent builds.
COPY package*.json ./

# Copy tsconfig.json
COPY tsconfig.json ./

# Install dependencies
# 'npm ci' is generally recommended for CI/CD environments as it installs
# dependencies exactly as defined in package-lock.json.
# If you use yarn, you would use:
# COPY yarn.lock ./
# RUN yarn install --frozen-lockfile
RUN npm ci

# Copy the rest of your application's source code
COPY . .

# Build the application
# This assumes you have a "build" script in your package.json like:
# "scripts": { "build": "tsc --build" }
# If not, you can directly use: RUN npx tsc --build
#RUN npm run build
RUN npx tsc --build

# At this point, your compiled static files should be in /app/dist/

# Stage 2: Serve the static files with Nginx
# We use a lightweight Nginx image for the production stage.
FROM nginx:stable-alpine

# Set the working directory for Nginx
WORKDIR /usr/share/nginx/html

# Remove default Nginx static assets
RUN rm -rf ./*

# Copy the compiled static files from the 'builder' stage
# from /app/dist (in the builder stage) to /usr/share/nginx/html (in this stage)
COPY --from=builder /app/dist .

# Expose port 80 to the outside world
EXPOSE 80

# Command to run Nginx in the foreground when the container starts
CMD ["nginx", "-g", "daemon off;"]