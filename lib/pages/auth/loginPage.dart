import 'package:flutter/material.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/components/customWidgets/input.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/pages/auth/forgotPasswordPage.dart';
import 'package:proyekakhir/pages/auth/registerPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'assets/images/brand_logo.png',
                  width: 250,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                Text(
                  'Silahkan masuk melalui akun',
                  style: AppFont.nunitoSansBold.copyWith(
                    fontSize: 20,
                    color: AppColor.dark,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Input(
                        labelText: 'Email',
                        hintText: 'Masukkan email',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Input(
                        labelText: 'Password',
                        hintText: 'Masukkan password',
                        controller: passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password wajib diisi';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          GestureDetector(
                            child: const Text('Lupa Password?'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      PillsButton(
                        text: 'Masuk',
                        fontSize: 16,
                        paddingSize: 80,
                        onPressed: () => _submit(context),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Belum punya akun?',
                                style: AppFont.nunitoSansRegular.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                              TextSpan(
                                text: ' Mendaftar ',
                                style: AppFont.nunitoSansRegular.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                              TextSpan(
                                text: 'Sekarang',
                                style: AppFont.nunitoSansRegular.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
