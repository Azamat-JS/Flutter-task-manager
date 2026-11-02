FROM node:20

WORKDIR /app

COPY . .

RUN pnpm install

EXPOSE 8000

CMD ["pnpm", "dev"]