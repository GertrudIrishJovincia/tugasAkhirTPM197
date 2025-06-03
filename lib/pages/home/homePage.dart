import 'package:flutter/material.dart';
import 'package:proyekakhir/components/widgets/bannerImage.dart';
import 'package:proyekakhir/components/widgets/outletImage.dart';
import 'package:proyekakhir/components/widgets/productCard.dart';
import 'package:proyekakhir/components/widgets/standSearchBar.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/pages/product/favoritePage.dart';
import 'package:proyekakhir/pages/product/orderHistoryPage.dart';
import 'package:proyekakhir/pages/product/productPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List dummyProducts = [
    {
      "id": 1,
      "productImage":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwEuDw3mdCJyGJ3wM1uIngWezPpcPFYElNAg&s",
      "productName": "Chocolate Cake",
      "productPrice": 10000,
    },
    {
      "id": 2,
      "productImage":
          "https://www.rainbownourishments.com/wp-content/uploads/2024/02/vegan-strawberry-sugar-cookies-1.jpg",
      "productName": "Strawberry Cookie",
      "productPrice": 5000,
    },
  ];

  final List dummyOutlets = [
    {
      "image":
          "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/25/fb/ca/e5/the-mandarin-cake-shop.jpg?w=500&h=-1&s=1",
      "address": "Outlet Klaten",
    },
    {
      "image":
          "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/25/fb/ca/e5/the-mandarin-cake-shop.jpg?w=500&h=-1&s=1",
      "address": "Outlet Yogyakarta",
    },
  ];

  bool isLoadingProducts = false;
  bool isLoadingOutlets = false;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        title: Text(
          'Hi there!',
          style: AppFont.nunitoSansBold.copyWith(
            fontSize: 20,
            color: AppColor.dark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            color: AppColor.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            color: AppColor.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryPage(),
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: AppColor.dark),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppColor.primary,
          backgroundColor: AppColor.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.gray),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const StandSearchBar(
                      'Search cake, cookies, anything..',
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 32 : 0,
                            right: 16,
                            top: 5,
                          ),
                          child: BannerImage(
                            "assets/images/banner_${index + 1}.png",
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Our Product',
                            style: AppFont.nunitoSansBold.copyWith(
                              color: AppColor.dark,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProductPage(),
                                ),
                              );
                            },
                            child: Text(
                              'All Product',
                              style: AppFont.nunitoSansBold.copyWith(
                                color: AppColor.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (isLoadingProducts)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primary,
                          ),
                        )
                      else
                        SizedBox(
                          height: 260,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: dummyProducts.length,
                            itemBuilder: (context, index) {
                              final product = dummyProducts[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  top: 16,
                                  bottom: 20,
                                ),
                                child: ProductCard(
                                  url: product["productImage"],
                                  productName:
                                      "${product["productName"]}-${product["id"]}",
                                  productPrice: product["productPrice"],
                                  onPressed: () {
                                    debugPrint(
                                      "Navigate to product detail: ${product["id"]}",
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Shop',
                        style: AppFont.nunitoSansBold.copyWith(
                          color: AppColor.dark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (isLoadingOutlets)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primary,
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12.0,
                                crossAxisSpacing: 12.0,
                              ),
                          itemCount: dummyOutlets.length,
                          itemBuilder: (context, index) {
                            final outlet = dummyOutlets[index];
                            return OutletImage(
                              url: outlet["image"],
                              text: outlet["address"],
                            );
                          },
                        ),
                    ],
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
