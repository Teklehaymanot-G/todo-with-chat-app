import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_with_chat_app/components/my_textfield.dart';
import 'package:todo_with_chat_app/components/todoAppBar.dart';
import 'package:todo_with_chat_app/pages/todo_detail_page.dart';
import 'package:todo_with_chat_app/services/todo/todo_service.dart';
import 'package:todo_with_chat_app/utils/converter.dart';

class TodoTab extends StatefulWidget {
  @override
  _TodoTabState createState() => _TodoTabState();
}

class _TodoTabState extends State<TodoTab> {
  final TodoService _todoService = TodoService();
  bool isGridView = true; // Toggle between grid and list views
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _search = TextEditingController();

  void onToggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void onProfileTap() {
    // Handle profile tap
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TodoAppBar(
          isGridView: isGridView,
          onToggleView: onToggleView,
          onProfileTap: onProfileTap),
      body: StreamBuilder (
        stream: _todoService.getTodosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching todos'));
          }

          final todos = snapshot.data ?? [];

          if (todos.isEmpty) {
            return const Center(child: Text('No Todos Available'));
          }

          return isGridView
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust the number of columns
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2, // Adjust based on design
                  ),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index] as Map<String, dynamic>;
                    return _buildTodoCard(todo);
                  },
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index] as Map<String, dynamic>;
                    return _buildTodoCard(todo);
                  },
                );
        },
      ),
    );
  }

  Widget _buildTodoCard(Map<String, dynamic> todo) {
    final bodyContent = todo['description'] ?? [];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: COLOR_CONVERTER[todo['color']],
      child: GestureDetector(
        onTap: () {
          // Navigate to TodoDetailPage when the card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoDetailPage(todo)),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo['isPinned'] ?? false)
                const Icon(Icons.push_pin, color: Colors.red),
              Text(
                todo['title'] ?? 'Untitled',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: bodyContent.length,
                  itemBuilder: (context, index) {
                    final item = bodyContent[index];
                    print(bodyContent);
                    // Check content type and render accordingly
                    if (item['type'] == 'text') {
                      return Text(
                        item['content'],
                        style: TextStyle(fontSize: 16),
                      );
                    }
                    else if (item['type'] == 'image') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Image.network(
                          item['content'], // Image URL
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Error handling
                        ),
                      );
                    }
                    else if (item['type'] == 'list') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List<Widget>.generate(item['content'].length, (index) {
                            return Row(
                              children: [
                                Icon(Icons.check_box_outline_blank), // Or checked icon
                                SizedBox(width: 5),
                                Text(item['content'][index]),
                              ],
                            );
                          }),
                        ),
                      );
                    }
                    return SizedBox.shrink(); // Fallback for unsupported types
                  },
                ),
              ),
              Text(
                todo['body'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
