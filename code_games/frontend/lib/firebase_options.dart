// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAT4cSRfj0wnJ3qgBMplDVHhrh3z5SmRUg',
    appId: '1:446890860022:web:1ce864db1a0b558fa7bbd7',
    messagingSenderId: '446890860022',
    projectId: 'codegames-ae810',
    authDomain: 'codegames-ae810.firebaseapp.com',
    storageBucket: 'codegames-ae810.appspot.com',
    measurementId: 'G-QY264NVPSK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAOY8OudEjBucn2I6MMFwIwSqTn9xzv6o',
    appId: '1:446890860022:android:cc0a5ee2e36dba82a7bbd7',
    messagingSenderId: '446890860022',
    projectId: 'codegames-ae810',
    storageBucket: 'codegames-ae810.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC34mTPX8VoR21zE0nSz3MqwdVEjlS2vSQ',
    appId: '1:446890860022:ios:1c1a6c35ac53165da7bbd7',
    messagingSenderId: '446890860022',
    projectId: 'codegames-ae810',
    storageBucket: 'codegames-ae810.appspot.com',
    androidClientId: '446890860022-hoa7oc2f0cn6vh96ned8n3v2n2q466ci.apps.googleusercontent.com',
    iosClientId: '446890860022-854lduaseqmgavs184uap8f67293219n.apps.googleusercontent.com',
    iosBundleId: 'com.example.codeGames',
  );
}
