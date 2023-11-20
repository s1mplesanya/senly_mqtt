import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get user => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount == null) return null;

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    print(_auth.currentUser);
    return userCred;
  }

  bool isAlreadyLogged() {
    return _auth.currentUser != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
