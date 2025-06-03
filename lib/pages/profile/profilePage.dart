import 'package:flutter/material.dart';
import 'package:proyekakhir/components/widgets/infoDivider.dart';
import 'package:proyekakhir/components/widgets/userInfoAvatars.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/pages/auth/loginPage.dart';
import 'package:proyekakhir/pages/dashboard/dashboard.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, String> dummyUser = {
    'email': 'irish@gmail.com',
    'displayName': 'Irish Jovincia',
    'uid': '1234567890',
  };

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
        ),
        title: Text(
          'Profile',
          style: AppFont.nunitoSansSemiBold.copyWith(
            fontSize: 18,
            color: AppColor.dark,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.primary.withOpacity(0.2), AppColor.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: UserInfoAvatars(email: dummyUser['email']!),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            dummyUser['displayName'] ?? 'Nama tidak tersedia',
                            style: AppFont.nunitoSansBold.copyWith(
                              fontSize: 24,
                              color: AppColor.dark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        InfoDivider(
                          title: 'Name',
                          value: dummyUser['displayName'] ?? 'Nama tidak ada',
                        ),
                        const SizedBox(height: 24),
                        InfoDivider(
                          title: 'Email',
                          value: dummyUser['email'] ?? 'Tidak ada email',
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: PillsButton(
                            text: 'Logout',
                            backgroundColor: AppColor.primary,
                            fontSize: 16,
                            paddingSize: 0,
                            fullWidthButton: true,
                            onPressed: () {
                              debugPrint('Logout tapped');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
