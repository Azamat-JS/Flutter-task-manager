import { Controller, Get, Post, Body, Patch, Param, Delete, HttpCode } from '@nestjs/common';
import { CurrentUser, Public } from '@nestjs/authentication';
import { AuthService } from './auth.service';
import type { NewUser, User } from 'db/schema';
import type { LoginDto, PublicUser } from './auth.types';


@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Public()
  @Post('register')
  register(@Body() createAuthDto: NewUser) {
    console.log(createAuthDto)
    return this.authService.register(createAuthDto);
  }

  @Public()
  @Post('login')
  @HttpCode(200)
  login(@Body() loginDto: LoginDto) {
    console.log(loginDto)
    return this.authService.login(loginDto);
  }

  @Public()
  @Post('refresh')
  @HttpCode(200)
  refresh(@Body('refreshToken') refreshToken: string) {
    return this.authService.refresh(refreshToken);
  }

  @Public()
  @Post('logout')
  @HttpCode(204)
  logout(@Body('refreshToken') refreshToken: string) {
    return this.authService.logout(refreshToken);
  }

  @Get('me')
  me(@CurrentUser() user: PublicUser) {
    return user;
  }
}
