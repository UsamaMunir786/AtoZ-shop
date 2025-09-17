import 'dart:convert';
import 'dart:typed_data';
import 'package:a_to_z/models/image_model.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html; // only for web

class ImageProviderService {
  Future<ImageModel> uploadImage(html.File imageFile) async {
    final String imageName = 'image${DateTime.now().microsecondsSinceEpoch}';
    final String telescopeImageDirectory = "telescope_images/";

    // 🔹 Cloudinary credentials
    const String cloudName = "dcuxllwmz";
    const String uploadPreset = "food-fyp";

    // Convert file -> base64
    final reader = html.FileReader();
    reader.readAsDataUrl(imageFile);
    await reader.onLoadEnd.first;

    final base64String = reader.result.toString().split(",").last;
    final bytes = base64Decode(base64String);

    // Cloudinary API
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final response = await http.post(
      url,
      body: {
        "file": "data:image/png;base64,${base64Encode(bytes)}",
        "upload_preset": uploadPreset,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final String imageUrl = jsonResponse["secure_url"];

      return ImageModel(
        imageName: imageName,
        directoryName: telescopeImageDirectory,
        downloadUrl: imageUrl,
      );
    } else {
      throw Exception("❌ Cloudinary upload failed: ${response.body}");
    }
  }
}
