// import 'dart:developer';

// import 'package:code_games/src/features/auth/data/repository/exceptions/exceptions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../dashboard/presentation/pages/home.dart';
// import '../../domain/repository/authentication_repository.dart';
// import '../../presentation/pages/welcome/welcome_screen.dart';

// // import 'package:otpless_flutter/otpless_flutter.dart';

// class AuthenticationRepositoryImpl extends GetxController
//     implements AuthenticationRepository {
//   final userName = "Code Geek".obs;
//   final profilePicture =
//       "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
//           .obs;
//   //getter method for this controller , so that we can access this controller from anywhere

//   static AuthenticationRepositoryImpl get instance => Get.find();

//   //Vairables

//   //Creating  a new FirebaseAuth instance that allows you to interact with Firebase Auth using the default Firebase App

//   //we can use this instance to call various methods and utilities for authentication, such as createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut etc .

//   final _auth = FirebaseAuth.instance;

//   //Creating a new GoogleSignIn instance to handle the google sign in
//   final googleSingIn = GoogleSignIn();

//   //Whatsapp login using otpless-----------------------------------------------------------

// //creating a new instance of Otpless class
//   // final _otplessFlutterPlugin = Otpless();

//   //Creating a obervable User (class from the firebase_auth package that represents a user account in Firebase Auth.)
//   late final Rx<User?> firebaseUser;

//   _setInitialScreen(User? user) {
//     //---------------------Changed the initial screen based for testing it should be changed to WelcomeView() later
//     user == null
//         ? Get.offAll(() => const WelcomeView())
//         : Get.offAll(() => const HomeView());
//   }

//   //overriding the onReady method to initialize the firebaseUser and listen to the authStateChanges
//   @override
//   void onReady() {
//     super.onReady();

//     //initializing the firebaseUser with the current user
//     firebaseUser = Rx<User?>(_auth.currentUser);

//     //listening to the authStateChanges and updating the firebaseUser

//     //.bindStream() method is used to bind a stream to a Rx variable.

//     //this method automatically listen to the stream (here provided by authStateChange method) and update the firebaseUser value  whenever the stream emits a new value whenever the user sign in(new user) or sign out (null)

//     firebaseUser.bindStream(_auth.authStateChanges());

//     //ever method is used to listen to the changes in the firebaseUser and call the _setInitialScreen method whenever the firebaseUser changes
//     ever(firebaseUser, _setInitialScreen);
//   }

//   @override
//   Future<void> createUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);

//       firebaseUser.value != null
//           ? Get.offAll(() => const HomeView())
//           : Get.offAll(() => const WelcomeView());

//       //this create a new user with the provided email and password and automatically sign in the user and update the firebaseUser value
//     } on FirebaseAuthException catch (e) {
//       final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
//       log("FIREBASE AUTH EXCEPTION ${ex.message}");
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   @override
//   Future<void> loginWithTheEmailAndPassword(
//       String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);

//       //this sign in the user with the provided email and password and automatically sign in the user and update the firebaseUser value
//     } on FirebaseAuthException catch (e) {
//       final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
//       log("FIREBASE AUTH EXCEPTION ${ex.message}");
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   Future<void> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow (pop up to select google account) and returns google sign in account object having details about the user
//       final GoogleSignInAccount? googleSingInAccount =
//           await googleSingIn.signIn();

//       if (googleSingInAccount != null) {
//         print(
//             "======================GOOGLE SIGN IN ACCOUNT ${googleSingInAccount.email}========");
//         // Obtain the auth details from the request (accessToken and idToken are required to authenticate with firebase)
//         final GoogleSignInAuthentication googleAuth =
//             await googleSingInAccount.authentication;

//         // Create a new credential (used to authenticate with firebase)
//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );

//         try {
//           // Once signed in, return the UserCredential (contains user details)
//           final userCredential = await _auth.signInWithCredential(credential);
//           //update the firebaseUser value with the current user
//           firebaseUser.value = userCredential.user;

//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           //set the user_name and profile_picture in the shared preferences
//           prefs.setString(
//               'user_name', googleSingInAccount.displayName ?? "Code Geek");

//           prefs.setString(
//               'profile_picture',
//               googleSingInAccount.photoUrl ??
//                   "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png");

//             //for testing purpose
//           print(
//               "User Name From Shared Preferences ${prefs.getString('user_name')}");

//           print(
//               "Profile Picture From Shared Preferences ${prefs.getString('profile_picture')}");

//           //update the user_name and profile_picture observable
//           userName.value = prefs.getString('user_name') ?? "Code Geek";
//           profilePicture.value = prefs.getString('profile_picture') ??
//               "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png";

