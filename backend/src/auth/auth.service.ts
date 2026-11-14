import { PasswordHasher, TokenService } from '@nestjs/authentication';
import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectDrizzle } from '@nestjs/drizzle';
import { NewUser, User, users } from 'db/schema';
import { eq } from 'drizzle-orm';
import { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { type LoginDto, type PublicUser, toPublicUser } from './auth.types';


@Injectable()
export class AuthService {
  constructor(
    @InjectDrizzle()
    private readonly db: NodePgDatabase,
    private readonly passwordHasher: PasswordHasher,
    private readonly tokenService: TokenService,
  ) { }

  async register({ email, password, name }: NewUser): Promise<PublicUser> {
    const [foundUser] = await this.db.select().from(users).where(eq(users.email, email));

    if (foundUser) {
      throw new BadRequestException('Email already exists')
    }
    const hashedPassword = await this.passwordHasher.hash(password);
    const [createdUser] = await this.db
      .insert(users)
      .values({ name, email, password: hashedPassword })
      .returning();
    return toPublicUser(createdUser);
  }

  async login({ email, password }: LoginDto) {
    const [foundUser] = await this.db.select().from(users).where(eq(users.email, email));


    const isPasswordMatch = await this.passwordHasher.verify(password, foundUser?.password);

    if (!foundUser || !isPasswordMatch) {
      throw new UnauthorizedException('Email or password is invalid')
    }

    const tokens = await this.tokenService.issue(foundUser.id, { method: 'password' });
    return { user: toPublicUser(foundUser), ...tokens };
  }

  refresh(refreshToken: string) {
    return this.tokenService.refresh(refreshToken);
  }

  async logout(refreshToken: string): Promise<void> {
    await this.tokenService.revoke(refreshToken);
  }
}
