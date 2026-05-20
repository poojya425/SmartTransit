// Booking represents a seat booking made by a user.
class Booking {
  final String id;
  final String userId;
  final String busId;
  final int seatNumber;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.busId,
    required this.seatNumber,
    required this.status,
  });

  // fromJson creates a Booking from a JSON map.
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      busId: json['bus_id'] ?? '',
      seatNumber: json['seat_number'] ?? 0,
      status: json['status'] ?? 'pending',
    );
  }

  // toJson converts a Booking to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'bus_id': busId,
      'seat_number': seatNumber,
      'status': status,
    };
  }
}