//           //for testing purpose
//           print("User Name From Variable ${userName.value}");
//           print("Profile Picture From Variable ${profilePicture.value}");
//         } on FirebaseAuthException catch (e) {
//           final ex = GoogleSignInFailure.code(e.code);
//           log("FIREBASE AUTH EXCEPTION ${ex.message}");
//         } catch (e) {
//           log(e.toString());
//         }
//       } else {}
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   @override
//   Future<void> logout() async {
//     await _auth.signOut();
//     //this sign out the user and update the firebaseUser value to null

//     //Sign out from google account
//     await googleSingIn.signOut();

//     //remove the user_name and profile_picture from the shared preferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('user_name');
//     prefs.remove('profile_picture');
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_games/src/features/auth/data/models/user_modal.dart';
import 'package:code_games/src/features/auth/data/repository/exceptions/exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../creating_rooms/data/repository/exception/firestore_expception.dart';
import '../../../core/presentation/pages/home/home_view/home_view.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../presentation/pages/welcome/welcome_screen.dart';

class AuthenticationRepositoryImpl extends GetxController
    implements AuthenticationRepository {
  static AuthenticationRepositoryImpl get instance => Get.find();

  // Constants for default user data
  static const String defaultUserName = "Code Geek";
  static const String defaultProfilePicture =
      "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png";

  final Rx<String> userName = defaultUserName.obs;
  final Rx<String> profilePicture = defaultProfilePicture.obs;
  final Rx<String> email = ''.obs;
  final Rx<String> bio = ''.obs;
  
  Rx<UserEntity> currentUser = UserEntity(
      userID: '',
      email: '',
      password: '',
      fullName: '',
      profilePicture: '',
      bio: '',
      registrationDate: DateTime.timestamp(),
      lastLoginDate: DateTime.timestamp(),
      groups: []).obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final storage = FirebaseStorage.instance;

  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const WelcomeView());
    } else {
      // Fetch user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final storedUserName = prefs.getString('display_name') ?? defaultUserName;
      final storedProfilePicture =
          prefs.getString('photo_url') ?? defaultProfilePicture;
      final storedEmail = prefs.getString('email') ?? '';

      // Update observables
      userName.value = storedUserName == defaultUserName
          ? user.displayName ?? defaultUserName
          : storedUserName;
      profilePicture.value = storedProfilePicture == defaultProfilePicture
          ? user.photoURL ?? defaultProfilePicture
          : storedProfilePicture;
      email.value = storedEmail == '' ? user.email! : storedEmail;

      try {
        // Update current user data
        final doc = await firestore.collection('users').doc(user.uid).get();

        if (doc.data() != null) {
          final userData = doc.data() as Map<String, dynamic>;
          currentUser.value = UserEntity.fromMap(userData);
        } else {
          log('No user found while fetching user data from firestore to update current user data');
          // Get.snackbar('error', 'No user Found');
          // logout();
        }

        Get.offAll(() => HomeView());
      } on FirebaseException catch (e) {
        FirestoreDbFailure.code(e.code);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _navigateAfterAuthentication();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> loginWithTheEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _navigateAfterAuthentication();
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (kDebugMode) {
        print(
            "=============google account fetch succesfullty :${googleSignInAccount?.email}=====================");
      }
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        if (kDebugMode) {
          print(
              "=============google account credential succesfully :${googleAuth.accessToken}=====================");
        }
        try {
          final userCredential = await _auth.signInWithCredential(credential);

          firebaseUser.value = userCredential.user;

          linkAuthAndUserData(userCredential);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('display_name',
              firebaseUser.value!.displayName ?? defaultUserName);
          prefs.setString('photo_url',
              firebaseUser.value!.photoURL ?? defaultProfilePicture);
          prefs.setString('email', firebaseUser.value!.email!);

          _updateUserDataFromSharedPreferences(prefs);

          //After creating all the value navigate to the home screen
          Get.snackbar('Success', 'Successfully authenticated',
              snackPosition: SnackPosition.BOTTOM);
        } on FirebaseAuthException catch (e) {
          _handleAuthException(e);
        } catch (e) {
          log(e.toString());
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await googleSignIn.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('display_name');
    prefs.remove('photo_url');
    prefs.remove('email');

    _clearUserData();
  }

  void _handleAuthException(FirebaseAuthException e) {
    final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
    log("FIREBASE AUTH EXCEPTION ${ex.message}");
    // Handle the exception, show error to the user, etc.
  }

  void _navigateAfterAuthentication() {
    firebaseUser.value != null
        ? {
            currentUser.value = UserEntity(
              userID: firebaseUser.value!.uid,
              email: firebaseUser.value!.email!,
              password: '',
              fullName: firebaseUser.value!.displayName ?? defaultUserName,
              profilePicture:
                  firebaseUser.value!.photoURL ?? defaultProfilePicture,
              bio: firebaseUser.value!.displayName ?? '',
              registrationDate: DateTime.timestamp(),
              lastLoginDate: DateTime.timestamp(),
              groups: [],
            ),
            Get.offAll(() => HomeView())
          }
        : Get.offAll(() => const WelcomeView());
  }

  void _updateUserDataFromSharedPreferences(SharedPreferences prefs) {
    userName.value = prefs.getString('display_name') ?? defaultUserName;
    profilePicture.value =
        prefs.getString('photo_url') ?? defaultProfilePicture;
  }

  void _clearUserData() {
    userName.value = defaultUserName;
    profilePicture.value = defaultProfilePicture;
  }

// Link authentication and user data
  Future<void> linkAuthAndUserData(
    UserCredential credential,
  ) async {
    final User? user = credential.user;
    final String uid = user!.uid;
    final String email = user.email!;

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        // User does not exist,updating the current user value with the new user data
        currentUser.value = UserEntity(
            userID: uid,
            email: email,
            password: '',
            fullName: user.displayName ?? defaultUserName,
            profilePicture: user.photoURL ?? defaultProfilePicture,
            bio: '',
            registrationDate: DateTime.timestamp(),
            lastLoginDate: DateTime.timestamp(),
            groups: []);
        // create a new document to store new the user data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(currentUser.value.toMap());
      } else {
        // User already exists, retrieve their data from Firestore
        final DocumentSnapshot doc = snapshot.docs.first;
        final Map<String, dynamic> userData =
            doc.data() as Map<String, dynamic>;

        //updating the current user value with the already existing user data
        currentUser.value = UserEntity.fromMap(userData);

        // Use the retrieved data in your app
        if (kDebugMode) {
          print('User email: ${userData['email']}');
        }
      }
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
    } catch (e) {
      log(e.toString());
    }
    // Check if the user already exists in Firestore
  }

  //Update the curent user details in the firestore
  Future<void> updateUserDetails(String name, String bio, XFile? img) async {
    // Upload the image to Firebase Storage and get the download URL
    String profilePicture = currentUser.value.profilePicture;

    if (img != null) {
      try {
        final ref =
            storage.ref().child('profile_pictures/${currentUser.value.userID}');
        await ref.putFile(File(img.path));
        profilePicture = await ref.getDownloadURL();
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload profile picture',
            snackPosition: SnackPosition.BOTTOM);
        log(e.toString());
      }
    }
    final updatedUser = UserEntity(
        userID: currentUser.value.userID,
        email: currentUser.value.email,
        password: currentUser.value.password,
        fullName: name,
        profilePicture: profilePicture,
        bio: bio,
        registrationDate: currentUser.value.registrationDate,
        lastLoginDate: currentUser.value.lastLoginDate,
        groups: currentUser.value.groups);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.value.userID)
          .update(updatedUser.toMap());
      currentUser.value = updatedUser;
      //Also update the firebase user
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(currentUser.value.fullName);
      await FirebaseAuth.instance.currentUser!
          .updatePhotoURL(currentUser.value.profilePicture);

      //updating local storage values too

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'display_name', firebaseUser.value!.displayName ?? defaultUserName);
      prefs.setString(
          'photo_url', firebaseUser.value!.photoURL ?? defaultProfilePicture);
      prefs.setString('email', firebaseUser.value!.email!);
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
    } catch (e) {
      Get.snackbar('Error', 'User detail cannot be updated');
      log(e.toString());
    }
  }

  //Update the curent user group details in the firestore

  //add group to the user groups
  Future<void> addGroupToUserGroups(
      List<String> groupId, UserEntity user) async {
    try {
      //update the user group list of the user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.value.userID)
          .update({'groups': FieldValue.arrayUnion(groupId)});
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
    } catch (e) {
      log(e.toString());
    }
  }

  //remove group from the user groups
  Future<void> removeGroupFromUserGroup(String groupName) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.value.userID)
          .update({
        'groups': FieldValue.arrayRemove([groupName])
      });
      currentUser.value.groups.remove(groupName);
    } on FirebaseException catch (e) {
      FirestoreDbFailure.code(e.code);
    } catch (e) {
      log(e.toString());
    }
  }
}
