import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseServices {
  // FireStore Operation
  User user = FirebaseAuth.instance.currentUser;

  CollectionReference userReference =
      FirebaseFirestore.instance.collection('Users');

  addUserFromGoogle(AuthCredential credential) {
    return userReference.doc(user.uid).set({
      'credential': credential.providerId,
      'profilePic': user.photoURL.replaceAll("s96", "s400"),
    }).catchError((e) => Fluttertoast.showToast(msg: e.toString()));
  }

  addUserFromFacebook(Map profile, AuthCredential credential) {
    return userReference.doc(user.uid).set({
      'credential': credential.providerId,
      'profilePic': profile["picture"]["data"]["url"],
    }).catchError((e) => Fluttertoast.showToast(msg: e.toString()));
  }
}
