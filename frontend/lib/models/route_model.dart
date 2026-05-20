// RouteModel represents a bus route in the system.
class RouteModel {
  final String id;
  final String name;
  final String startStop;
  final String endStop;

  RouteModel({
    required this.id,
    required this.name,
    required this.startStop,
    required this.endStop,
  });

  // fromJson creates a RouteModel from a JSON map.
  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      startStop: json['start_stop'] ?? '',
      endStop: json['end_stop'] ?? '',
    );
  }

  // toJson converts a RouteModel to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'start_stop': startStop,
      'end_stop': endStop,
    };
  }
}