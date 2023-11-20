import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senly/application/domain/entity/user.dart';
import 'package:senly/application/ui/main_navigation/main_navigation.dart';

class UserService {
  DocumentSnapshot? _lastUserDocument; // Последний загруженный документ

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseAuth get auth => _auth;
  static Stream<User?> get authUserStream => _auth.authStateChanges();

  static UserE? _currentUser;
  static UserE? get user => _currentUser;

  static Future<void> logOut(BuildContext context) async {
    _currentUser = null;
    await _auth.signOut();

    Future.microtask(
      () => Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationScreens.registerScreen,
        (Route<dynamic> route) => false,
      ),
    );
  }

  static Future<bool> isUserRegistered() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final signInMethods =
            await _auth.fetchSignInMethodsForEmail(user.email!);
        return signInMethods.isNotEmpty;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> getUserFromFirestore(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDoc = await userRef.get();
    if (userDoc.exists) {
      _currentUser = UserE.fromMap(userDoc.data()!);
      return true;
    }
    return false;
  }

  static Future<UserE?> getUserInfoFromFirestore(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDoc = await userRef.get();
    if (userDoc.exists) {
      return UserE.fromMap(userDoc.data()!);
    }
    return null;
  }

  static Future<void> saveUserToFirestore(UserE user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);
    await userRef.set(user.toMap());
    _currentUser = user;
  }

  // static Future<void> updateCurrentUser(передать сюда только то, что меняется {}) async {
  static Future<void> updateCurrentUser(
    UserE updatedUser, {
    String? uid,
  }) async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid ?? updatedUser.id);
    await userRef.update(updatedUser.toMap());

    if (uid == null) _currentUser = updatedUser;
  }

  Future<List<UserE>> getNextUsers({
    String? searchQuery,
    bool? deletePrev,
    int limit = 20,
  }) async {
    try {
      List<UserE> result = [];
      bool shouldFetchMore = false;

      do {
        Query query =
            FirebaseFirestore.instance.collection('users').limit(limit);

        if (_lastUserDocument != null && deletePrev == null ||
            _lastUserDocument != null && shouldFetchMore) {
          query = query.startAfterDocument(_lastUserDocument!);
        }
        if (deletePrev == true) {
          _lastUserDocument = null;
        }

        QuerySnapshot snapshot = await query.get();

        List<UserE> users = [];

        if (snapshot.docs.isNotEmpty) {
          _lastUserDocument = snapshot.docs.last;

          for (final doc in snapshot.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final user = UserE.fromMap(data);
            // bool isApproach = true;
            users.add(user);
          }
        }
        result.addAll(users);

        // Если после фильтрации мы получили пустой результат и есть еще документы для загрузки,
        // то продолжаем загрузку следующих 20 юзеров
        shouldFetchMore = result.isEmpty && snapshot.docs.length == limit;
      } while (shouldFetchMore);

      return result;
    } catch (e) {
      throw e.toString();
    }
  }
}
