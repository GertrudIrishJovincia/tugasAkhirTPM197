import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart'; // Pastikan ini diimport
import 'package:proyekakhir/providers/cardProviders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  String _paymentMethod = 'Dana'; // Default payment method
  String? selectedSize;
  String? cakeWording;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Memuat data ukuran dan teks kustom dari SharedPreferences
  Future<void> loadSizeAndWording() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedSize = prefs.getString('selected_size');
      cakeWording = prefs.getString('cake_wording');
    });
  }

  @override
  void initState() {
    super.initState();
    loadSizeAndWording(); // Memuat data ukuran dan teks kustom
  }

  // Menyimpan pesanan ke SharedPreferences
  Future<void> _saveOrderToPreferences(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();

    // Mengonversi item keranjang menjadi string JSON
    List<String> productsJson = items.map((item) {
      return '{"id": "${item['id']}", "productName": "${item['productName']}", "productPrice": ${item['productPrice']}, "productImage": "${item['productImage']}"}';
    }).toList();

    // Menyimpan data pesanan
    await prefs.setStringList('orderItems', productsJson);
    await prefs.setString('shippingAddress', _addressController.text);
    await prefs.setString('paymentMethod', _paymentMethod);

    // Mendapatkan total harga dan konversi ke int
    final cart = Provider.of<CartProvider>(context, listen: false);
    final totalPrice = cart.totalPrice;

    // Menyimpan riwayat pesanan di SharedPreferences
    String orderSummary =
        '{"orderId": "INV-${DateTime.now().millisecondsSinceEpoch}", "date": "${DateTime.now().toString()}", "status": "Dalam Proses", "total": "${formatIDRCurrency(number: totalPrice)}"}';
    List<String> orderHistory = prefs.getStringList('orderHistory') ?? [];
    orderHistory.add(orderSummary);
    await prefs.setStringList('orderHistory', orderHistory);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pesanan berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(
      context,
    ); // Mendapatkan data cart dari CartProvider
    final items = cart.items; // Mengambil items yang ada di keranjang
    final totalPrice =
        cart.totalPrice; // Mengambil total harga dari CartProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: AppFont.nunitoSansSemiBold),
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.dark),
      ),
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan produk yang dipesan
            ListView.separated(
              shrinkWrap: true, // Menghindari overflow
              physics:
                  NeverScrollableScrollPhysics(), // Non-scrollable ListView agar scrollable pada SingleChildScrollView
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
                    formatIDRCurrency(
                      number: item['productPrice'] ?? 0,
                    ), // Menggunakan formatIDRCurrency
                    style: AppFont.nunitoSansBold,
                  ),
                );
              },
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
              title: const Text('Dana'),
              value: 'Dana',
              groupValue: _paymentMethod,
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Shopeepay'),
              value: 'Shopeepay',
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
            const SizedBox(height: 16),

            // Menambahkan Judul "Detail Order" sebelum menampilkan ukuran dan teks kustom
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Detail Order',
                style: AppFont.nunitoSansBold.copyWith(
                  fontSize: 16,
                  color: AppColor.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Menampilkan ukuran dan teks kustom pada checkout
            if (selectedSize != null && cakeWording != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Cake Size: $selectedSize',
                    style: AppFont.nunitoSansSemiBold.copyWith(
                      fontSize: 14,
                      color: AppColor.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wording: $cakeWording',
                    style: AppFont.nunitoSansSemiBold.copyWith(
                      fontSize: 14,
                      color: AppColor.dark,
                    ),
                  ),
                ],
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
                  formatIDRCurrency(
                    number: totalPrice,
                  ), // Memformat total price
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
                onPressed: () async {
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

                  // Simpan pesanan ke SharedPreferences
                  await _saveOrderToPreferences(items);

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
