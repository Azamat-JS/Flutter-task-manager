import { Module } from '@nestjs/common';
import { PasswordHasher } from '@nestjs/authentication';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';

@Module({
  controllers: [AuthController],
  providers: [
    AuthService,
    { provide: PasswordHasher, useValue: new PasswordHasher() },
  ],
})
export class AuthModule {}
