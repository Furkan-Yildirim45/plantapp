import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/controller/camera_controller.dart';
import 'package:plant/controller/plant_net_controller.dart';

class PlantNetView extends StatelessWidget {
  final PlantNetController plantController = Get.put(PlantNetController());
  final AppCameraController cameraController = Get.put(AppCameraController());

  PlantNetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: plantController.pickImage,
            child: const Text("Fotoğraf Yükle"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: cameraController.takePicture,
            child: const Text("Kameradan Çek"),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(title: const Center(child: Text("Bitki Tanıma"))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              if (cameraController.image.value == null) {
                return const Text("Fotoğraf yükleyin");
              }
              return Center(
                child: Image.file(
                  cameraController.image.value!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              if (cameraController.result.value == null) {
                return const Text("Sonuç yok");
              }
              var result = cameraController.result.value!;
              var plant = result.result.classification.suggestions.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bitki Adı: ${plant.name}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Olasılık: ${(plant.probability * 100).toStringAsFixed(2)}%",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text("Benzer Resimler:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: plant.similarImages.length,
                      itemBuilder: (context, index) {
                        var img = plant.similarImages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              img.urlSmall,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
            Obx(() {
              if (cameraController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox(height: 150);
            }),
          ],
        ),
      ),
    );
  }
}
