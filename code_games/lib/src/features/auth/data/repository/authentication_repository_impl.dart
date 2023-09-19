import 'dart:developer';

import 'package:code_games/src/features/auth/data/repository/exceptions/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/repository/authentication_repository.dart';
import '../../presentation/pages/welcome/welcome_screen.dart';

// import 'package:otpless_flutter/otpless_flutter.dart';



class AuthenticationRepositoryImpl extends GetxController
    implements AuthenticationRepository {
  //getter method for this controller , so that we can access this controller from anywhere

  static AuthenticationRepositoryImpl get instance => Get.find();

  //Vairables

  //Creating  a new FirebaseAuth instance that allows you to interact with Firebase Auth using the default Firebase App

  //we can use this instance to call various methods and utilities for authentication, such as createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut etc .

  final _auth = FirebaseAuth.instance;

  //Creating a new GoogleSignIn instance to handle the google sign in
  final googleSingIn = GoogleSignIn();

  //Whatsapp login using otpless-----------------------------------------------------------

//creating a new instance of Otpless class
  // final _otplessFlutterPlugin = Otpless();

  //Creating a obervable User (class from the firebase_auth package that represents a user account in Firebase Auth.)
  late final Rx<User?> firebaseUser;

  _setInitialScreen(User? user) {
    //---------------------Changed the initial screen based for testing it should be changed to WelcomeView() later
    user == null
        ? Get.offAll(() => const WelcomeView())
        : Get.offAll(() => HomeView());
  }

  //overriding the onReady method to initialize the firebaseUser and listen to the authStateChanges
  @override
  void onReady() {
    super.onReady();

    //initializing the firebaseUser with the current user
    firebaseUser = Rx<User?>(_auth.currentUser);

    //listening to the authStateChanges and updating the firebaseUser

    //.bindStream() method is used to bind a stream to a Rx variable.

    //this method automatically listen to the stream (here provided by authStateChange method) and update the firebaseUser value  whenever the stream emits a new value whenever the user sign in(new user) or sign out (null)

    firebaseUser.bindStream(_auth.authStateChanges());

    //ever method is used to listen to the changes in the firebaseUser and call the _setInitialScreen method whenever the firebaseUser changes
    ever(firebaseUser, _setInitialScreen);
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      firebaseUser.value != null
          ? Get.offAll(() => HomeView())
          : Get.offAll(() => const WelcomeView());

      //this create a new user with the provided email and password and automatically sign in the user and update the firebaseUser value
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      log("FIREBASE AUTH EXCEPTION ${ex.message}");
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> loginWithTheEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      //this sign in the user with the provided email and password and automatically sign in the user and update the firebaseUser value
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      log("FIREBASE AUTH EXCEPTION ${ex.message}");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow (pop up to select google account) and returns google sign in account object having details about the user
      final GoogleSignInAccount? googleSingInAccount =
          await googleSingIn.signIn();

      if (googleSingInAccount != null) {
        print(
            "======================GOOGLE SIGN IN ACCOUNT ${googleSingInAccount.email}========");
        // Obtain the auth details from the request (accessToken and idToken are required to authenticate with firebase)
        final GoogleSignInAuthentication googleAuth =
            await googleSingInAccount.authentication;

        // Create a new credential (used to authenticate with firebase)
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        try {
          // Once signed in, return the UserCredential (contains user details)
          final userCredential = await _auth.signInWithCredential(credential);
          //update the firebaseUser value with the current user
          firebaseUser.value = userCredential.user;
        } on FirebaseAuthException catch (e) {
          final ex = GoogleSignInFailure.code(e.code);
          log("FIREBASE AUTH EXCEPTION ${ex.message}");
        } catch (e) {
          log(e.toString());
        }
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    //this sign out the user and update the firebaseUser value to null

    //Sign out from google account
    await googleSingIn.signOut();
  }

//   Future<void> startOtpless() async {

//     _otplessFlutterPlugin.start((result) {
//       var message = "";
//       if (result['data'] != null) {
// // todo send this token to your backend service to validate otplessUser details received in the callback with OTPless backend service
//         final token = result['data']['token'];
//       }
//     });
//   }
}

class HomeView {
}
