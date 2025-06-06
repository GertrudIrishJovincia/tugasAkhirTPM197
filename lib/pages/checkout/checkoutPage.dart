// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Untuk format waktu dan angka
// import 'package:http/http.dart' as http;
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';
import 'package:proyekakhir/providers/cardProviders.dart'; // Untuk mengambil data API
import 'package:shared_preferences/shared_preferences.dart'; // Untuk mengambil data API

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  String _paymentMethod = 'Dana'; // Default payment method
  String _selectedCurrency = 'IDR'; // Default currency
  String _deliveryTime = ''; // To display selected delivery time

  // Inisialisasi nilai tukar yang tepat
  double _usdToIdr = 15000.0; // IDR ke USD
  double _eurToIdr = 16000.0; // IDR ke EUR
  double _gbpToIdr = 20000.0; // IDR ke GBP

  double _usdToEur = 0.85; // Nilai tukar USD ke EUR (jika dibutuhkan)

  String _convertedAmount = ''; // To display converted amount
  String _convertedTime = ''; // To display converted time
  String? selectedSize; // Ukuran Kue
  String? cakeWording; // Teks kustom untuk kue

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengkonversi mata uang
  String calculateConvertedAmount(double totalPrice) {
    double convertedAmount = 0.0;
    switch (_selectedCurrency) {
      case 'USD':
        convertedAmount = totalPrice / _usdToIdr; // Mengonversi IDR ke USD
        break;
      case 'EUR':
        convertedAmount = totalPrice / _eurToIdr; // Mengonversi IDR ke EUR
        break;
      case 'GBP':
        convertedAmount = totalPrice / _gbpToIdr; // Mengonversi IDR ke GBP
        break;
      case 'IDR':
      default:
        convertedAmount = totalPrice; // Tidak ada konversi untuk IDR
        break;
    }
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
    ).format(convertedAmount); // Format hasil konversi
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
    // Misalnya, Anda bisa memuat nilai tukar dengan API di sini
    // fetchCurrencyRates();
  }

  // Konversi waktu pengiriman (WIB)
  String convertToTimezone(String selectedTime, String timezone) {
    String timeWithoutZone = selectedTime.split(
      ' ',
    )[0]; // Ambil waktu seperti '10:00'
    DateTime deliveryTime = DateFormat(
      'HH:mm',
    ).parse(timeWithoutZone); // Format 24 jam

    DateTime convertedTime;
    switch (timezone) {
      case 'WIB':
        convertedTime = deliveryTime; // WIB tidak perlu diubah
        break;
      case 'WITA':
        convertedTime = deliveryTime.add(Duration(hours: 1)); // WITA +1 jam
        break;
      case 'WIT':
        convertedTime = deliveryTime.add(Duration(hours: 2)); // WIT +2 jam
        break;
      case 'London':
        convertedTime = deliveryTime.subtract(
          Duration(hours: 7),
        ); // London -7 jam dari WIB
        break;
      default:
        convertedTime = deliveryTime;
    }

    return DateFormat('yyyy-MM-dd HH:mm:ss').format(convertedTime);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items;
    final totalPrice = cart.totalPrice;

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
            // Display product details
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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

            // Select payment method
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

            // Dropdown to select currency
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Currency',
                style: AppFont.nunitoSansBold.copyWith(fontSize: 16),
              ),
            ),
            DropdownButton<String>(
              value: _selectedCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                });
              },
              items: <String>['IDR', 'USD', 'EUR', 'GBP']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Display converted total price
            Text(
              'Converted Total: ${calculateConvertedAmount(totalPrice)}',
              style: AppFont.nunitoSansBold.copyWith(
                fontSize: 18,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Timezone dropdown (Choose delivery time)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Delivery Time (WIB)',
                style: AppFont.nunitoSansBold.copyWith(fontSize: 16),
              ),
            ),
            DropdownButton<String>(
              value: _deliveryTime.isEmpty ? null : _deliveryTime,
              hint: const Text("Select Time"),
              onChanged: (String? newValue) {
                setState(() {
                  _deliveryTime = newValue!;
                });
              },
              items: <String>['10:00 WIB', '12:00 WIB', '15:00 WIB']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Display the selected delivery time and converted times
            if (_deliveryTime.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Time: $_deliveryTime',
                    style: AppFont.nunitoSansBold.copyWith(
                      fontSize: 18,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Converted Time (WIB): ${convertToTimezone(_deliveryTime, 'WIB')}',
                    style: AppFont.nunitoSansBold.copyWith(
                      fontSize: 18,
                      color: AppColor.primary,
                    ),
                  ),
                  Text(
                    'Converted Time (WITA): ${convertToTimezone(_deliveryTime, 'WITA')}',
                    style: AppFont.nunitoSansBold.copyWith(
                      fontSize: 18,
                      color: AppColor.primary,
                    ),
                  ),
                  Text(
                    'Converted Time (WIT): ${convertToTimezone(_deliveryTime, 'WIT')}',
                    style: AppFont.nunitoSansBold.copyWith(
                      fontSize: 18,
                      color: AppColor.primary,
                    ),
                  ),
                  Text(
                    'Converted Time (London): ${convertToTimezone(_deliveryTime, 'London')}',
                    style: AppFont.nunitoSansBold.copyWith(
                      fontSize: 18,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),

            // Total Price in IDR (or selected currency)
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
                  calculateConvertedAmount(totalPrice),
                  style: AppFont.nunitoSansBold.copyWith(
                    fontSize: 18,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Confirm Order button
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
                  Future<void> _saveOrderToPreferences(
                    List<Map<String, dynamic>> items,
                  ) async {
                    final prefs = await SharedPreferences.getInstance();

                    // Mengonversi item keranjang menjadi string JSON
                    List<String> productsJson = items.map((item) {
                      return '{"id": "${item['id']}", "productName": "${item['productName']}", "productPrice": ${item['productPrice']}, "productImage": "${item['productImage']}"}';
                    }).toList();

                    // Menyimpan data pesanan
                    await prefs.setStringList('orderItems', productsJson);
                    await prefs.setString(
                      'shippingAddress',
                      _addressController.text,
                    );
                    await prefs.setString('paymentMethod', _paymentMethod);
                    await prefs.setString('deliveryTime', _deliveryTime);

                    // Mendapatkan total harga dan konversi ke int
                    final cart = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    );
                    final totalPrice = cart.totalPrice;

                    // Menyimpan riwayat pesanan di SharedPreferences
                    String orderSummary =
                        '{"orderId": "INV-${DateTime.now().millisecondsSinceEpoch}", "date": "${DateTime.now().toString()}", "status": "Dalam Proses", "total": "${formatIDRCurrency(number: totalPrice)}"}';
                    List<String> orderHistory =
                        prefs.getStringList('orderHistory') ?? [];
                    orderHistory.add(orderSummary);
                    await prefs.setStringList('orderHistory', orderHistory);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pesanan berhasil disimpan'),
                      ),
                    );
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
