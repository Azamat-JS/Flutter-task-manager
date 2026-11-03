import { Injectable } from '@nestjs/common';
import { InjectDrizzle } from '@nestjs/drizzle';
import { NewUser, User, users } from 'db/schema';
import { eq } from 'drizzle-orm';
import { NodePgDatabase } from 'drizzle-orm/node-postgres';

@Injectable()
export class AppService {
  constructor(
    @InjectDrizzle()
    private readonly db: NodePgDatabase,
  ) { }

  findAll(): Promise<User[]> {
    return this.db.select().from(users);
  }

  async findOne(id: string): Promise<User | undefined> {
    const [user] = await this.db.select().from(users).where(eq(users.id, id));
    return user;
  }

  async create(user: NewUser): Promise<User> {
    const [createdUser] = await this.db.insert(users).values(user).returning();
    return createdUser;
  }

  async remove(id: string): Promise<void> {
    await this.db.delete(users).where(eq(users.id, id));
  }
}