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
    apiKey: 'AIzaSyCVhA2kk74KjYDRcqFa1ctPK1FUJrq3fdA',
    appId: '1:788618001984:web:a5a04b0df5956243bc29a5',
    messagingSenderId: '788618001984',
    projectId: 'bookingdoctor-aa6af',
    authDomain: 'bookingdoctor-aa6af.firebaseapp.com',
    databaseURL: 'https://bookingdoctor-aa6af-default-rtdb.firebaseio.com',
    storageBucket: 'bookingdoctor-aa6af.firebasestorage.app',
    measurementId: 'G-YMFY4MXKVC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_-Zg20bP9Ry57WA6Emmeurzlv9c2O-BA',
    appId: '1:788618001984:android:660960f1b180d495bc29a5',
    messagingSenderId: '788618001984',
    projectId: 'bookingdoctor-aa6af',
    databaseURL: 'https://bookingdoctor-aa6af-default-rtdb.firebaseio.com',
    storageBucket: 'bookingdoctor-aa6af.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAl3bFk2jARim7IKh7z0Gg7x_GHUOJ_bOc',
    appId: '1:788618001984:ios:4c6653a7f95d5ff4bc29a5',
    messagingSenderId: '788618001984',
    projectId: 'bookingdoctor-aa6af',
    databaseURL: 'https://bookingdoctor-aa6af-default-rtdb.firebaseio.com',
    storageBucket: 'bookingdoctor-aa6af.firebasestorage.app',
    androidClientId: '788618001984-76s9s0hqe6i6s14t5t8gcomj9ra8g7tj.apps.googleusercontent.com',
    iosClientId: '788618001984-ge850brvkotv0olhd4qe57v5roeckl9t.apps.googleusercontent.com',
    iosBundleId: 'com.example.bookingDoctor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAl3bFk2jARim7IKh7z0Gg7x_GHUOJ_bOc',
    appId: '1:788618001984:ios:4c6653a7f95d5ff4bc29a5',
    messagingSenderId: '788618001984',
    projectId: 'bookingdoctor-aa6af',
    databaseURL: 'https://bookingdoctor-aa6af-default-rtdb.firebaseio.com',
    storageBucket: 'bookingdoctor-aa6af.firebasestorage.app',
    androidClientId: '788618001984-76s9s0hqe6i6s14t5t8gcomj9ra8g7tj.apps.googleusercontent.com',
    iosClientId: '788618001984-ge850brvkotv0olhd4qe57v5roeckl9t.apps.googleusercontent.com',
    iosBundleId: 'com.example.bookingDoctor',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCVhA2kk74KjYDRcqFa1ctPK1FUJrq3fdA',
    appId: '1:788618001984:web:35d02e40b9b54b5dbc29a5',
    messagingSenderId: '788618001984',
    projectId: 'bookingdoctor-aa6af',
    authDomain: 'bookingdoctor-aa6af.firebaseapp.com',
    databaseURL: 'https://bookingdoctor-aa6af-default-rtdb.firebaseio.com',
    storageBucket: 'bookingdoctor-aa6af.firebasestorage.app',
    measurementId: 'G-YV5H9DGTF0',
  );
}
