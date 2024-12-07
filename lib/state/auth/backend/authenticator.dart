import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_clone/state/auth/models/auth_result.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whats_clone/utils/logger.dart';

class Authenticator {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  String? get userId => currentUser?.uid;

  bool get isAlreadyLoggedIn => userId != null;

  String get displayName => currentUser?.displayName ?? '';

  String? get email => currentUser?.email;

  Future<AuthResult> signInWithGoogle() async {
    final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
    if (googleUser == null) return AuthResult.abort;
    final googleSignInAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuth.idToken,
        accessToken: googleSignInAuth.accessToken);

    try {
      FirebaseAuth.instance.signInWithCredential(credential);
      return AuthResult.success;
    } catch (e) {
      log.e(e);

      return AuthResult.failed;
    }
  }
}
