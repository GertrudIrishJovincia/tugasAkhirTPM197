import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  // Menyediakan akses untuk mendapatkan daftar item keranjang
  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  // Menambahkan item ke keranjang
  void addItem(Map<String, dynamic> product) {
    _items.add(product);
    notifyListeners();
  }

  // Menghapus item dari keranjang berdasarkan index
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // Mengosongkan keranjang
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Menghitung total harga keranjang dengan tipe double
  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += (item["productPrice"] ?? 0.0);
    }
    return total;
  }
}
