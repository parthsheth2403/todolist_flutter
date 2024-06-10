import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/screens/home_screen.dart';
import 'package:todo_list/screens/login_screen.dart';
import 'package:todo_list/screens/register_screen.dart';
import 'package:todo_list/services/auth_service.dart';
import 'package:todo_list/services/firestore_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBM06RBZDtIvUEggBVhBM3BbF8OpG-YD5w',
        appId: 'com.parthsheth.todolistapp',
        messagingSenderId: '160659762574',
        projectId: 'todo-list-57800',
        storageBucket: 'todo-list-57800.appspot.com',
      )
  );

  Locale deviceLocale = WidgetsBinding.instance.window.locale;
  FirebaseAuth.instance.setLanguageCode(deviceLocale.languageCode);


  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        // Add other supported locales here
      ],
    );
  }
}


