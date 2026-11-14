import { Body, Controller, Post } from '@nestjs/common';
import { TasksService } from './tasks.service';

@Controller('tasks')
export class TasksController {
  constructor(private readonly tasksService: TasksService) { }

  @Post('create')
  async createTask(@Body() data: string) {
    return this.tasksService.createTask(data)
  }
}
