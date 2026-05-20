import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

// BookingListScreen displays all bookings with add, edit, delete options.
class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  final BookingService _bookingService = BookingService();
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  // _loadBookings fetches all bookings from the API.
  Future<void> _loadBookings() async {
    try {
      final bookings = await _bookingService.getBookings();
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load bookings');
    }
  }

  // _showError displays an error snackbar.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // _showBookingDialog shows a dialog to add or edit a booking.
  void _showBookingDialog({Booking? booking}) {
    final userIdController =
        TextEditingController(text: booking?.userId ?? '');
    final busIdController =
        TextEditingController(text: booking?.busId ?? '');
    final seatNumberController = TextEditingController(
        text: booking?.seatNumber.toString() ?? '');
    final statusController =
        TextEditingController(text: booking?.status ?? 'pending');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(booking == null ? 'Add Booking' : 'Edit Booking'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(labelText: 'User ID'),
              ),
              TextField(
                controller: busIdController,
                decoration: const InputDecoration(labelText: 'Bus ID'),
              ),
              TextField(
                controller: seatNumberController,
                decoration: const InputDecoration(labelText: 'Seat Number'),
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
              final newBooking = Booking(
                id: booking?.id ?? '',
                userId: userIdController.text,
                busId: busIdController.text,
                seatNumber:
                    int.tryParse(seatNumberController.text) ?? 0,
                status: statusController.text,
              );
              try {
                if (booking == null) {
                  await _bookingService.createBooking(newBooking);
                } else {
                  await _bookingService.updateBooking(
                      booking.id, newBooking);
                }
                Navigator.pop(context);
                _loadBookings();
              } catch (e) {
                _showError('Failed to save booking');
              }
            },
            child: Text(booking == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // _deleteBooking removes a booking after confirmation.
  void _deleteBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Booking'),
        content: Text(
            'Are you sure you want to delete booking ${booking.id.substring(0, 8)}...?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _bookingService.deleteBooking(booking.id);
                Navigator.pop(context);
                _loadBookings();
              } catch (e) {
                _showError('Failed to delete booking');
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
        title: const Text('Bookings'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? const Center(child: Text('No bookings found'))
              : ListView.builder(
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.book_online,
                            color: Colors.orange),
                        title: Text('Seat ${booking.seatNumber}'),
                        subtitle: Text(
                            'Status: ${booking.status}\nBus: ${booking.busId.substring(0, 8)}...'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.orange),
                              onPressed: () =>
                                  _showBookingDialog(booking: booking),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () => _deleteBooking(booking),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookingDialog(),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}