import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_app/repository/userRepo.dart';

class AuthService {
//instance of auth

  final FirebaseAuth auth = FirebaseAuth.instance;

//sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

//sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      UserRepo userRepo = UserRepo();
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userRepo.createUserInFirestore();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

//sign out
  Future<void> signOut() async {
    return await auth.signOut();
  }
}
