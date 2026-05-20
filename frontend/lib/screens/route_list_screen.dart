import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../services/route_service.dart';

// RouteListScreen displays all routes with add, edit, delete options.
class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  final RouteService _routeService = RouteService();
  List<RouteModel> _routes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  // _loadRoutes fetches all routes from the API.
  Future<void> _loadRoutes() async {
    try {
      final routes = await _routeService.getRoutes();
      setState(() {
        _routes = routes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load routes');
    }
  }

  // _showError displays an error snackbar.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // _showRouteDialog shows a dialog to add or edit a route.
  void _showRouteDialog({RouteModel? route}) {
    final nameController = TextEditingController(text: route?.name ?? '');
    final startStopController =
        TextEditingController(text: route?.startStop ?? '');
    final endStopController =
        TextEditingController(text: route?.endStop ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(route == null ? 'Add Route' : 'Edit Route'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Route Name'),
              ),
              TextField(
                controller: startStopController,
                decoration: const InputDecoration(labelText: 'Start Stop'),
              ),
              TextField(
                controller: endStopController,
                decoration: const InputDecoration(labelText: 'End Stop'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newRoute = RouteModel(
                id: route?.id ?? '',
                name: nameController.text,
                startStop: startStopController.text,
                endStop: endStopController.text,
              );
              try {
                if (route == null) {
                  await _routeService.createRoute(newRoute);
                } else {
                  await _routeService.updateRoute(route.id, newRoute);
                }
                Navigator.pop(context);
                _loadRoutes();
              } catch (e) {
                _showError('Failed to save route');
              }
            },
            child: Text(route == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // _deleteRoute removes a route after confirmation.
  void _deleteRoute(RouteModel route) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Route'),
        content: Text('Are you sure you want to delete ${route.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _routeService.deleteRoute(route.id);
                Navigator.pop(context);
                _loadRoutes();
              } catch (e) {
                _showError('Failed to delete route');
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _routes.isEmpty
              ? const Center(child: Text('No routes found'))
              : ListView.builder(
                  itemCount: _routes.length,
                  itemBuilder: (context, index) {
                    final route = _routes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.route, color: Colors.green),
                        title: Text(route.name),
                        subtitle: Text(
                            '${route.startStop} → ${route.endStop}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.orange),
                              onPressed: () =>
                                  _showRouteDialog(route: route),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () => _deleteRoute(route),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRouteDialog(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}