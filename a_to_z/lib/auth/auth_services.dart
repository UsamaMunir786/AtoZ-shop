import 'package:a_to_z/db/db_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get user => _auth.currentUser;

  static Future<bool> loginAdmin(String email, String password) async{
   final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
   return DbHelper.isAdmin(credential.user!.uid);
  }

  static Future<void> logOut() async{
    await _auth.signOut();

    
  }
}

