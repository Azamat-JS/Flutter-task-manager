import { users, type NewUser, type User } from 'db/schema';

/** A user as the API returns it: never the password hash. */
export type PublicUser = Omit<User, 'password'>;

export type LoginDto = Pick<NewUser, 'email' | 'password'>;

export const publicUserColumns = {
  id: users.id,
  name: users.name,
  email: users.email,
  createdAt: users.createdAt,
  updatedAt: users.updatedAt,
};

export function toPublicUser({ password, ...user }: User): PublicUser {
  return user;
}
