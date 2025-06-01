import 'package:flutter/material.dart';
import 'package:proyekakhir/components/widgets/infoDivider.dart';
import 'package:proyekakhir/components/widgets/userInfoAvatars.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/pages/dashboard/dashboard.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, String> dummyUser = {
    'email': 'user@example.com',
    'displayName': 'John Doe',
    'uid': '1234567890',
  };

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Jika mau, bisa buat loading dummy pakai Future.delayed lalu tunjukkan loading dulu

    return Scaffold(
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
          'About Me',
          style: AppFont.nunitoSansSemiBold.copyWith(
            fontSize: 14,
            color: AppColor.dark,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoAvatars(email: dummyUser['email']!),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'About Me',
                    style: AppFont.nunitoSansBold.copyWith(
                      color: AppColor.dark,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoDivider(
                      title: 'Name',
                      value:
                          dummyUser['displayName'] ??
                          'Nama tidak ada, harus login terlebih dahulu untuk menampilkan..',
                    ),
                    const SizedBox(height: 24),
                    InfoDivider(
                      title: 'Email',
                      value: dummyUser['email'] ?? 'Tidak ada email',
                    ),
                    // const SizedBox(height: 24),
                    // InfoDivider(
                    //   title: 'Preferenced Id',
                    //   value: dummyUser['uid'] ?? '',
                    // ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        // Dummy logout action
                        debugPrint('Logout tapped');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: AppColor.dark),
                          Text(
                            'Logout',
                            style: AppFont.nunitoSansMedium.copyWith(
                              fontSize: 16,
                              color: AppColor.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
