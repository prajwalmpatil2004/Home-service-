import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yhome/models/service.dart';
import 'package:yhome/pages/login_page.dart';
import 'package:yhome/pages/select_service.dart';
import 'package:yhome/pages/user_profile_page.dart';
import 'package:yhome/pages/worker_profile.dart';
import 'package:flutter/material.dart';
import 'package:yhome/pages/inbox_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'job': job,
      'image': image,
      'rating': rating,
      'phone': phone,
      'description': description,
    };
  }

  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      name: map['name'] ?? '',
      job: map['job'] ?? '',
      image: map['image'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      phone: map['phone'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Worker>? recentBookings;

  const HomePage({Key? key, this.recentBookings}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Service> services = [
    Service('Cleaning', 'assets/images/cleaning.png'),
    Service('Plumber', 'assets/images/plumbing.png'),
    Service('Electrician', 'assets/images/electrician.png'),
    Service('Painter', 'assets/images/painter.png'),
    Service('Carpenter', 'assets/images/carpenter.png'),
    Service('Gardener', 'assets/images/gardner.png'),
  ];
  String? username;

  // Dashboard state and animation controller
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _loadUsername();
  }

  void _toggleDashboard() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Dashboard', style: TextStyle(color: Colors.black)),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InboxPage()),
              );
            },
            icon: Icon(Icons.notifications_none,
                color: Colors.grey.shade700, size: 30),
          )
        ],
        leading: GestureDetector(
          onTap: _toggleDashboard,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.person, color: Colors.black),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 10) {
            _controller.forward();
          } else if (details.delta.dx < -10) {
            _controller.reverse();
          }
        },
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: _controller.isCompleted,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    _buildRecentSection(),
                    _buildCategoriesSection(),
                    _buildSelectCategoryButton(context),
                    _buildTopRatedAndNearbySection(),
                    SizedBox(height: 150),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return _controller.value > 0
                    ? GestureDetector(
                        onTap: _toggleDashboard,
                        child: Container(
                          color: Colors.black
                              .withValues(alpha: _controller.value * 0.3),
                        ),
                      )
                    : SizedBox.shrink();
              },
            ),
            SlideTransition(
              position: _slideAnimation,
              child: _buildDashboardPanel(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Dashboard ----------------
  Widget _buildDashboardPanel() {
    return Container(
      width: 250,
      height: double.infinity,
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, ${username ?? FirebaseAuth.instance.currentUser?.email ?? 'User'}!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage()),
              );
            },
            icon: Icon(Icons.person, color: Colors.white),
            label: Text("Profile", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.settings, color: Colors.white),
            label: Text("Settings", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Confirm Logout"),
                    content: Text("Do you really want to log out?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("No")),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Yes")),
                    ],
                  );
                },
              );
              if (shouldLogout == true) {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => LoginPage(showRegisterPage: () {})),
                );
              }
            },
            icon: Icon(Icons.logout, color: Colors.white),
            label: Text("Logout", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: _toggleDashboard,
            child: Row(
              children: [
                Icon(Icons.close, color: Colors.black),
                SizedBox(width: 10),
                Text("Close", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Recent Section ----------------
  Widget _buildRecentSection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return SizedBox.shrink(); // Not logged in
    }

    return FadeInUp(
      child: Padding(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: Text('View all')),
              ],
            ),
            SizedBox(
              height: 180,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('bookings')
                    .orderBy('bookedAt', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No recent bookings yet"));
                  }

                  final workers = snapshot.data!.docs
                      .map((doc) =>
                          Worker.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();

                  return PageView.builder(
                    controller: PageController(viewportFraction: 0.92),
                    itemCount: workers.length,
                    itemBuilder: (context, i) => _recentProfileCard(workers[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentProfileCard(Worker w) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade50, offset: Offset(0, 4), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(w.image,
                  width: 70, height: 70, fit: BoxFit.cover),
            ),
            SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(w.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 5),
              Text(w.job,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withValues(alpha: 0.7))),
            ])
          ]),
          SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkerProfilePage(
                      name: w.name,
                      jobDescription: w.description,
                      imageUrl: w.image,
                      rating: w.rating,
                      phone: w.phone,
                    ),
                  ),
                );
              },
              child: Text("View Profile",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }

  // ---------------- Categories ----------------
  Widget _buildCategoriesSection() {
    return FadeInUp(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: Text("View all"))
          ]),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: 500 * index),
                  child: serviceContainer(
                      services[index].imageURL, services[index].name, index),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  Widget serviceContainer(String image, String name, int index) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(image, height: 45),
          SizedBox(height: 15),
          Text(name, style: TextStyle(fontSize: 15))
        ]),
      ),
    );
  }

  // ---------------- Top Rated + Nearby ----------------
  Widget _buildTopRatedAndNearbySection() {
    return FadeInUp(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SizedBox(
          height: 250,
          child: PageView(
            controller: PageController(viewportFraction: 0.9),
            children: [
              _workerListPage("Top Rated", orderBy: "rating", descending: true),
              _workerListPage("Nearby Workers"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workerListPage(String title,
      {String orderBy = "name", bool descending = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('workers')
                .orderBy(orderBy, descending: descending)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No workers yet"));
              }
              final workers = snapshot.data!.docs
                  .map((doc) =>
                      Worker.fromMap(doc.data() as Map<String, dynamic>))
                  .toList();
              return ListView.builder(
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  final w = workers[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkerProfilePage(
                              name: w.name,
                              jobDescription: w.description,
                              imageUrl: w.image,
                              rating: w.rating,
                              phone: w.phone,
                            ),
                          ),
                        );
                      },
                      child: workerContainer(w.name, w.job, w.image, w.rating),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget workerContainer(String name, String job, String image, double rating) {
    return Container(
      margin: EdgeInsets.only(right: 15, bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(image, width: 70, height: 70, fit: BoxFit.cover),
        ),
        SizedBox(width: 15),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(job, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ]),
        ),
        Row(children: [
          Icon(Icons.star, color: Colors.orange, size: 20),
          SizedBox(width: 5),
          Text(rating.toString(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ])
      ]),
    );
  }

  Widget _buildSelectCategoryButton(BuildContext context) {
    return FadeInUp(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectService()),
              );
            },
            icon: Icon(Icons.filter_list, color: Colors.white),
            label: Text('Select Category'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15.0),
              textStyle: TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        setState(() {
          username = data?['username'] ?? user.email?.split('@')[0] ?? "User";
        });
      }
    }
  }
}
