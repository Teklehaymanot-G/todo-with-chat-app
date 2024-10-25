import 'package:flutter/material.dart';
import 'package:todo_with_chat_app/services/todo/todo_service.dart';
import 'package:todo_with_chat_app/utils/converter.dart';

class TodoDetailPage extends StatefulWidget {
  final Map<String, dynamic> todo; // Accept the todo object

  const TodoDetailPage(this.todo, {Key? key}) : super(key: key);

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  @override
  Widget build(BuildContext context) {
    final bodyContent = widget.todo['description'] ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.todo['pinned'] ? Icons.push_pin : Icons.push_pin_outlined,
              color: widget.todo['pinned'] ? Colors.red : null,
            ),
            onPressed: () {
              final _todoService = TodoService();
              _todoService.updatePinnedStatus(widget.todo["id"], !widget.todo['pinned']);
              setState(() {
                widget.todo['pinned'] = !widget.todo['pinned'];
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.archive_outlined),
            onPressed: () {
              // Handle archive action
            },
          ),
          IconButton(
            icon: Icon(Icons.lock_outline),
            onPressed: () {
              // Handle lock action
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.todo['title'] ?? 'Untitled', // Display todo title
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.todo['body'] ?? 'No description available', // Display todo description
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bodyContent.length,
                itemBuilder: (context, index) {
                  final item = bodyContent;
print(bodyContent);
                  // Check content type and render accordingly
                  // if (item['type'] == 'text') {
                  //   return Text(
                  //     item['content'],
                  //     style: TextStyle(fontSize: 16),
                  //   );
                  // }
                  // else if (item['type'] == 'image') {
                  //   return Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 10),
                  //     child: Image.network(
                  //       item['content'], // Image URL
                  //       errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Error handling
                  //     ),
                  //   );
                  // }
                  // else if (item['type'] == 'list') {
                  //   return Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 10),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: List<Widget>.generate(item['content'].length, (index) {
                  //         return Row(
                  //           children: [
                  //             Icon(Icons.check_box_outline_blank), // Or checked icon
                  //             SizedBox(width: 5),
                  //             Text(item['content'][index]),
                  //           ],
                  //         );
                  //       }),
                  //     ),
                  //   );
                  // }
                  return SizedBox.shrink(); // Fallback for unsupported types
                },
              ),
            ),
            Spacer(),
            Text(
              "Edited ${FORMATE_DATE_TIME(widget.todo['lastEdited']) ?? 'Unknown time'}", // Display last edited time
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
