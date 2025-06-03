import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyekakhir/providers/favoriteProvider.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/components/widgets/productCard.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  Future<void> _refreshFavorites(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorit Saya',
          style: AppFont.nunitoSansBold.copyWith(color: AppColor.white),
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.white),
      ),
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshFavorites(context),
          color: AppColor.primary,
          backgroundColor: AppColor.white,
          child: favorites.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada produk favorit',
                    style: AppFont.nunitoSansRegular.copyWith(fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      return ProductCard(
                        url: product['productImage'],
                        productName: product['productName'],
                        productPrice: product['productPrice'],
                        onPressed: () {
                          // Navigasi ke detail produk jika perlu
                        },
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
