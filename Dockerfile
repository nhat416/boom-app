# Use a multi-stage Dockerfile to build and serve the TypeScript app
MAINTAINER "Nhat Tran"

# Stage 1: Compile TypeScript sources
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy TypeScript configuration and source files
COPY tsconfig.json ./
COPY src ./src

# Copy existing static assets (HTML, CSS) from the dist folder
COPY dist ./dist

# Install TypeScript compiler globally
RUN npm install -g typescript

# Compile the TypeScript project into the dist directory
RUN tsc

# Stage 2: Serve the built files using Nginx
FROM nginx:alpine

# Copy compiled assets from the builder stage
COPY --from=builder /app/dist/ /usr/share/nginx/html/

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]