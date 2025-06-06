class Outlet {
  final String id;
  final String name;
  final String address;
  final String image;
  final int outletSells;
  final String createdAt;
  final double latitude; // Pastikan ada properti latitude
  final double longitude;

  Outlet({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.outletSells,
    required this.createdAt,
    required this.latitude, // Inisialisasi latitude
    required this.longitude,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['image'],
      outletSells: json['outlet_sells'],
      createdAt: json['created_at'],
      latitude: json['latitude'], // Pastikan mendapatkan latitude dari JSON
      longitude: json['longitude'],
    );
  }
}
