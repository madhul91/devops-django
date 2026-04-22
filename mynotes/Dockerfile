# FROM node:8

# WORKDIR /app/
# COPY . /app/

# RUN npm install

# EXPOSE 3000

# CMD ["npm","start"]

# Stage 1: Build
FROM node:18 AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Stage 2: Production
FROM node:18-alpine

WORKDIR /app
COPY --from=builder /app /app

RUN npm prune --production

EXPOSE 3000
CMD ["npm","start"]