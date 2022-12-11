class ConfigModel {
  final String name;
  final List<CoordinatesModel> coords;

  ConfigModel({
    required this.name,
    required this.coords,
  });

  Map<String, dynamic> toJson() {
    List<Map> coordsJson = coords.map((i) => i.toJson()).toList();

    return {
      "name": name,
      "coords": coordsJson,
    };
  }
}

class CoordinatesModel {
  final String x;
  final String y;

  CoordinatesModel({
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };
}
