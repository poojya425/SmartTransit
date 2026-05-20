import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/bus.dart';

// BusService handles all CRUD operations for buses.
class BusService {
  // getBuses returns all buses from the API.
  Future<List<Bus>> getBuses() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/buses'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Bus.fromJson(json)).toList();
    }
    throw Exception('Failed to load buses');
  }

  // getBusById returns a single bus by ID.
  Future<Bus> getBusById(String id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/buses/$id'),
    );
    if (response.statusCode == 200) {
      return Bus.fromJson(jsonDecode(response.body));
    }
    throw Exception('Bus not found');
  }

  // createBus adds a new bus via the API.
  Future<Bus> createBus(Bus bus) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/buses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bus.toJson()),
    );
    if (response.statusCode == 201) {
      return Bus.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create bus');
  }

  // updateBus updates an existing bus by ID.
  Future<void> updateBus(String id, Bus bus) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/buses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bus.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update bus');
    }
  }

  // deleteBus removes a bus by ID.
  Future<void> deleteBus(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/buses/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete bus');
    }
  }
}