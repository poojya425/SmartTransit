// Bus represents a bus vehicle in the system.
class Bus {
  final String id;
  final String busNumber;
  final String routeId;
  final int capacity;
  final String status;

  Bus({
    required this.id,
    required this.busNumber,
    required this.routeId,
    required this.capacity,
    required this.status,
  });

  // fromJson creates a Bus from a JSON map.
  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'] ?? '',
      busNumber: json['bus_number'] ?? '',
      routeId: json['route_id'] ?? '',
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? 'active',
    );
  }

  // toJson converts a Bus to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'bus_number': busNumber,
      'route_id': routeId,
      'capacity': capacity,
      'status': status,
    };
  }
}