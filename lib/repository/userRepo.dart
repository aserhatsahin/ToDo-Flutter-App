import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepo {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fsInstance = FirebaseFirestore.instance;

//GET UID
  Future<String?> getCurrentUID() async {
    final user = auth.currentUser;
    return user?.uid; // Eğer kullanıcı null ise null döndür
  }

  Future<void> createUserInFirestore() async {
    try {
      String? uid = await getCurrentUID();

      if (uid == null) {
        print("Error: No user is logged in.");
        return;
      }
      await fsInstance
          .collection('Users')
          .doc(uid)
          .set({'createdAt': FieldValue.serverTimestamp(), 'uid': uid});

      print("User Todo collection initialized successfully.");
    } catch (e) {
      print("Error creating user tasks: $e");
    }
  }
}
