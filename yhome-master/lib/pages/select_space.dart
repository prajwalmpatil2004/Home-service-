import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yhome/pages/date_time.dart';

class Room {
  final String name;
  final String icon;
  final Color color;
  int count;

  Room({
    required this.name,
    required this.icon,
    required this.color,
    this.count = 0,
  });
}

class SelectSpace extends StatefulWidget {
  const SelectSpace({Key? key}) : super(key: key);

  @override
  _CleaningPageState createState() => _CleaningPageState();
}

class _CleaningPageState extends State<SelectSpace> {
  final List<Room> _rooms = [
    Room(
        name: 'Living Room',
        icon: 'assets/images/living-room.png',
        color: Colors.red),
    Room(
        name: 'Bedroom',
        icon: 'assets/images/bedroom.png',
        color: Colors.orange,
        count: 1),
    Room(
        name: 'Bathroom',
        icon: 'assets/images/bath.png',
        color: Colors.blue,
        count: 1),
    Room(
        name: 'Kitchen',
        icon: 'assets/images/kitchen.png',
        color: Colors.purple),
    Room(name: 'Office', icon: 'assets/images/office.png', color: Colors.green),
  ];

  final List<int> _selectedRooms = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _selectedRooms.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DateAndTime()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_selectedRooms.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
              backgroundColor: Colors.blue,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.05, bottom: screenHeight * 0.02),
                  child: Text(
                    'Where would you like the work to be done?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08, // responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
              ),
              ...List.generate(_rooms.length, (index) {
                return FadeInUp(
                  delay: Duration(milliseconds: 200 * index),
                  child: _roomItem(_rooms[index], index, screenWidth),
                );
              }),
              SizedBox(height: screenHeight * 0.1), // padding at bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _roomItem(Room room, int index, double screenWidth) {
    final bool isSelected = _selectedRooms.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedRooms.remove(index);
          } else {
            _selectedRooms.add(index);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? room.color.withValues(alpha: 0.2)
              : Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(room.icon, width: 35, height: 35),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    room.name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade100.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
              ],
            ),
            if (isSelected && room.count >= 1) ...[
              const SizedBox(height: 15),
              Text(
                "How many ${room.name}s?",
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, i) {
                    final bool isCountSelected = room.count == i + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          room.count = i + 1;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isCountSelected
                              ? room.color.withValues(alpha: 0.5)
                              : room.color.withValues(alpha: 0.2),
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
