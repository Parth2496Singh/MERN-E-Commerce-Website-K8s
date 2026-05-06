FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

FROM node:20-alpine

WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app ./

ENV NODE_ENV=production

EXPOSE 5000

USER appuser

CMD ["node", "backend/index.js"]
