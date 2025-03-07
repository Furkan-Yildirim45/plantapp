import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/model/plant_recognition_response.dart';
import 'package:plant/services/plant_recognization_service.dart';

class AppCameraController extends GetxController {
  var image = Rx<File?>(null);
  var result = Rx<PlantRecognitionResponse?>(null);
  var isLoading = false.obs;
  PlantRecognitionService service = PlantRecognitionService();

  CameraController? cameraController;
  late List<CameraDescription> cameras;

  @override
  void onInit() async {
    super.onInit();
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(
        cameras[0], 
        ResolutionPreset.high,
      );
      await cameraController!.initialize();
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }


  Future<void> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      await recognizePlant();
    } else {
      Get.snackbar("Hata", "Fotoğraf çekilmedi.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> recognizePlant() async {
    if (image.value == null) {
      Get.snackbar(
        "Hata",
        "Resim yüklenmedi. Lütfen bir resim çekin veya seçin.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    var response = await service.recognizePlant(image.value!);
    isLoading.value = false;

    if (response != null) {
      result.value = response; 
    } else {
      result.value = null; 
      Get.snackbar(
        "Hata",
        "Bitki tanımlanamadı. Lütfen tekrar deneyin.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
