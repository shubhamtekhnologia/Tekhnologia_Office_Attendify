// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// class QRCodeGenerator extends StatelessWidget {
//   final double latitude;
//   final double longitude;
//
//   const QRCodeGenerator({
//     Key? key,
//     required this.latitude,
//     required this.longitude,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     String qrData = 'geo:$latitude,$longitude';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Entry Gate QR Code'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             QrImage(
//               data: qrData,
//               size: 200.0,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Latitude: $latitude\nLongitude: $longitude',
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
