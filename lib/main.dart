import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyekakhir/pages/auth/getStartedPage.dart';
import 'package:proyekakhir/pages/auth/loginPage.dart';
import 'package:proyekakhir/pages/dashboard/dashboard.dart';
import 'package:proyekakhir/routes/authRoutes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cake Shop',
      theme: ThemeData(useMaterial3: true),
      initialRoute: AuthRoutes.getStarted,
      getPages: [
        GetPage(
          name: AuthRoutes.getStarted,
          page: () => const GetStartedPage(),
        ),
        GetPage(name: AuthRoutes.login, page: () => const LoginPage()),
        GetPage(name: '/dashboard', page: () => const Dashboard()),
      ],
    );
  }
}
