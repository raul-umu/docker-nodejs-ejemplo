# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

# Definir la etapa base
FROM node:18.0.0-alpine AS base
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --include=dev

# Definir la etapa de test
FROM base AS test
ENV NODE_ENV test
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --include=dev
COPY . .
RUN npm run test

# Definir la etapa de producción
FROM base AS prod
ENV NODE_ENV production
COPY . .
RUN npm install --only=production
CMD ["node", "server.js"] # Asegúrate de que el archivo de entrada sea correcto


git add Dockerfile

