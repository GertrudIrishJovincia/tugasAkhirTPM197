import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';
import 'package:proyekakhir/providers/cardProviders.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  String _paymentMethod = 'Cash';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: AppFont.nunitoSansSemiBold),
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.dark),
      ),
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: Image.network(
                      item['productImage'],
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item['productName'],
                      style: AppFont.nunitoSansSemiBold,
                    ),
                    trailing: Text(
                      formatIDRCurrency(number: item['productPrice'] ?? 0),
                      style: AppFont.nunitoSansBold,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Shipping Address', style: AppFont.nunitoSansBold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter your shipping address',
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Payment Method', style: AppFont.nunitoSansBold),
            ),
            RadioListTile<String>(
              title: const Text('Cash'),
              value: 'Cash',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Credit Card'),
              value: 'Credit Card',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppFont.nunitoSansBold.copyWith(
                    fontSize: 18,
                    color: AppColor.primary,
                  ),
                ),
                Text(
                  formatIDRCurrency(number: cart.totalPrice),
                  style: AppFont.nunitoSansBold.copyWith(
                    fontSize: 18,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PillsButton(
                text: 'Confirm Order',
                fullWidthButton: true,
                fontSize: 18,
                paddingSize: 0,
                onPressed: () {
                  final address = _addressController.text.trim();
                  if (address.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alamat pengiriman wajib diisi'),
                      ),
                    );
                    return;
                  }
                  if (_paymentMethod.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih metode pembayaran')),
                    );
                    return;
                  }

                  // Kosongkan keranjang
                  cart.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order berhasil dikonfirmasi!'),
                    ),
                  );

                  // Navigasi ke halaman home (dashboard) dan hapus semua route sebelumnya
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
