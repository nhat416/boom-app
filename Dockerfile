# Use a multi-stage Dockerfile to build and serve the TypeScript app
# Stage 1: Compile TypeScript sources
FROM node:18-alpine
LABEL maintainer="Nhat Tran"

# Install TypeScript compiler globally
RUN npm install -g typescript serve

# Set working directory
WORKDIR /app

# Copy TypeScript configuration and source files
COPY tsconfig.json ./
COPY src ./src

# Compile the TypeScript project into the dist directory
RUN tsc --build

# Expose port 80 for HTTP traffic
EXPOSE 3000

# Start Nginx in the foreground
CMD ["serve", "dist"]