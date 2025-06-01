import 'package:flutter/material.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/components/customWidgets/image.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class DetailProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const DetailProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColor.white,
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Favorite tapped');
            },
            icon: const Icon(Icons.favorite_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OverlayImage(
                  borderRadius: 22,
                  height: 343,
                  boxFit: BoxFit.cover,
                  width: double.infinity,
                  image: NetworkImage(product["productImage"]),
                ),
                const SizedBox(height: 12),
                Text(
                  product["productName"],
                  style: AppFont.nunitoSansBold.copyWith(
                    color: AppColor.dark,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColor.yellow, size: 16),
                    Text(
                      "${product["rating"] ?? '0'}",
                      style: AppFont.nunitoSansSemiBold.copyWith(
                        color: AppColor.dark,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '(${product["ratingTotals"] ?? '0'})',
                      style: AppFont.nunitoSansSemiBold.copyWith(
                        color: AppColor.grayWafer,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  product["productDescription"] ??
                      "This is a delicious cake made with the finest ingredients. Perfect for any celebration or simply to satisfy your sweet tooth. Made fresh daily to ensure the best taste and quality.",
                  style: AppFont.nunitoSansRegular.copyWith(
                    color: AppColor.dark,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                CustomRadioButton(
                  elevation: 0,
                  enableShape: true,
                  buttonTextStyle: ButtonTextStyle(
                    textStyle: AppFont.nunitoSansSemiBold.copyWith(
                      color: AppColor.dark,
                      fontSize: 12,
                    ),
                  ),
                  unSelectedColor: AppColor.white,
                  unSelectedBorderColor: AppColor.dark.withOpacity(0.3),
                  selectedBorderColor: AppColor.primary,
                  buttonLables: const ['16 cm', '20 cm', '22 cm', '24 cm'],
                  buttonValues: const ['16 cm', '20 cm', '22 cm', '24 cm'],
                  width: 80,
                  padding: 8,
                  spacing: 1,
                  radioButtonValue: (value) {
                    debugPrint('Selected size: $value');
                  },
                  selectedColor: AppColor.primary,
                  enableButtonWrap: false,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.border_color,
                      size: 16,
                      color: AppColor.grayWafer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ' Add wording on your cake (optional)',
                      style: AppFont.nunitoSansRegular.copyWith(
                        color: AppColor.grayWafer,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(color: AppColor.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total price',
                  style: AppFont.nunitoSansRegular.copyWith(
                    fontSize: 12,
                    color: AppColor.grayWafer,
                  ),
                ),
                Text(
                  formatIDRCurrency(number: product["productPrice"] ?? 0),
                  style: AppFont.nunitoSansBold.copyWith(
                    fontSize: 18,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
            PillsButton(
              onPressed: () {
                debugPrint('Add to cart pressed');
              },
              fullWidthButton: false,
              text: 'Add to cart',
              fontSize: 16,
              paddingSize: 24,
            ),
          ],
        ),
      ),
    );
  }
}
