import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_app/classes/todo.dart';
import 'package:todo_list_app/repository/todoRepository.dart';
//FIRE STORAGE PROFILE 
class firebaseRepo extends todoRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference getUserTodosCollection() {
    String? uid = _auth.currentUser?.uid;

    return _firestore.collection('Users').doc(uid).collection('Todo');
  }

  Stream<List<Todo>> getAllStream() {
    return getUserTodosCollection().snapshots().map((QuerySnapshot snapshot) {
      //firestore collectionu surekli dinleyen bir stream dondurur,snapshots() bir degisiklik yapildiginda veriyi gunceller
      return snapshot.docs.map((doc) {
        //collectiondaki doclari tek tek dolasir
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
    String? uid = _auth.currentUser?.uid;

    if (uid == null) {
      print('ERROR: No user is logged in!');
      return;
    }

    try {
      DocumentReference docRef = getUserTodosCollection().doc();
      String docId = docRef.id;

      await docRef.set({
        'id': docId,
        'taskName': task,
        'isEdit': false,
        'isCompleted': false,
        'dueDate': dueDate
      });
    } catch (e) {
      print("Firestore write error: $e");
    }
  }

  @override
  Future<void> cbChanged(String docId) async {
    DocumentSnapshot cbDoc = await getUserTodosCollection().doc(docId).get();

    if (cbDoc.exists) {
      bool currentStatus = cbDoc["isCompleted"] ?? false;

      await getUserTodosCollection()
          .doc(docId)
          .update({'isCompleted': !currentStatus});
    }
  }

  @override
  Future<void> delete(String docId) async {
    await getUserTodosCollection().doc(docId).delete();
  }

  @override
  Future<void> editDate(String docId, DateTime pickedDate) async {
    DocumentSnapshot dateDoc = await getUserTodosCollection().doc(docId).get();

    if (dateDoc.exists) {
      await getUserTodosCollection()
          .doc(docId)
          .update({'isEdit': true, 'dueDate': pickedDate});
    }
  }

  @override
  Future<void> editName(String name, String docId) async {
    DocumentSnapshot editDoc = await getUserTodosCollection().doc(docId).get();

    if (editDoc.exists) {
      await getUserTodosCollection()
          .doc(docId)
          .update({'isEdit': false, 'taskName': name});
    }
  }

  @override
  Future<List<Todo>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
}
