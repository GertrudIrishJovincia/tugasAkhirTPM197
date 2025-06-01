import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/components/customWidgets/input.dart';
import 'package:proyekakhir/pages/auth/loginPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      debugPrint("Email: ${emailController.text}");
      // Dummy action: nanti bisa sambung ke backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email reset password terkirim')),
      );
    } else {
      debugPrint("Form tidak valid");
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
                  'Lupa Password',
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
                      const SizedBox(height: 25),
                      PillsButton(
                        text: 'Kirim Email',
                        fontSize: 16,
                        paddingSize: 80,
                        onPressed: () => _submit(context),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sudah ingat?',
                                style: AppFont.nunitoSansRegular.copyWith(
                                  color: AppColor.dark,
                                ),
                              ),
                              TextSpan(
                                text: ' Kembali ',
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
