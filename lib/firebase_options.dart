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
        return macos;
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
    apiKey: 'AIzaSyC4Y2KB5am9ZwF4XD-QTqIvhWwjy6IUjtc',
    appId: '1:541906143779:web:b743bd84a198d31fa7bf96',
    messagingSenderId: '541906143779',
    projectId: 'carpool-project-111',
    authDomain: 'carpool-project-111.firebaseapp.com',
    databaseURL: 'https://carpool-project-111-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carpool-project-111.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeVJhJRVx3oEWBWL1OeW82co9UHhB0xKA',
    appId: '1:541906143779:android:10be55aca8f01ebda7bf96',
    messagingSenderId: '541906143779',
    projectId: 'carpool-project-111',
    databaseURL: 'https://carpool-project-111-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carpool-project-111.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHlPT8OtJ0aFV5nWGrWxlOP7_qxzEfGK8',
    appId: '1:541906143779:ios:9a79218a1517e2e0a7bf96',
    messagingSenderId: '541906143779',
    projectId: 'carpool-project-111',
    databaseURL: 'https://carpool-project-111-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carpool-project-111.appspot.com',
    iosBundleId: 'com.example.carpoolDriver',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBHlPT8OtJ0aFV5nWGrWxlOP7_qxzEfGK8',
    appId: '1:541906143779:ios:8da4aa9d1f8bb986a7bf96',
    messagingSenderId: '541906143779',
    projectId: 'carpool-project-111',
    databaseURL: 'https://carpool-project-111-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'carpool-project-111.appspot.com',
    iosBundleId: 'com.example.carpoolDriver.RunnerTests',
  );
}
