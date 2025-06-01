import 'package:flutter/material.dart';
import 'package:proyekakhir/components/widgets/productCard.dart';
import 'package:proyekakhir/components/widgets/standSearchBar.dart';
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';
import 'package:proyekakhir/pages/product/detailProductPage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  List<String> categories = ['Cake', 'Cookies', 'Cupcake'];
  String selectedCategory = 'Cake';

  bool isLoading = false;

  final Map<String, List<Map<String, dynamic>>> productsByCategory = {
    'Cake': [
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
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7x6786VLvfSL2E7XqCKdbO6W844Acv2y5aA&s",
        "productName": "Vanilla Cake",
        "productPrice": 12000,
      },
    ],
    'Cookies': [
      {
        "id": 3,
        "productImage":
            "https://www.onceuponachef.com/images/2021/11/Best-Chocolate-Chip-Cookies-1200x1499.jpg",
        "productName": "Chocolate Chip Cookie",
        "productPrice": 5000,
      },
    ],
    'Cupcake': [],
  };

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedCategory = categories[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get currentProducts =>
      productsByCategory[selectedCategory] ?? [];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColor.primary)),
      );
    }
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: AppColor.white,
          title: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.gray),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const StandSearchBar('Search cake, cookies, anything..'),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Categories',
                    style: AppFont.nunitoSansBold.copyWith(
                      fontSize: 20,
                      color: AppColor.dark,
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelStyle: AppFont.nunitoSansMedium.copyWith(fontSize: 14),
                  labelColor: AppColor.primary,
                  unselectedLabelColor: AppColor.dark,
                  indicatorColor: AppColor.primary,
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.only(left: 25, right: 25),
                  tabs: categories.map((cat) => Tab(text: cat)).toList(),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ProductTabView(products: currentProducts),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductTabView extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductTabView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text("No products found."));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          url: product["productImage"],
          productPrice: product["productPrice"],
          productName: product["productName"],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailProductPage(product: product),
              ),
            );
          },
        );
      },
    );
  }
}
