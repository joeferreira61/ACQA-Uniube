import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_manager/features/features/auth/services/auth_service.dart';
import 'package:task_manager/features/features/tasks/model/task_model.dart';
import 'package:task_manager/features/features/tasks/services/task_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final AuthService _authService = AuthService();
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              // O AuthWrapper cuidará da navegação para a tela de login
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple.shade200,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.getTasksForDate(_selectedDay ?? DateTime.now()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhuma tarefa para este dia."));
                }

                final tasks = snapshot.data!;
                // Ordenação: Pendentes > Concluídas, depois alfabeticamente
                tasks.sort((a, b) {
                  if (a.isCompleted != b.isCompleted) {
                    return a.isCompleted ? 1 : -1;
                  }
                  return a.title.compareTo(b.title);
                });

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskListTile(task: task, taskService: _taskService);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final taskTitleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Nova Tarefa'),
          content: TextField(
            controller: taskTitleController,
            decoration: const InputDecoration(hintText: "Título da tarefa"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Adicionar'),
              onPressed: () {
                final title = taskTitleController.text.trim();
                if (title.isNotEmpty) {
                  final newTask = Task(
                    title: title,
                    date: _selectedDay ?? DateTime.now(),
                  );
                  _taskService.addTask(newTask);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.task,
    required this.taskService,
  });

  final Task task;
  final TaskService taskService;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted ? Colors.grey : null,
        ),
      ),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) {
          if (task.id != null) {
            taskService.updateTask(task.id!, isCompleted: value ?? false);
          }
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () {
          if (task.id != null) {
            taskService.deleteTask(task.id!);
          }
        },
      ),
    );
  }
} 