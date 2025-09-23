FROM node:18-alpine
RUN corepack enable pnpm
WORKDIR /app
COPY package.json ./
RUN pnpm install
COPY . .
CMD ["node", "index.js"]
