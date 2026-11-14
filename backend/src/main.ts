import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const PORT = process.env.PORT;
  await app.listen(PORT ?? 3003);
  console.log('Server is running on ' + PORT);
}
bootstrap();
//57:00