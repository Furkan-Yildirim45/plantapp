import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/model/plant_recognition_response.dart';
import 'package:plant/services/plant_recognization_service.dart';

class PlantNetController extends GetxController {
  var image = Rx<File?>(null); // Tek bir resim için değişken
  var result = Rx<PlantRecognitionResponse?>(null); // Tam tanımlama sonucu
  PlantRecognitionService service = PlantRecognitionService();
  bool _isPickingImage = false; // Resim seçme işleminin durumunu takip et
  var isLoading = false.obs; // Loading durumu için reaktif değişken

  Future<void> pickImage() async {
    if (_isPickingImage) return; // Eğer resim seçme işlemi devam ediyorsa, çık

    _isPickingImage = true; // Resim seçme işlemi başladı

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      ); // Tek resim seçimi

      if (pickedFile != null) {
        image.value = File(pickedFile.path);
        await recognizePlant(); // Sadece resim seçildiğinde çağrılacak
      } else {
      }
    } catch (e) {
      print("hata :$e");
    } finally {
      _isPickingImage = false; // Her durumda sıfırla
    }
  }

  Future<void> recognizePlant() async {
    if (image.value == null) {
      Get.snackbar(
        "Hata",
        "Resim yüklenmedi. Lütfen bir resim seçin.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true; // Loading durumunu başlat
    var response = await service.recognizePlant(image.value!);
    isLoading.value = false; // Loading durumunu bitir

    if (response != null) {
      result.value = response; 
    } else {
      result.value = null; 
      print("result is null");
    }
  }
}
