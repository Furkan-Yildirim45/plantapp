import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant/controller/plant_net_controller.dart';

class PlantNetView extends StatelessWidget {
  final PlantNetController controller = Get.put(PlantNetController());

  PlantNetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: controller.pickImage,
        child: Text("Fotoğraf Yükle"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(title: Center(child: Text("Bitki Tanıma"))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => controller.image.value == null
                  ? Text("Fotoğraf yükleyin")
                  : Center(child: Image.file(controller.image.value!, width: 250, height: 250, fit: BoxFit.cover)),
            ),
            SizedBox(height: 20),
            Obx(() {
              if (controller.result.value == null) {
                return Text("Sonuç yok");
              }
              var result = controller.result.value!;
              var plant = result.result.classification.suggestions.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bitki Adı: ${plant.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Olasılık: ${(plant.probability * 100).toStringAsFixed(2)}%", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Benzer Resimler:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
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
                            child: Center(
                              child: Image.network(
                                img.urlSmall,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
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
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              return SizedBox(height: 100);
            }),
          ],
        ),
      ),
    );
  }
}
