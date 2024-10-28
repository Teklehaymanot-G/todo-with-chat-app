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
        backgroundColor: COLOR_CONVERTER[widget.todo["color"] ?? "grey"],
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
      body: Container(
        color: COLOR_CONVERTER[widget.todo["color"] ?? "grey"],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.todo['title'] ?? 'Untitled', // Display todo title
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.todo['isPinned'] ?? false)
                    const Icon(Icons.push_pin, color: Colors.red),
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
      ),
    );
  }
}
