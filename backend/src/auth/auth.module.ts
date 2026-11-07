import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtAuth } from './jwt-auth.provider';

// PasswordHasher and TokenService come from AuthenticationModule (global,
// configured in AppModule), so they are not provided here.
@Module({
  controllers: [AuthController],
  providers: [AuthService, JwtAuth],
})
export class AuthModule {}
