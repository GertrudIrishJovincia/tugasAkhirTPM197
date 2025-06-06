import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:proyekakhir/pages/product/orderDetailPage.dart'; // Import halaman detail

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  // Mengambil riwayat pesanan dari SharedPreferences
  Future<List<Map<String, String>>> fetchOrderHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orderHistoryData = prefs.getStringList('orderHistory') ?? [];

    // Mengonversi data JSON menjadi list Map
    return orderHistoryData.map((orderJson) {
      final order = Map<String, String>.from(json.decode(orderJson));
      return order;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Pesanan',
          style: AppFont.nunitoSansBold.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future:
            fetchOrderHistory(), // Memanggil fungsi untuk mengambil riwayat pesanan
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Loading state
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Belum ada riwayat pesanan',
                style: AppFont.nunitoSansRegular.copyWith(fontSize: 16),
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final order = orders[index];
              Color statusColor;

              // Menentukan warna berdasarkan status pesanan
              switch (order['status']) {
                case 'Selesai':
                  statusColor = Colors.green;
                  break;
                case 'Dalam Proses':
                  statusColor = Colors.orange;
                  break;
                case 'Dibatalkan':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.grey;
              }

              return GestureDetector(
                // Menambahkan GestureDetector agar bisa di-tap
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailPage(
                        order: order,
                      ), // Navigasi ke detail pesanan
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nomor Pesanan: ${order["orderId"]}',
                          style: AppFont.nunitoSansSemiBold.copyWith(
                            fontSize: 16,
                            color: AppColor.dark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tanggal: ${order["date"]}',
                          style: AppFont.nunitoSansRegular.copyWith(
                            fontSize: 14,
                            color: AppColor.gray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ${order["status"]}',
                              style: AppFont.nunitoSansSemiBold.copyWith(
                                fontSize: 14,
                                color: statusColor,
                              ),
                            ),
                            Text(
                              order["total"] ?? '',
                              style: AppFont.nunitoSansBold.copyWith(
                                fontSize: 16,
                                color: AppColor.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
