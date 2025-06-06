import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';

class Profilekesan extends StatelessWidget {
  const Profilekesan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Diri dan Kesan',
          style: AppFont.nunitoSansBold.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan foto profil
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                  'assets/images/irishhh.jpg',
                ), // Ganti dengan path foto Anda
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nama: Gertrud Irish Jovincia', // Ganti dengan nama Anda
              style: AppFont.nunitoSansSemiBold.copyWith(
                fontSize: 18,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'NIM: 123220197', // Ganti dengan NIM Anda
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 14,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Kesan Mata Kuliah:',
              style: AppFont.nunitoSansSemiBold.copyWith(
                fontSize: 16,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mata kuliah ini sangat menarik dan membuka wawasan saya lebih dalam tentang aplikasi mobile. Sangat asik, namun kadang tugasnya banyak membuat saya agak kewalahan. Tetapi saya berusaha semaksimal mungkin dalam mengerjakan tugasnya, saya berharap mendapat nilai akhir A dalam matkul ini.',
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 14,
                color: AppColor.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
