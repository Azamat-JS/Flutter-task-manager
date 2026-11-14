import { Body, Controller, Post } from '@nestjs/common';
import { CurrentUser } from '@nestjs/authentication';
import { TasksService } from './tasks.service';
import type { NewTask } from 'db/schema';
import type { PublicUser } from '../auth/auth.types';

@Controller('tasks')
export class TasksController {
  constructor(private readonly tasksService: TasksService) { }

  @Post('create')
  async createTask(
    @Body() newTask: Omit<NewTask, 'uid'>,
    @CurrentUser() user: PublicUser,
  ) {
    // The owner always comes from the access token, never from the body.
    return this.tasksService.createTask({ ...newTask, uid: user.id });
  }
}
