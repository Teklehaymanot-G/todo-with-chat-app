// add_todo_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_with_chat_app/services/todo/todo_service.dart';
import 'package:todo_with_chat_app/utils/converter.dart';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TodoService _todoService = TodoService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedColor;
  bool _isPinned = false;

  void _saveTodo() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      // Show a warning if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and description cannot be empty.")),
      );
      return;
    }

    final newTodo = {
      "title": title,
      "description": description,
      "color": _selectedColor ?? "defaultColor",
      "isPinned": _isPinned,
      "created_at": Timestamp.now(),
    };

    await _todoService.addTodo(newTodo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Add Todo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveTodo, // Save the todo on tap
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedColor,
              items: COLOR_CONVERTER.keys
                  .map((color) => DropdownMenuItem(
                        value: color,
                        child: Text(color),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedColor = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Select Color'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isPinned,
                  onChanged: (value) {
                    setState(() {
                      _isPinned = value!;
                    });
                  },
                ),
                Text("Pin this Todo"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
