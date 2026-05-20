import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../services/bus_service.dart';

// BusListScreen displays all buses with add, edit, delete options.
class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final BusService _busService = BusService();
  List<Bus> _buses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuses();
  }

  // _loadBuses fetches all buses from the API.
  Future<void> _loadBuses() async {
    try {
      final buses = await _busService.getBuses();
      setState(() {
        _buses = buses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load buses');
    }
  }

  // _showError displays an error snackbar.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // _showBusDialog shows a dialog to add or edit a bus.
  void _showBusDialog({Bus? bus}) {
    final busNumberController = TextEditingController(text: bus?.busNumber ?? '');
    final routeIdController = TextEditingController(text: bus?.routeId ?? '');
    final capacityController = TextEditingController(
        text: bus?.capacity.toString() ?? '');
    final statusController = TextEditingController(text: bus?.status ?? 'active');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bus == null ? 'Add Bus' : 'Edit Bus'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: busNumberController,
                decoration: const InputDecoration(labelText: 'Bus Number'),
              ),
              TextField(
                controller: routeIdController,
                decoration: const InputDecoration(labelText: 'Route ID'),
              ),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
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
              final newBus = Bus(
                id: bus?.id ?? '',
                busNumber: busNumberController.text,
                routeId: routeIdController.text,
                capacity: int.tryParse(capacityController.text) ?? 0,
                status: statusController.text,
              );
              try {
                if (bus == null) {
                  await _busService.createBus(newBus);
                } else {
                  await _busService.updateBus(bus.id, newBus);
                }
                Navigator.pop(context);
                _loadBuses();
              } catch (e) {
                _showError('Failed to save bus');
              }
            },
            child: Text(bus == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // _deleteBus removes a bus after confirmation.
  void _deleteBus(Bus bus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bus'),
        content: Text('Are you sure you want to delete ${bus.busNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _busService.deleteBus(bus.id);
                Navigator.pop(context);
                _loadBuses();
              } catch (e) {
                _showError('Failed to delete bus');
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
        title: const Text('Buses'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buses.isEmpty
              ? const Center(child: Text('No buses found'))
              : ListView.builder(
                  itemCount: _buses.length,
                  itemBuilder: (context, index) {
                    final bus = _buses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.directions_bus,
                            color: Colors.blue),
                        title: Text(bus.busNumber),
                        subtitle: Text(
                            'Capacity: ${bus.capacity} | Status: ${bus.status}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showBusDialog(bus: bus),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteBus(bus),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBusDialog(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}