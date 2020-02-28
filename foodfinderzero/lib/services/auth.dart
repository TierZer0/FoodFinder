import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodfinderzero/services/data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;


  Stream<FirebaseUser> user;
  Stream<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();
  SharedPreferences prefs;

  String currentUser;
  String currentUserName;
  String profileImage;

  AuthService() {
    user = _auth.onAuthStateChanged;

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);
      } else {
        return Stream.value({});
      }
    });
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthResult result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password
    );

    FirebaseUser user = result.user;
    

    //this.currentUser = user.uid;
    //this.currentUserName = user.email;
    await prefs.setString('uid', user.uid);
    await prefs.setString('username', user.email);
    await prefs.setBool('isLoggedIn', true);
    //await prefs.setString('userId', user.uid);

    updateUserData(user);
    
    return user;
  }

  isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //print(prefs.getBool('isLoggedIn'));
    return prefs.getBool('isLoggedIn');
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("username");
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('uid');
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

    FirebaseUser user = result.user;

    //this.currentUser = user.uid;
    //this.currentUserName = user.email;
    await prefs.setString('uid', user.uid);
    await prefs.setString('username', user.email);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setBool('darkTheme', false);
    updateUserData(user);


    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    updateUserData(user);

    loading.add(false);

    await prefs.setString('uid', user.uid);
    await prefs.setString('username', user.email);
    await prefs.setBool('isLoggedIn', true);
    //this.currentUserName = user.displayName;
    //this.currentUser = user.uid;
    //this.profileImage = user.photoUrl;
    
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('uid', user.uid);
    await prefs.setString('username', user.displayName == null ? user.email : user.displayName);
    await prefs.setBool('isLoggedIn', true);
    
    return ref.setData({
      'username': user.displayName == null ? user.email : user.displayName,
      'profileImage' : user.photoUrl,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  signOut() async {
    _auth.signOut();
    
    
    currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

  }
}

final AuthService authService = AuthService();
