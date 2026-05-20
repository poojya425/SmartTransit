import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/route_model.dart';

// RouteService handles all CRUD operations for routes.
class RouteService {
  // getRoutes returns all routes from the API.
  Future<List<RouteModel>> getRoutes() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/routes'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => RouteModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load routes');
  }

  // createRoute adds a new route via the API.
  Future<RouteModel> createRoute(RouteModel route) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/routes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(route.toJson()),
    );
    if (response.statusCode == 201) {
      return RouteModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create route');
  }

  // updateRoute updates an existing route by ID.
  Future<void> updateRoute(String id, RouteModel route) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/routes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(route.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update route');
    }
  }

  // deleteRoute removes a route by ID.
  Future<void> deleteRoute(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/routes/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete route');
    }
  }
}