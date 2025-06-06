import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:proyekakhir/pages/auth/getStartedPage.dart';
import 'package:proyekakhir/pages/auth/loginPage.dart';
import 'package:proyekakhir/pages/dashboard/dashboard.dart';
import 'package:proyekakhir/providers/cardProviders.dart';
import 'package:proyekakhir/providers/favoriteProvider.dart';
import 'package:proyekakhir/routes/authRoutes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cek status login
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Menunggu inisialisasi provider dan SharedPreferences selesai
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cake Shop',
      theme: ThemeData(useMaterial3: true),
      // Tentukan initialRoute sesuai status login
      initialRoute: isLoggedIn ? '/dashboard' : AuthRoutes.getStarted,
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
