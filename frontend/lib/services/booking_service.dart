import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/booking.dart';

// BookingService handles all CRUD operations for bookings.
class BookingService {
  // getBookings returns all bookings from the API.
  Future<List<Booking>> getBookings() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/bookings'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    }
    throw Exception('Failed to load bookings');
  }

  // createBooking adds a new booking via the API.
  Future<Booking> createBooking(Booking booking) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(booking.toJson()),
    );
    if (response.statusCode == 201) {
      return Booking.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create booking');
  }

  // updateBooking updates an existing booking by ID.
  Future<void> updateBooking(String id, Booking booking) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/bookings/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(booking.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update booking');
    }
  }

  // deleteBooking removes a booking by ID.
  Future<void> deleteBooking(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/bookings/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete booking');
    }
  }
}