FROM node:20

WORKDIR /app

RUN npm install -g pnpm@10.16.1

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

COPY . .

EXPOSE 8000

CMD ["pnpm", "dev"]
