import 'dart:async';
import 'dart:math';
import 'package:yhome/models/service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:yhome/pages/auth_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<Service> services = [
    Service('Cleaning', 'assets/images/cleaning.png'),
    Service('Plumber', 'assets/images/plumbing.png'),
    Service('Electrician', 'assets/images/electrician.png'),
    Service('Painter', 'assets/images/painter.png'),
    Service('Carpenter', 'assets/images/carpenter.png'),
    Service('Gardener', 'assets/images/gardner.png'),
    Service('Tailor', 'assets/images/tailor.png'),
    Service('Maid', 'assets/images/housekeeper.png'),
    Service('Driver', 'assets/images/driver.png'),
  ];

  int selectedService = 4;
  Timer? _timer; // Timer reference

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!mounted) return; // check if widget is still in tree
      setState(() {
        selectedService = Random().nextInt(services.length);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // cancel timer on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              padding:
                  EdgeInsets.only(bottom: 200), // space for floating bottom
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Service Grid
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: min(screenHeight * 0.5, 400),
                    width: double.infinity,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FadeInUp(
                          delay: Duration(milliseconds: index * 100),
                          child: serviceContainer(
                            services[index].imageURL,
                            services[index].name,
                            index,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Floating bottom container
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: screenHeight * 0.6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Center(
                            child: Text(
                              'Easy, reliable way to take \ncare of your home',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeInUp(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Center(
                            child: Text(
                              'We provide you with the best people to help take care of your home.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Floating Get Started button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: MaterialButton(
                          elevation: 5,
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AuthPage(), // ✅ go to AuthPage
                              ),
                            );
                          },
                          height: 55,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedService == index ? Colors.white : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index
                ? Colors.blue.shade100
                : Colors.grey.withAlpha(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(image, height: 30),
            SizedBox(height: 10),
            Text(name, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
