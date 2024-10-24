import 'package:flutter/material.dart';
import 'package:todo_with_chat_app/services/todo/todo_service.dart';

class TodoTab extends StatefulWidget {
  const TodoTab({super.key});

  @override
  _TodoTabState createState() => _TodoTabState();
}

class _TodoTabState extends State<TodoTab> {
  final TodoService _todoService = TodoService();
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _todoService.getTodosStream(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          print("------------------");
          print(snapshot.connectionState);
          print("==================");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Todos available.'));
          }

          final todos = snapshot.data!;

          return _isGridView
              ? _buildGridView(todos)
              : _buildListView(todos);
        },
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo['title'] ?? 'Untitled'),
          subtitle: Text(todo['description'] ?? ''),
          trailing: todo['isPinned'] == true
              ? const Icon(Icons.push_pin)
              : const Icon(Icons.push_pin_outlined),
          onTap: () {
            // You can add functionality to update the todo or navigate to a detailed view
          },
        );
      },
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> todos) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          color: Colors.grey[200], // You can implement color-coding here
          child: GridTile(
            header: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                todo['title'] ?? 'Untitled',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            footer: IconButton(
              icon: todo['isPinned'] == true
                  ? const Icon(Icons.push_pin)
                  : const Icon(Icons.push_pin_outlined),
              onPressed: () {
                // You can implement functionality to pin/unpin todo
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(todo['description'] ?? ''),
            ),
          ),
        );
      },
    );
  }
}
