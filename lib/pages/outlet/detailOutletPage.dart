import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import Google Maps Flutter
import 'package:proyekakhir/models/outlet.dart'; // Pastikan model Outlet sudah ada
import 'package:proyekakhir/config/app/appColor.dart';
import 'package:proyekakhir/config/app/appFont.dart';

class DetailOutletPage extends StatefulWidget {
  final Outlet outlet;

  const DetailOutletPage({super.key, required this.outlet});

  @override
  State<DetailOutletPage> createState() => _DetailOutletPageState();
}

class _DetailOutletPageState extends State<DetailOutletPage> {
  late GoogleMapController _mapController;
  late LatLng _outletLocation;

  @override
  void initState() {
    super.initState();
    _outletLocation = LatLng(
      widget.outlet.latitude,
      widget.outlet.longitude,
    ); // Mengambil lat dan long dari outlet
  }

  // Fungsi untuk membuat marker di peta
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Text(widget.outlet.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Gambar outlet
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.outlet.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Nama outlet
            Text(
              widget.outlet.name,
              style: AppFont.nunitoSansBold.copyWith(
                fontSize: 24,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 8),

            // Alamat outlet
            Text(
              widget.outlet.address,
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 16,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 16),

            // Menampilkan jumlah produk yang dijual
            Text(
              'Produk yang Dijual: ${widget.outlet.outletSells}',
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 16,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 16),

            // Menampilkan tanggal outlet dibuat
            Text(
              'Dibuat pada: ${widget.outlet.createdAt.substring(0, 10)}',
              style: AppFont.nunitoSansRegular.copyWith(
                fontSize: 16,
                color: AppColor.dark,
              ),
            ),
            const SizedBox(height: 16),

            // Menambahkan Peta
            SizedBox(
              height: 300, // Tinggi peta
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _outletLocation,
                  zoom: 14.0, // Zoom peta
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('outlet_location'),
                    position: _outletLocation,
                    infoWindow: InfoWindow(
                      title: widget.outlet.name,
                      snippet: widget.outlet.address,
                    ),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
