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
      body: StreamBuilder(
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
                  padding:
                      const EdgeInsets.all(8.0), // Add padding around the grid
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12, // Increased spacing between rows
                    crossAxisSpacing: 12, // Increased spacing between columns
                    childAspectRatio:
                        1.5, // Adjusted aspect ratio for better height
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
                    print(todo);

                    return _buildTodoCard(todo);
                  },
                );
        },
      ),
    );
  }

  Widget _buildTodoCard(Map<String, dynamic> todo) {
    final bodyContent = todo['description'] ?? [];

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 450,
      ),
      child: Card(
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
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: SingleChildScrollView(
              // Added SingleChildScrollView here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                  if (bodyContent['text'] != null)
                    Text(
                      bodyContent['text'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (bodyContent['image'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.network(
                        bodyContent["image"] ?? "",
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Column(
                            children: [
                              Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
                              Text(
                                'Image could not load due to a network or URL issue.',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (bodyContent['list'] is List &&
                      bodyContent['list'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.generate(
                            bodyContent["list"].length, (i) {
                          return Row(
                            children: [
                              const Icon(Icons.check_box_outline_blank),
                              const SizedBox(width: 5),
                              Text(bodyContent["list"][i] ?? ''),
                            ],
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
