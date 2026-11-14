import { Injectable } from '@nestjs/common';
import { InjectDrizzle } from '@nestjs/drizzle';
import { NewTask, tasks } from 'db/schema';
import { NodePgDatabase } from 'drizzle-orm/node-postgres';

@Injectable()
export class TasksService {
    constructor(
        @InjectDrizzle()
        private readonly db: NodePgDatabase,
    ) { }

    async createTask(newTask: NewTask) {
        const [task] = await this.db.insert(tasks).values(newTask).returning();

        return task;
    }
}
