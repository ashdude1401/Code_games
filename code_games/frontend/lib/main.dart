import 'dart:io';
import 'package:code_games/src/features/creating_rooms/data/repository/group_repository_impl.dart';
import 'package:code_games/src/features/creating_rooms/presentation/stateMangement/group_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import 'firebase_options.dart';
import 'src/config/theme/Theme/theme.dart';
import 'src/features/auth/data/repository/authentication_repository_impl.dart';
import 'src/features/core/presentation/pages/home/home_view/home_view.dart';

// TODO: Define the background message handler

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  )
      //After intialization firebase creating AuthenticationRepositoryImpl instance to handle all the authentication stuff
      .then((value) => Get.put(AuthenticationRepositoryImpl()))
      .then((value) => Get.put(GroupRepositoryImpl()))
      .then((value) => Get.put(GroupController()));

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  // TODO: Request permission

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // TODO: Register with FCM
  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  final token = await FirebaseMessaging.instance.getToken();

  final oldToken = Get.find<AuthenticationRepositoryImpl>().fcmToken.value;
  if (oldToken != token) {
    print("Updating FCM Token");
    await Get.find<AuthenticationRepositoryImpl>().updateFcmToken(token!);
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
    if (kDebugMode) {
      print('Token Refreshed');
    }
    //updating the fcm token in the database
    await Get.find<AuthenticationRepositoryImpl>().updateFcmToken(event);
    //getting the user id from the shared preferences
  });

  if (kDebugMode) {
    print('Registration Token=$token');
  }

  // TODO: Add stream controller
  // used to pass messages from event handler to the UI
  final messageStreamController = BehaviorSubject<RemoteMessage>();

  // TODO: Set up foreground message handler
  // It is used to handle messages when the app is in the foreground state.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    //Show Snackbar

    //updating the fcm token in the database

    messageStreamController.sink.add(message);
  });
  // TODO: Set up background message handler
  // It is used to handle messages when the app is in the background state(minimised) or terminated(not opened ).
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Code Games',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: HomeView(),
      // home: HomeView(),
    );
  }
}

// NoInternt connection widget Page

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Internet Connection"),
      ),
    );
  }
}
