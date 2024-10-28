import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream<QuerySnapshot> getTodosStream() {
  //   return _firertore.collection("todos").snapshots();
  // }

  Stream<List<Map<String, dynamic>>> getTodosStream() {
    return _firestore.collection("todos").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add the document ID to the data
        return data;
      }).toList();
    });
  }

  Future<void> updatePinnedStatus(String todoId, bool pinned) async {
    try {
      await _firestore.collection('todos').doc(todoId).update({
        'pinned': pinned,
      });
    } catch (e) {
      throw Exception('Failed to update pinned status: $e');
    }
  }

  Future<void> addTodo(Map<String, dynamic> todoData) async {
    await _firestore.collection('todos').add(todoData);
  }
}
