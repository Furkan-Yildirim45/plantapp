import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:plant/model/plant_recognition_response.dart';

class PlantRecognitionService {
  final Dio _dio = Dio();
  final String apiKey = 'T6T213wIqgb9WPM47vqpEENQrcmIJFDFmhrxws2J7lh9GbXS91';
  final String apiUrl = 'https://plant.id/api/v3/identification';

  Future<PlantRecognitionResponse?> recognizePlant(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    final requestBody = {
      "images": [base64Image],
      "similar_images": true,
    };

    try {
      Response response = await _dio.post(
        apiUrl,
        data: jsonEncode(requestBody),
        options: Options(
          headers: {"Content-Type": "application/json", "Api-Key": apiKey},
        ),
      );

      if (response.data != null) {
        print("200 okey");
        return PlantRecognitionResponse.fromJson(response.data);
      } else {
        print("Yanıt verisi: ${response.data}");
        return null;
      }
    } catch (e) {
      if (e is DioError) {
        print("Dio hatası: ${e.response?.statusCode} - ${e.message}");
        if (e.response != null) {
          print("Yanıt verisi: ${e.response?.data}");
        }
      } else {
        print("Beklenmeyen hata: $e");
      }
      return null;
    }
  }
}
