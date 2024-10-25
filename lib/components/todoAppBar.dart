import 'package:flutter/material.dart';
import 'package:todo_with_chat_app/pages/add_todo_page.dart';

class TodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isGridView; // Whether the current view is grid or list
  final VoidCallback onToggleView; // Callback to toggle between list and grid
  final VoidCallback onProfileTap; // Callback for profile picture tap

  TodoAppBar({
    required this.isGridView,
    required this.onToggleView,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          // Navigate to AddTodoPage when icon is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );
        },
      ),
      title: const Padding(
        padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search your notes',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isGridView ? Icons.grid_view : Icons.list,
            color: Colors.black,
          ),
          onPressed: onToggleView,
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://example.com/profile.jpg', // Replace with your profile picture URL
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
