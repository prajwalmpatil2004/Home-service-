import 'package:animate_do/animate_do.dart';
import 'package:yhome/models/service.dart';
import 'package:yhome/pages/select_space.dart';
import 'package:flutter/material.dart';

class SelectService extends StatefulWidget {
  const SelectService({Key? key}) : super(key: key);

  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  final List<Service> services = [
    Service('Cleaning', 'assets/images/cleaning.png'),
    Service('Plumber', 'assets/images/plumbing.png'),
    Service('Electrician', 'assets/images/electrician.png'),
    Service('Painter', 'assets/images/painter.png'),
    Service('Carpenter', 'assets/images/carpenter.png'),
    Service('Gardener', 'assets/images/gardner.png'),
    Service('Tailor', 'assets/images/tailor.png'),
    Service('Maid', 'assets/images/housekeeper.png'),
    Service('Driver', 'assets/images/driver.png'),
    Service('Cook', 'assets/images/cook.png'),
  ];

  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: selectedService >= 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSpace(),
                  ),
                );
              },
              child: const Icon(Icons.arrow_forward_ios, size: 20),
              backgroundColor: Colors.blue,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FadeInUp(
                  child: Text(
                    'Which service \ndo you need?',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 * index),
                      child: _serviceContainer(
                        services[index].imageURL,
                        services[index].name,
                        index,
                      ),
                    );
                  },
                  childCount: services.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceContainer(String image, String name, int index) {
    final bool isSelected = selectedService == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService = isSelected ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 60),
            const SizedBox(height: 20),
            Text(name, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
