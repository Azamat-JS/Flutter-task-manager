import { ConflictException, Injectable } from '@nestjs/common';
import { InjectDrizzle } from '@nestjs/drizzle';
import { NewTask, Task, tasks } from 'db/schema';
import { and, eq, inArray } from 'drizzle-orm';
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

    async syncTask(taskList: Task[], user: PublicUser) {
        if (taskList.length === 0) {
            return [];
        }

        const taskIds = [...new Set(taskList.map((task) => task.id))];
        const tasksToInsert: NewTask[] = taskList.map((task) => ({
            ...task,
            createdAt: new Date(task.createdAt!),
            updatedAt: new Date(task.updatedAt!),
            dueAt: new Date(task.dueAt!),
            uid: user.id,
        }));

        return this.db.transaction(async (tx) => {
            await tx
                .insert(tasks)
                .values(tasksToInsert)
                .onConflictDoNothing({ target: tasks.id });

            const syncedTasks = await tx
                .select()
                .from(tasks)
                .where(and(eq(tasks.uid, user.id), inArray(tasks.id, taskIds)));

            if (syncedTasks.length !== taskIds.length) {
                throw new ConflictException('One or more task IDs are already in use');
            }
            return syncedTasks;
        }, { isolationLevel: 'read committed' });
    }
}
