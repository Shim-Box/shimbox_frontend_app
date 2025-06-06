// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDZin6t-Alxjc9GHoEcHZrwQzlAHtxLhtY',
    appId: '1:337576916905:web:11f8ee9a57c2826a0ab6b8',
    messagingSenderId: '337576916905',
    projectId: 'shimbox',
    authDomain: 'shimbox.firebaseapp.com',
    storageBucket: 'shimbox.firebasestorage.app',
    measurementId: 'G-PLHT8M155W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABqSVMnRty7USR-XkC5kRXbqzS4Op5-IQ',
    appId: '1:337576916905:android:b70fcd25c23e4ac60ab6b8',
    messagingSenderId: '337576916905',
    projectId: 'shimbox',
    storageBucket: 'shimbox.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1bd_rwWFnJs-irbLnCT4p3RecKi--4ZU',
    appId: '1:337576916905:ios:f3f941d9b46551ef0ab6b8',
    messagingSenderId: '337576916905',
    projectId: 'shimbox',
    storageBucket: 'shimbox.firebasestorage.app',
    androidClientId: '337576916905-5sqbpq34q9vhk914dgueu02pf3aegdrr.apps.googleusercontent.com',
    iosBundleId: 'com.example.shimboxApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC1bd_rwWFnJs-irbLnCT4p3RecKi--4ZU',
    appId: '1:337576916905:ios:f3f941d9b46551ef0ab6b8',
    messagingSenderId: '337576916905',
    projectId: 'shimbox',
    storageBucket: 'shimbox.firebasestorage.app',
    androidClientId: '337576916905-5sqbpq34q9vhk914dgueu02pf3aegdrr.apps.googleusercontent.com',
    iosBundleId: 'com.example.shimboxApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDZin6t-Alxjc9GHoEcHZrwQzlAHtxLhtY',
    appId: '1:337576916905:web:a110763beeb9f9de0ab6b8',
    messagingSenderId: '337576916905',
    projectId: 'shimbox',
    authDomain: 'shimbox.firebaseapp.com',
    storageBucket: 'shimbox.firebasestorage.app',
    measurementId: 'G-21Y0GNE3G6',
  );
}
