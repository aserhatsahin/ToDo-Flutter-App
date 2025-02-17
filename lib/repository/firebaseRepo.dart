import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/classes/todo.dart';
import 'package:todo_list_app/repository/todoRepository.dart';

class firebaseRepo extends todoRepository {
  final CollectionReference todos =
      FirebaseFirestore.instance.collection("Todo");

  Stream<List<Todo>> getAllStream() {
    return todos.snapshots().map((QuerySnapshot snapshot) {//firestore collectionu surekli dinleyen bir stream dondurur,snapshots() bir degisiklik yapildiginda veriyi gunceller
      return snapshot.docs.map((doc) {//collectiondaki doclari tek tek dolasir
        return Todo(
          id: doc.id,
          taskName: doc["taskName"],
          isCompleted: doc["isCompleted"],
          isEdit: doc["isEdit"],
          dueDate: (doc["dueDate"] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  @override
  Future<void> add(String task, DateTime dueDate) async {
    DocumentReference docRef = todos.doc();
    String docId = docRef.id;

    await docRef.set({
      'id': docId,
      'taskName': task,
      'isEdit': false,
      'isCompleted': false,
      'dueDate': dueDate
    });
  }

  @override
  Future<void> cbChanged(String docId) async {
    DocumentSnapshot cbDoc = await todos.doc(docId).get();

    if (cbDoc.exists) {
      bool currentStatus = cbDoc["isCompleted"] ?? false;

      await todos.doc(docId).update({'isCompleted': !currentStatus});
    }
  }

  @override
  Future<void> delete(String docId) async {
    await todos.doc(docId).delete();
  }

  @override
  Future<void> editDate(String docId, DateTime pickedDate) async {
    DocumentSnapshot dateDoc = await todos.doc(docId).get();

    if (dateDoc.exists) {
      await todos.doc(docId).update({'isEdit': true, 'dueDate': pickedDate});
    }
  }

  @override
  Future<void> editName(String name, String docId) async {
    DocumentSnapshot editDoc = await todos.doc(docId).get();

    if (editDoc.exists) {
      await todos.doc(docId).update({'isEdit': false, 'taskName': name});
    }
  }
  
  @override
  Future<List<Todo>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
}
