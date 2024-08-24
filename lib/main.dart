import 'package:consultation_app/firebase_options.dart';
import 'package:consultation_app/view_models/admin_view_model.dart';
import 'package:consultation_app/view_models/auth_view_model.dart';
import 'package:consultation_app/view_models/category_view_model.dart';
import 'package:consultation_app/view_models/chat_view_model.dart';
import 'package:consultation_app/view_models/client_view_model.dart';
import 'package:consultation_app/view_models/consultation_view_model.dart';
import 'package:consultation_app/view_models/employee_view_model.dart';
import 'package:consultation_app/view_models/rating_view_model.dart';
import 'package:consultation_app/views/initial_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => CategoryViewModel()),
        ChangeNotifierProvider(create: (context) => ChatViewModel()),
        ChangeNotifierProvider(create: (context) => ClientViewModel()),
        ChangeNotifierProvider(create: (context) => ConsultationViewModel()),
        ChangeNotifierProvider(create: (context) => EmployeeViewModel()),
        ChangeNotifierProvider(create: (context) => AdminViewModel()),
        ChangeNotifierProvider(create: (context) => RatingViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InitialScreen(),
      ),
    );
  }
}
