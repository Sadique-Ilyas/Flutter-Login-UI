import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_login_fb_google/Services/Firebase%20Services.dart';
import 'package:flutter_login_fb_google/ui/Home%20Page.dart';
import 'package:flutter_login_fb_google/ui/Login%20Page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  handleAuth() {
    return StreamBuilder(
        stream: firebaseAuth.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        });
  }

  // Facebook Authentication
  FacebookLogin facebookLogin = FacebookLogin();

  loginWithFb() async {
    FacebookLoginResult result = await facebookLogin
        .logIn(['email']).catchError((e) => Fluttertoast.showToast(
            msg: "Facebook Login Exception :${e.toString()}"));
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled By User");
        break;
      case FacebookLoginStatus.error:
        Fluttertoast.showToast(msg: FacebookLoginStatus.error.toString());
        break;
      case FacebookLoginStatus.loggedIn:
        await loginWithFacebook(result);
        break;
    }
  }

  loginWithFacebook(FacebookLoginResult result) async {
    FacebookAccessToken accessToken = result.accessToken;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(400).height(400),email&access_token=${accessToken.token}');
    final profile = JSON.jsonDecode(graphResponse.body);
    // user = profile;  user["picture"]["data"]["url"]
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      if (userCredential != null) {
        FirebaseServices().addUserFromFacebook(profile, credential);
        Fluttertoast.showToast(msg: "Signed In Using Facebook !");
      }
    } on FirebaseAuthException catch (err) {
      Fluttertoast.showToast(msg: err.message);
    } catch (err) {
      Fluttertoast.showToast(msg: err.message);
    }
  }

  signOutFromFacebook() async {
    await firebaseAuth.signOut().then((value) {
      facebookLogin
          .logOut()
          .then((value) =>
              Fluttertoast.showToast(msg: "Signed Out From Facebook !"))
          .catchError((e) => Fluttertoast.showToast(msg: e.toString()));
    }).catchError((e) => Fluttertoast.showToast(msg: e.toString()));
  }

  // Google Authentication
  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn()
        .signIn()
        .catchError((e) => Fluttertoast.showToast(
            msg: "Google Login Exception: ${e.toString()}"));

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential != null) {
        FirebaseServices().addUserFromGoogle(credential);
        Fluttertoast.showToast(msg: "Signed In Using Google !");
      }
    } on FirebaseAuthException catch (err) {
      Fluttertoast.showToast(msg: err.message);
    } catch (err) {}
  }

  // Sign Out
  signOutFromGoogle() async {
    await FirebaseAuth.instance.signOut().then((value) {
      GoogleSignIn().disconnect().then(
          (value) => Fluttertoast.showToast(msg: "Signed Out From Google !"));
    }).catchError((e) => Fluttertoast.showToast(msg: e.toString()));
  }
}
