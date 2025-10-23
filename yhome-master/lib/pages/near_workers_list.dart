import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:yhome/pages/date_time.dart';
import 'package:yhome/pages/worker_profile.dart';

// Worker model (optional but good for booking)
class Worker {
  final String name;
  final String job;
  final String image;
  final double rating;
  final String phone;
  final String description;

  Worker({
    required this.name,
    required this.job,
    required this.image,
    required this.rating,
    required this.phone,
    required this.description,
  });
}

class NearbyWorkersPage extends StatefulWidget {
  const NearbyWorkersPage({super.key});

  @override
  State<NearbyWorkersPage> createState() => _NearbyWorkersPageState();
}

class _NearbyWorkersPageState extends State<NearbyWorkersPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Worker card UI
  Widget _buildWorkerCard(BuildContext context, Map<String, dynamic> worker) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkerProfilePage(
                  name: worker['name'] ?? "Unknown",
                  jobDescription: worker['description'] ?? "No description",
                  imageUrl: worker['image'] ?? "",
                  rating: (worker['rating'] ?? 0).toDouble(),
                  phone: worker['phone'] ?? "Not available",
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Worker image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    worker['image'] ?? '',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.person,
                          size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 18),

                // Worker details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        worker['job'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            (worker['rating'] ?? 0).toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(100, 36),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkerProfilePage(
                              name: worker['name'] ?? "Unknown",
                              jobDescription: worker['description'] ??
                                  "No description available",
                              imageUrl: worker['image'] ?? "",
                              rating: (worker['rating'] ?? 0).toDouble(),
                              phone: worker['phone'] ?? "Not available",
                            ),
                          ),
                        );
                      },
                      child: const Text('Profile',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(100, 36),
                      ),
                      onPressed: () => _showBookingDialog(context, worker),
                      child: const Text('Book Now',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Booking dialog
  // Booking dialog
  Future<void> _showBookingDialog(
      BuildContext context, Map<String, dynamic> worker) async {
    final booked = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Booking',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Do you want to book ${worker['name'] ?? "this worker"} for the service?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (booked == true) {
      // ✅ Save booking to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookings')
            .add({
          'workerId': worker['id'] ?? '', // if you stored worker document ID
          'name': worker['name'],
          'job': worker['job'],
          'image': worker['image'],
          'rating': worker['rating'],
          'phone': worker['phone'],
          'description': worker['description'],
          'bookedAt': FieldValue.serverTimestamp(), // 👈 important for ordering
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service booked successfully!')),
      );

      await Future.delayed(const Duration(seconds: 1));

      // Navigate back to HomePage (safe)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DateAndTime()),
            );
          },
        ),
        title:
            const Text('Nearby Workers', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('workers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No workers available"));
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final worker = docs[index].data() as Map<String, dynamic>;
              return FadeTransition(
                opacity: _controller,
                child: _buildWorkerCard(context, worker),
              );
            },
          );
        },
      ),
    );
  }
}
