import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart'; // Pastikan untuk mengimpor helper untuk format mata uang

class OrderDetailPage extends StatelessWidget {
  final Map<String, String> order;

  const OrderDetailPage({super.key, required this.order});

  // Mengambil data produk dari SharedPreferences
  Future<List<Map<String, String>>> fetchOrderItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orderItemsData = prefs.getStringList('orderItems') ?? [];

    // Mengonversi data JSON menjadi list Map
    return orderItemsData.map((orderJson) {
      final item = Map<String, String>.from(json.decode(orderJson));
      return item;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Pesanan',
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
            Text(
              'Status: ${order["status"]}',
              style: AppFont.nunitoSansSemiBold.copyWith(
                fontSize: 14,
                color: order['status'] == 'Selesai'
                    ? Colors.green
                    : order['status'] == 'Dalam Proses'
                    ? Colors.orange
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              // Memformat total harga dengan format mata uang yang sesuai
              'Total: ${formatIDRCurrency(number: double.tryParse(order["total"] ?? '0') ?? 0.0)}',
              style: AppFont.nunitoSansBold.copyWith(
                fontSize: 16,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Menampilkan produk dalam pesanan
            FutureBuilder<List<Map<String, String>>>(
              future: fetchOrderItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                final orderItems = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      final item = orderItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Image.network(
                                item['productImage'] ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['productName'] ?? 'Unknown Product',
                                      style: AppFont.nunitoSansSemiBold,
                                    ),
                                    const SizedBox(height: 4),
                                    // Menggunakan double pada parameter formatIDRCurrency
                                    Text(
                                      formatIDRCurrency(
                                        number:
                                            double.tryParse(
                                              item['productPrice'] ?? '0',
                                            ) ??
                                            0.0,
                                      ),
                                      style: AppFont.nunitoSansRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
