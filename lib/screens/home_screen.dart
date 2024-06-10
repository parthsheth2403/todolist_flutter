import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo_model.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<ToDo>>(
          stream: firestoreService.getToDos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final todos = snapshot.data ?? [];
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showTodoDialog(context, firestoreService, todo),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => firestoreService.deleteToDo(todo.id),
                      ),
                    ],
                  ),
                  onTap: () => firestoreService.updateToDo(
                    ToDo(
                      id: todo.id,
                      title: todo.title,
                      description: todo.description,
                      dueDate: todo.dueDate,
                      isCompleted: !todo.isCompleted,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(context, firestoreService, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTodoDialog(BuildContext context, FirestoreService firestoreService, ToDo? todo) {
    final _titleController = TextEditingController(text: todo?.title);
    final _descriptionController = TextEditingController(text: todo?.description);
    final _dueDateController = TextEditingController(
      text: todo != null ? todo.dueDate.toIso8601String() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(todo == null ? 'Add To-Do' : 'Edit To-Do'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: 'Due Date'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: todo?.dueDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (date != null) {
                  _dueDateController.text = date.toIso8601String();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTodo = ToDo(
                id: todo?.id ?? '',
                title: _titleController.text,
                description: _descriptionController.text,
                dueDate: DateTime.parse(_dueDateController.text),
                isCompleted: todo?.isCompleted ?? false,
              );
              if (todo == null) {
                firestoreService.addToDo(newTodo);
              } else {
                firestoreService.updateToDo(newTodo);
              }
              Navigator.of(context).pop();
            },
            child: Text(todo == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

}
