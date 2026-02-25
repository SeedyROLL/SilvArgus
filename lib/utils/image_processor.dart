import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageProcessor {
  // Constant size required for TFLite model: 224x224.
  static const int inputSize = 224;

  /// Loads, resizes, and processes an image file into a tensor format suitable for TFLite inference.
  static Future<List<List<List<double>>>?> preprocessImageForTFLite(String imagePath) async {
    try {
      final File file = File(imagePath);
      final Uint8List bytes = await file.readAsBytes();
      
      // Use compute to offload heavy image decoding, resizing, and tensor-mapping to a background isolate
      return await compute(_decodeAndConvertToTensor, bytes);
    } catch (e) {
      debugPrint('Error preprocessing image: \$e');
      return null;
    }
  }

  /// Top-level function necessary for compute() to run in an Isolate.
  static List<List<List<double>>>? _decodeAndConvertToTensor(Uint8List bytes) {
    // Decode image
    img.Image? decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) return null;

    // Resize to match model requirements (224x224)
    img.Image resizedImage = img.copyResize(
      decodedImage,
      width: inputSize,
      height: inputSize,
    );

    // Convert into [224, 224, 3] representation, normalizing pixels to floats between 0.0 and 1.0.
    final List<List<List<double>>> imageTensor = List.generate(
      inputSize,
      (y) => List.generate(
        inputSize,
        (x) {
          final pixel = resizedImage.getPixel(x, y);
          // Return [R, G, B]
          return [
            pixel.r.toDouble() / 255.0,
            pixel.g.toDouble() / 255.0,
            pixel.b.toDouble() / 255.0,
          ];
        },
      ),
    );

    return imageTensor;
  }
}
