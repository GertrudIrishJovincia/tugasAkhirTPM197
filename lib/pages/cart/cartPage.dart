import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/pages/checkout/checkoutPage.dart';
import 'package:proyekakhir/providers/cardProviders.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang', style: AppFont.nunitoSansSemiBold),
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.dark),
      ),
      backgroundColor: AppColor.white,
      body: cart.items.isEmpty
          ? Center(
              child: Text('Keranjang kosong', style: AppFont.nunitoSansRegular),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Image.network(
                      item['productImage'],
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item['productName'],
                      style: AppFont.nunitoSansSemiBold,
                    ),
                    subtitle: Text(
                      formatIDRCurrency(number: item['productPrice'] ?? 0),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: AppColor.red),
                      onPressed: () => cart.removeItem(index),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total', style: AppFont.nunitoSansRegular),
                      Text(
                        formatIDRCurrency(number: cart.totalPrice),
                        style: AppFont.nunitoSansBold.copyWith(
                          fontSize: 20,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 140,
                    child: PillsButton(
                      text: 'Checkout',
                      fullWidthButton: true,
                      onPressed: () {
                        // Navigasi ke halaman checkout
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
