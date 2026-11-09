import { Injectable } from '@nestjs/common';
import {
  AuthenticationRegistry,
  JwtBearerProvider,
  type JwtClaims,
} from '@nestjs/authentication';
import { InjectDrizzle } from '@nestjs/drizzle';
import { eq } from 'drizzle-orm';
import { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { users } from 'db/schema';
import { publicUserColumns, type PublicUser } from './auth.types';

@Injectable()
export class JwtAuth extends JwtBearerProvider<PublicUser> {
  constructor(
    @InjectDrizzle()
    private readonly db: NodePgDatabase,
    registry: AuthenticationRegistry,
  ) {
    super();
    registry.registerProvider(this);
  }

  async validate({ sub }: JwtClaims): Promise<PublicUser | null> {
    if (!sub) return null;
    const [user] = await this.db
      .select(publicUserColumns)
      .from(users)
      .where(eq(users.id, sub));
    return user ?? null;
  }
}
