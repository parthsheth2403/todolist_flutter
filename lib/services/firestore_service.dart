import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/todo_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ToDo>> getToDos() {
    return _db.collection('todos')
        .where('userId', isEqualTo: _auth.currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Set the ID from Firestore document
      return ToDo.fromJson(data);
    }).toList());
  }

  Future<void> addToDo(ToDo todo) async {
    await _db.collection('todos').add({
      'userId': _auth.currentUser?.uid,
      ...todo.toJson(),
    });
  }

  Future<void> updateToDo(String id, ToDo todo) async {
    await _db.collection('todos').doc(id).update(todo.toJson());
  }

  Future<void> deleteToDo(String id) async {
    await _db.collection('todos').doc(id).delete();
  }
}
