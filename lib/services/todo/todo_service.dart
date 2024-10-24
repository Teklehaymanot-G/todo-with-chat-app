import 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  final FirebaseFirestore _firertore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getTodosStream() {
    return _firertore.collection("todo").snapshots().map((snapshot) {
      print("snapshot-----");
      print(snapshot);
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }
}
