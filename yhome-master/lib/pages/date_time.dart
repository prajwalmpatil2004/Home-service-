import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';
import 'package:yhome/pages/near_workers_list.dart';

class DateAndTime extends StatefulWidget {
  const DateAndTime({Key? key}) : super(key: key);

  @override
  _DateAndTimeState createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateAndTime> {
  DateTime? _selectedDate;
  int _selectedRepeat = 0;
  String? _selectedHour; // make it nullable
  /*List<int> _selectedExteraCleaning = [];*/

  final ItemScrollController _scrollController = ItemScrollController();

  final List<String> _hours = [
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30',
  ];

  final List<String> _repeat = [
    'No repeat',
    'Every day',
    'Every week',
    'Every month'
  ];

  /*

  // Keeping your extra cleaning list, but will comment UI
  final List<List<String>> _exteraCleaning = [
    ['Washing', 'https://img.icons8.com/office/2x/washing-machine.png', '750'],
    ['Fridge', 'https://img.icons8.com/cotton/2x/fridge.png', '800'],
    [
      'Oven',
      'https://img.icons8.com/external-becris-lineal-color-becris/2x/external-oven-kitchen-cooking-becris-lineal-color-becris.png',
      '900'
    ],
    [
      'Vehicle',
      'https://img.icons8.com/external-vitaliy-gorbachev-blue-vitaly-gorbachev/2x/external-bycicle-carnival-vitaliy-gorbachev-blue-vitaly-gorbachev.png',
      '1150'
    ],
    [
      'Windows',
      'https://img.icons8.com/external-kiranshastry-lineal-color-kiranshastry/2x/external-window-interiors-kiranshastry-lineal-color-kiranshastry-1.png',
      '500'
    ],
  ];*/

  @override
  void initState() {
    super.initState();
  }

  void _goNextPage() {
    if (_selectedDate == null || _selectedHour == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both date and time")),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NearbyWorkersPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _goNextPage,
        child: Icon(Icons.arrow_forward_ios),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: FadeInUp(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 24.0, left: 20, right: 20, bottom: 10),
                  child: Text(
                    'Select Date and Time',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Select Date
                FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Date",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                            builder: (context, child) => Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                  ),
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                                width: 1.5, color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? "Tap to select a date"
                                      : "Selected: ${DateFormat.yMMMMd().format(_selectedDate!)}",
                                  style: TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.calendar_today,
                                  color: Colors.grey.shade700),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Select Time (Hours)
                FadeInUp(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border:
                          Border.all(width: 1.5, color: Colors.grey.shade200),
                    ),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _hours.length,
                      itemBuilder: (context, index) {
                        final hour = _hours[index];
                        final isSelected = hour == _selectedHour;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedHour = hour;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 100,
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: isSelected
                                  ? Colors.orange.shade100
                                      .withValues(alpha: 0.5)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              hour,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Repeat Options
                FadeInUp(
                  child: Text(
                    "Repeat",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _repeat.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedRepeat;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRepeat = index;
                          });
                        },
                        child: FadeInUp(
                          delay: Duration(milliseconds: 300 * index),
                          child: Container(
                            margin: EdgeInsets.only(right: 16),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: isSelected
                                  ? Colors.blue.shade400
                                  : Colors.grey.shade100,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _repeat[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // -------------------
                // Extra Cleaning Section (commented out)
                // -------------------
                /*
                FadeInUp(
                  child: Text(
                    "Additional Cleaning or Service",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _exteraCleaning.length,
                    itemBuilder: (context, index) {
                      final isSelected =
                          _selectedExteraCleaning.contains(index);
                      final cleaning = _exteraCleaning[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedExteraCleaning.remove(index);
                            } else {
                              _selectedExteraCleaning.add(index);
                            }
                          });
                        },
                        child: FadeInUp(
                          delay: Duration(milliseconds: 300 * index),
                          child: Container(
                            width: 110,
                            margin: EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: isSelected
                                  ? Colors.blue.shade400
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.blue.shade200
                                            .withValues(alpha: 0.5),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(cleaning[1],
                                    height: 40,
                                    color: isSelected ? Colors.white : null),
                                const SizedBox(height: 10),
                                Text(
                                  cleaning[0],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "+ ₹${cleaning[2]}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
