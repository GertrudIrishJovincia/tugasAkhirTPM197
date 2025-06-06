import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyekakhir/components/customWidgets/button.dart';
import 'package:proyekakhir/components/customWidgets/image.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/helpers/moneyFormat.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:proyekakhir/models/product.dart';
import 'package:proyekakhir/pages/cart/cartPage.dart';
import 'package:proyekakhir/providers/cardProviders.dart';
import 'package:proyekakhir/services/apiservice.dart';
import 'package:proyekakhir/util/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProductPage extends StatefulWidget {
  final String id;

  const DetailProductPage({super.key, required this.id});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  late Future<Product> _futureProduct;
  bool isFavorite = false;
  String? cakeWording; // Menyimpan teks kustom untuk kue
  String selectedSize = '16 cm'; // Ukuran default

  @override
  void initState() {
    super.initState();
    _futureProduct = Apiservice.fetchProductById(widget.id);
    checkFavoriteStatus();
    loadSizeAndWording(); // Memuat data ukuran dan teks kustom
  }

  // Cek status favorit
  void checkFavoriteStatus() async {
    List<String>? favoriteIds = await LocalStorage.getFavoriteIds();
    setState(() {
      isFavorite = favoriteIds?.contains(widget.id) ?? false;
    });
  }

  // Menyimpan ukuran dan teks kustom ke SharedPreferences
  void saveSizeAndWording(String size, String wording) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_size', size);
    await prefs.setString('cake_wording', wording);
  }

  // Memuat ukuran dan teks kustom dari SharedPreferences
  Future<void> loadSizeAndWording() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? size = prefs.getString('selected_size');
    String? wording = prefs.getString('cake_wording');

    setState(() {
      selectedSize =
          size ?? '16 cm'; // Menampilkan ukuran default jika tidak ada
      cakeWording =
          wording ?? ''; // Menampilkan teks kustom default jika tidak ada
    });
  }

  // Menangani perubahan ukuran
  void onSizeSelected(String size) {
    setState(() {
      selectedSize = size;
    });
    saveSizeAndWording(
      size,
      cakeWording ?? '',
    ); // Menyimpan ukuran dan teks kustom
  }

  // Menangani perubahan teks kustom
  void onWordingChanged(String value) {
    setState(() {
      cakeWording = value;
    });
    saveSizeAndWording(
      selectedSize,
      cakeWording ?? '',
    ); // Menyimpan ukuran dan teks kustom
  }

  // Menangani toggling status favorit
  void toggleFavorite() async {
    List<String> favoriteIds = await LocalStorage.getFavoriteIds() ?? [];
    if (isFavorite) {
      favoriteIds.remove(widget.id);
      await LocalStorage.setFavoriteIds(favoriteIds);
      setState(() {
        isFavorite = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Dihapus dari favorit')));
    } else {
      favoriteIds.add(widget.id);
      await LocalStorage.setFavoriteIds(favoriteIds);
      setState(() {
        isFavorite = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ditambahkan ke favorit')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColor.white,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada detail produk'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
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
                    image: NetworkImage("${product.productImage}"),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.productName,
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
                        "${product.rating ?? '0'}",
                        style: AppFont.nunitoSansSemiBold.copyWith(
                          color: AppColor.dark,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '(${product.ratingTotals ?? '0'})',
                        style: AppFont.nunitoSansSemiBold.copyWith(
                          color: AppColor.grayWafer,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    product.productDescription ??
                        "This is a delicious cake made with the finest ingredients. Perfect for any celebration or simply to satisfy your sweet tooth. Made fresh daily to ensure the best taste and quality.",
                    style: AppFont.nunitoSansRegular.copyWith(
                      color: AppColor.dark,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),

                  // Display size options only for Cake category
                  if (product.category == 'Cake')
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
                        onSizeSelected(value); // Menyimpan ukuran yang dipilih
                      },
                      selectedColor: AppColor.primary,
                      enableButtonWrap: false,
                    ),
                  const SizedBox(height: 16),

                  // Input for custom cake wording
                  if (product.category == 'Cake')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: onWordingChanged, // Menyimpan teks kustom
                          decoration: InputDecoration(
                            hintText: 'Enter your wording here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
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
      bottomNavigationBar: FutureBuilder<Product>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink(); // No bottom bar while loading
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink(); // Hide bottom bar if there's an error or no data
          }

          final product = snapshot.data!;

          return Container(
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
                      formatIDRCurrency(
                        number: (product.productPrice ?? 0).toDouble(),
                      ),
                      style: AppFont.nunitoSansBold.copyWith(
                        fontSize: 18,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
                PillsButton(
                  onPressed: () {
                    // Add product to cart
                    final cartItem = {
                      'id': product.id,
                      'productName': product.productName,
                      'productPrice': product.productPrice,
                      'productImage': product.productImage,
                      'category': product.category,
                      'cakeWording': cakeWording, // Include custom wording
                      'selectedSize': selectedSize, // Include selected size
                    };
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).addItem(cartItem);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                  fullWidthButton: false,
                  text: 'Add to cart',
                  fontSize: 16,
                  paddingSize: 24,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
