import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:interviya/data/models/history_model.dart';
import 'package:interviya/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

Stream<User?> get authStateChanges => _auth.authStateChanges();

Future<String?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print(googleUser);
    if (googleUser == null) {
      return "canceled";
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      final String? fallbackEmail = googleUser.email.isNotEmpty ? googleUser.email : null;
      final String? resolvedEmail = user.email ?? fallbackEmail;
      
      final String resolvedFullName = user.displayName ?? googleUser.displayName ?? "User";

      if (resolvedEmail == null || resolvedEmail.isEmpty) {
        return "Failed to retrieve email address from your Google account. Please check your account privacy settings.";
      }

      final DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      final DocumentSnapshot userDoc = await userRef.get();

      if (!userDoc.exists) {
        await userRef.set({
          'fullName': resolvedFullName,
          'email': resolvedEmail.trim(),
          'uid': user.uid,
          'hasFinishedSetup': false,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await userRef.set({
          'fullName': resolvedFullName,
          'email': resolvedEmail.trim(),
          'uid': user.uid,
        }, SetOptions(merge: true));
      }
    }

    return "success";
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    return e.toString();
  }
}

  Future<String?> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username.trim(),
        'email': email.trim(),
        'uid': userCredential.user!.uid,
        'hasFinishedSetup': false,
        'role': 'user',
        'createdAt': DateTime.now(),
      });

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser.uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  Stream<List<HistoryModel>> getUserHistoryStream() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('history')
        // Ensure this matches your Firestore field name ('createdAt' or 'timestamp')
        .orderBy('timestamp', descending: true) 
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();

            // Firestore Timestamps must be handled carefully before mapping
            if (data['timestamp'] is Timestamp) {
              data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
            }

            // Maps structural data smoothly into your HistoryModel
            return HistoryModel.fromMap(data, doc.id);
          }).toList();
        });
  }

  Future<String?> updateUserProfile(UserModel userData) async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).set(
        userData.toMap(),
        SetOptions(merge: true), 
      );

      return "success";
    } catch (e) {
      return e.toString();
    }
  }
  
  Future<String?> signOutUser() async {
    try {
      await _googleSignIn.signOut(); 
      await _auth.signOut();
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}