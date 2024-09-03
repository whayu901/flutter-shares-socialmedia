// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  Future<Uint8List> downloadImageWithDio(String imageUrl) async {
    try {
      final dio = Dio();
      final response = await dio.get(imageUrl,
          options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    } catch (e) {
      throw Exception('Failed to download image with dio: $e');
    }
  }

  Future<String> saveImageToFile(Uint8List imageBytes, String filename) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(imageBytes);
    return file.path;
  }

  Future<void> shareImageFromUrlWithDio(String imageUrl) async {
    try {
      // Download the image
      final imageBytes = await downloadImageWithDio(imageUrl);
      // Save the image to the device
      final imagePath = await saveImageToFile(imageBytes, 'shared_image.png');
      // Share the image
      await Share.shareFiles([imagePath], text: 'Check out this image!');
    } catch (e) {
      print('Error sharing image: $e');
    }
  }

  final String imageUrl =
      'https://via.placeholder.com/600x400.png?text=Test+Image';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          shareImageFromUrlWithDio(imageUrl);
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          'Click Me',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
