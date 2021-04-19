import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Future<String> signIn() async {
    try {
      await _firebaseAuth.signInAnonymously();
      // User user = userCredential.user;
      return "Signed in sucessfully";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
