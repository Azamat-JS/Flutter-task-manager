import { Injectable } from '@nestjs/common';
import { InjectDrizzle } from '@nestjs/drizzle';
import { NewTask, tasks, users } from 'db/schema';
import { and, eq } from 'drizzle-orm';
import { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { PublicUser } from 'src/auth/auth.types';

@Injectable()
export class TasksService {
    constructor(
        @InjectDrizzle()
        private readonly db: NodePgDatabase,
    ) { }

    async getAllTasks(userId: string) {
        const allTasks = await this.db.select().from(tasks).where(eq(tasks.uid, userId))

        return allTasks;
    }

    async createTask(newTask: NewTask) {
        const [task] = await this.db.insert(tasks).values(newTask).returning();
        return task;
    }

    async deleteTask(id: string, user: PublicUser) {
        await this.db
            .delete(tasks)
            .where(and(eq(tasks.id, id), eq(tasks.uid, user.id)));

        return 'Deleted successfully!'
    }
}
