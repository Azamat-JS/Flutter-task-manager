import { PasswordHasher } from '@nestjs/authentication';
import { Injectable } from '@nestjs/common';
import { InjectDrizzle } from '@nestjs/drizzle';
import { NewUser, User, users } from 'db/schema';
import { eq } from 'drizzle-orm';
import { NodePgDatabase } from 'drizzle-orm/node-postgres';


@Injectable()
export class AuthService {
  constructor(
    @InjectDrizzle()
    private readonly db: NodePgDatabase,
    private readonly passwordHasher: PasswordHasher
  ) { }
  async create(user: NewUser): Promise<User | { message: string }> {
    const { email, password, name } = user;
    const [foundUser] = await this.db.select().from(users).where(eq(users.email, email));

    if (foundUser) {
      return { message: "This email already exists" }
    }
    const hashedPassword = await this.passwordHasher.hash(user.password);
    const newUser: NewUser = {
      name,
      email,
      password: hashedPassword
    }
    const [createdUser] = await this.db.insert(users).values(newUser).returning();
    return createdUser;
  }

  findAll() {
    return `This action returns all auth`;
  }

  findOne(id: number) {
    return `This action returns a #${id} auth`;
  }

  update(id: number, updateAuthDto: User) {
    return `This action updates a #${id} auth`;
  }

  remove(id: number) {
    return `This action removes a #${id} auth`;
  }
}
