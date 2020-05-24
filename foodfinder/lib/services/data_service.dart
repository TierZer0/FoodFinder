import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodfinder/services/SecretLoader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class DataService with ChangeNotifier {
  final primaryLight = new Color(0xFFEEF1F0);
  final primaryLightElevated = new Color(0xFFDEE5E3);//new Color(0xFFE9ECEB);
  final primaryDark = new Color(0xFF2E2B2B);
  final primaryDarkElevated = new Color(0xFF4E4C4C);
  final secondary = new Color(0xFFA5E9E1);
  final tertiary = new Color(0xFF388186);
  bool darkTheme = false;
  changeTheme(bool theme) {
    darkTheme = theme;
    notifyListeners();
  }

  getBackgroundColor() {
    if (darkTheme) {
      return primaryDark;
    } else {
      return primaryLight;
    }
  }

  getBackgroundColorElevated() {
    if (darkTheme) {
      return primaryDarkElevated;
    } else {
      return primaryLightElevated;
    }
  }

  getButtonColor() {
    return secondary;
  }

  getActiveIconColor() {
    return tertiary;
  }

  getTextColor() {
    if (darkTheme) {
      return primaryLight;
    } else {
      return primaryDark;
    }
  }

  getSecondaryColor() {
    return secondary;
  }

  getTertiaryColor() {
    return tertiary;
  }
  
  bool isLoggedIn = false;
  getIsLoggedIn() {
    return isLoggedIn;
  }

  setLoggedIn(bool status) {
    notifyListeners();
    isLoggedIn = status;
  }

  getUsername() {
    return authService.getUsername();
  }

  googleSignIn() {
    authService.googleSignIn().then(
      (response) {
        response == true ? setLoggedIn(true) : setLoggedIn(false);
      }
    );
  }

  signIn(String email, String password) {

    authService.signIn(email, password).then(
      (response) {
        print(response);
        response == true ? setLoggedIn(true) : setLoggedIn(false);
      }
    );

  }

  createAccount(String email, String password) {

    authService.signUp(email, password).then(
      (response) {
        response == true ? setLoggedIn(true) : setLoggedIn(false);
      }
    );
  } 


  var location = {
    "lat" : 0.0,
    "lng" : 0.0
  };
  setCurrentLocation(double lat, double lng) {
    location['lat'] = lat;
    location['lng'] = lng;
    notifyListeners();
  }

  getCurrentLocation() {
    return location;
  }

}





class ApiService {
  Future<Secret> secret = SecretLoader(
    secretPath: "secrets.json"
  ).load();

  

}
final ApiService api = ApiService();







class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;


  Stream<FirebaseUser> user;
  Stream<Map<String, dynamic>> profile;
  FirebaseUser currentUser;
  AuthService() {
    user = _auth.onAuthStateChanged;

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db.collection('users').document(u.uid).snapshots().map(
          (snap) => snap.data
        );
      } else {
        return Stream.value({});
      }
    });
  }


  Future<bool> signUp(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

    FirebaseUser user = result.user;

    currentUser = user;
    updateUserData(user);

    return user != null ? true : false;
  }

  Future<bool> signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password
    );

    FirebaseUser user = result.user;
    currentUser = user;

    updateUserData(user);

    return user != null ? true : false;
  }

  Future<bool> googleSignIn() async {
    _googleSignIn.disconnect();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken, 
      accessToken: googleAuth.accessToken
    );

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    updateUserData(user);
    currentUser = user;

    return user != null ? true : false;
  }

  getUserId() {
    return currentUser.uid;
  }

  getUsername() {
    if (currentUser != null) {
      return currentUser.displayName != null ? currentUser.displayName : currentUser.email;
    }
    
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    
    return ref.setData({
      'username': user.displayName == null ? user.email : user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }
}
final AuthService authService = AuthService();