import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String _cloudName = "dw5wdcchx";
  static const String _uploadPreset = "ml_default";

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      );

      var request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = _uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['secure_url']; // Returns the URL
      } else {
        print("Cloudinary Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Upload Exception: $e");
      return null;
    }
  }
}