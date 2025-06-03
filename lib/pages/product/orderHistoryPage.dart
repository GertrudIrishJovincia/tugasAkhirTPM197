import 'package:flutter/material.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  // Contoh data pesanan dummy
  final List<Map<String, String>> orders = const [
    {
      "orderId": "INV-001",
      "date": "2025-05-01",
      "status": "Selesai",
      "total": "Rp 120.000",
    },
    {
      "orderId": "INV-002",
      "date": "2025-05-05",
      "status": "Dalam Proses",
      "total": "Rp 80.000",
    },
    {
      "orderId": "INV-003",
      "date": "2025-05-10",
      "status": "Dibatalkan",
      "total": "Rp 50.000",
    },
  ];

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
      body: orders.isEmpty
          ? Center(
              child: Text(
                'Belum ada riwayat pesanan',
                style: AppFont.nunitoSansRegular.copyWith(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final order = orders[index];
                Color statusColor;
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

                return Card(
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
                );
              },
            ),
    );
  }
}
