# Use the official Node.js runtime as the base image
FROM node:18-alpine

# Install necessary packages and configure DNS
RUN apk add --no-cache dumb-init

# Set the working directory inside the container
WORKDIR /app

# Configure npm to use alternative registries as fallback
RUN npm config set registry https://registry.npmjs.org/ && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 20000 && \
    npm config set fetch-retry-maxtimeout 120000

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install all dependencies (including dev dependencies for development) with retry logic
RUN npm ci --verbose || npm ci --verbose || npm install

# Copy the rest of the application code
COPY . .

# Generate Prisma client with error handling
RUN npx prisma generate || (echo "Prisma generate failed, retrying..." && npx prisma generate)

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the application in development mode
CMD ["npm", "run", "dev"]