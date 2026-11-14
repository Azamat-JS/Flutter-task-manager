import { Body, Controller, Delete, Get, Param, Post } from '@nestjs/common';
import { CurrentUser } from '@nestjs/authentication';
import { TasksService } from './tasks.service';
import type { NewTask } from 'db/schema';
import type { PublicUser } from '../auth/auth.types';

@Controller('tasks')
export class TasksController {
  constructor(private readonly tasksService: TasksService) { }

  @Get()
  async getAllTasks(
    @CurrentUser() user: PublicUser,
  ) {
    return this.tasksService.getAllTasks(user.id)
  }

  @Post('create')
  async createTask(
    @Body() newTask: Omit<NewTask, 'uid'>,
    @CurrentUser() user: PublicUser,
  ) {

    return this.tasksService.createTask({ ...newTask, uid: user.id });
  }

  @Delete('delete/:id')
  async deleteTask(
    @Param('id') id: string,
    @CurrentUser() user: PublicUser,
  ) {
    return this.tasksService.deleteTask(id, user)
  }
}
