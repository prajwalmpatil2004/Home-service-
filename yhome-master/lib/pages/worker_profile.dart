import 'package:flutter/material.dart';
import 'package:yhome/pages/home_page.dart';
import 'package:yhome/pages/user_worker_chat_page.dart';

class WorkerProfilePage extends StatelessWidget {
  final String name;
  final String jobDescription;
  final String imageUrl;
  final double rating;
  final String phone;

  const WorkerProfilePage({
    Key? key,
    required this.name,
    required this.jobDescription,
    required this.imageUrl,
    required this.rating,
    required this.phone,
  }) : super(key: key);

  Widget _buildRatingStars(double rating, {double size = 20.0}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData icon;
        if (rating >= index + 1) {
          icon = Icons.star;
        } else if (rating > index + 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, color: Colors.orange, size: size);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.black;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Worker Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 247, 247),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            imageUrl,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 140,
                              height: 140,
                              color: Colors.grey[200],
                              child: const Icon(Icons.person,
                                  size: 70, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          jobDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildRatingStars(rating, size: 28),
                            const SizedBox(width: 12),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Phone box
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              // TODO: Implement phone call feature
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 18),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 147, 149, 150)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.phone,
                                      color: themeColor, size: 28),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      phone,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Message box
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkerChatPage(
                                    workerName: name,
                                    workerPhone: phone,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 18),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 147, 149, 150)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.message,
                                      color: themeColor, size: 28),
                                  const SizedBox(width: 20),
                                  const Expanded(
                                    child: Text(
                                      'Message',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Book Now button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              final bookedWorker = Worker(
                                name: name,
                                job: jobDescription,
                                image: imageUrl,
                                rating: rating,
                                phone: phone,
                                description: jobDescription,
                              );

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Confirm Booking'),
                                    content: Text(
                                        'Do you want to book $name for the job?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                recentBookings: [bookedWorker],
                                              ),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                        child: const Text('Confirm'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.7,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
