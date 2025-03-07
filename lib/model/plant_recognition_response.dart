class PlantRecognitionResponse {
  final String accessToken;
  final String modelVersion;
  final Result result;

  PlantRecognitionResponse({
    required this.accessToken,
    required this.modelVersion,
    required this.result,
  });

  factory PlantRecognitionResponse.fromJson(Map<String, dynamic> json) {
    return PlantRecognitionResponse(
      accessToken: json['access_token'] ?? '',
      modelVersion: json['model_version'] ?? '',
      result: Result.fromJson(json['result'] ?? {}),
    );
  }
}

class Result {
  final IsPlant isPlant;
  final Classification classification;

  Result({
    required this.isPlant,
    required this.classification,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      isPlant: IsPlant.fromJson(json['is_plant'] ?? {}),
      classification: Classification.fromJson(json['classification'] ?? {}),
    );
  }
}

class IsPlant {
  final double probability;
  final bool binary;
  final double threshold;

  IsPlant({
    required this.probability,
    required this.binary,
    required this.threshold,
  });

  factory IsPlant.fromJson(Map<String, dynamic> json) {
    return IsPlant(
      probability: json['probability'] ?? 0.0,
      binary: json['binary'] ?? false,
      threshold: json['threshold'] ?? 0.0,
    );
  }
}

class Classification {
  final List<Suggestion> suggestions;

  Classification({required this.suggestions});

  factory Classification.fromJson(Map<String, dynamic> json) {
    return Classification(
      suggestions: (json['suggestions'] as List?)
              ?.map((i) => Suggestion.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class Suggestion {
  final String id;
  final String name;
  final double probability;
  final List<SimilarImage> similarImages;

  Suggestion({
    required this.id,
    required this.name,
    required this.probability,
    required this.similarImages,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      probability: json['probability'] ?? 0.0,
      similarImages: (json['similar_images'] as List?)
              ?.map((i) => SimilarImage.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class SimilarImage {
  final String id;
  final String url;
  final double similarity;
  final String urlSmall;

  SimilarImage({
    required this.id,
    required this.url,
    required this.similarity,
    required this.urlSmall,
  });

  factory SimilarImage.fromJson(Map<String, dynamic> json) {
    return SimilarImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      similarity: json['similarity'] ?? 0.0,
      urlSmall: json['url_small'] ?? '',
    );
  }
}
