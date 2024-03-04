import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointment UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        textTheme: GoogleFonts.lexendTextTheme(),
      ),
      home: AppointmentScreen(),
    );
  }
}

class HeaderBar extends StatefulWidget {
  @override
  _HeaderBarState createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _weekDays = _generateWeekDays(_selectedDate);

  List<DateTime> _generateWeekDays(DateTime date) {
    return List.generate(6, (index) => date.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 35, bottom: 15, left:20, right:20), // Adjust the padding value as needed
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${DateFormat.yMMMM().format(_selectedDate)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // You can add more widgets here if you want them to be in a column
                ],
              ),
              Spacer(), // Use Spacer to push the rest to the end of the row
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2), // Background color of the container
                  borderRadius: BorderRadius.all(Radius.circular(20)), // Adjust for more roundness
                ),
                child: Text(
                  '+\$200',
                  style: TextStyle(color: Color.fromARGB(255, 9, 116, 14), fontWeight: FontWeight.bold),
                ),
              )
              // You can add more widgets here if you want them to be in the row
            ],
          ),
        ),
      

        Row(
          children: <Widget>[
            // Flexible widget with a flex factor for the first column
            Flexible(
              flex: 6, // Adjust the flex factor to change the width ratio
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 0; i < _weekDays.length; i++)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(DateFormat.E().format(_weekDays[i])[0]), // Week day (e.g., Mon, Tue)
                  ),
                ),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 0; i < _weekDays.length; i++)
              Expanded(
                child: DateCircle(
                  day: _weekDays[i].day.toString(),
                  isSelected: _weekDays[i].day == _selectedDate.day, // Highlight if it's the selected day
                ),
              ),
          ],
        ),
                ],
              ),
            ),
            // Flexible widget with a flex factor for the second column
            Flexible(
              flex: 1, // Adjust the flex factor to change the width ratio
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Circular shape
                      border: Border.all(
                        color: Colors.grey, // Grey color for the border
                        width: 1.0, // Border width
                      ),
                    ),
                    padding: EdgeInsets.all(0),
                  
                  child: IconButton(
                    iconSize: 22,
                    icon: Icon(Icons.calendar_month_outlined, color: Colors.black),
                    onPressed: () async {
                      // The first date to show when the picker is displayed
                      final DateTime initialDate = DateTime.now();

                      // The earliest date the user is permitted to pick
                      final DateTime firstDate = DateTime(initialDate.year - 5);

                      // The latest date the user is permitted to pick
                      final DateTime lastDate = DateTime(initialDate.year + 5);

                      // Show the date picker dialog
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );

                      // If the user selected a date, do something with it
                      if (pickedDate != null) {
                        // Use setState to update the UI if necessary
                        // For example:
                        setState(() {
                          _selectedDate = pickedDate;
                          _weekDays = _generateWeekDays(_selectedDate);
                        });
                      }
                    },
                  ),
                  ),
                ],
              ),
            ),
          ],
        )

        //SizedBox(height: 8), // Provide space between the text and date row
        
      ],
    );
  }
}

class DateCircle extends StatelessWidget {
  final String day;
  final bool isSelected;

  const DateCircle({
    Key? key,
    required this.day,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AppointmentCard extends StatefulWidget {
  final String startTime;
  final String endTime;
  final String duration;

  AppointmentCard({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.duration,
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child:Padding(
            padding: const EdgeInsets.only(top: 15, left:20, right:20), 
            child: Row(
              children: [
                if (_isTapped) ...[
                  Container(
                    height: 10.0, // Height of the dot
                    width: 10.0, // Width of the dot
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 9, 116, 14), // Color of the dot
                      shape: BoxShape.circle, // Makes the container circular
                    ),
                  ),
                  SizedBox(width: 8.0),
                ],
                Text(
                  widget.startTime,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isTapped ? Color.fromARGB(255, 9, 116, 14): Colors.black,
                  ),
                ),
                VerticalDivider(
                  width: 20, // This can be adjusted to control space between the items
                  color: Colors.transparent, // Can be Colors.grey to visualize the divider for debugging
                ),
                Spacer(), 
                Text(
                  widget.duration,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              setState(() {
                _isTapped = !_isTapped;
              });
            },
            child: Container(
              width: double.infinity, // This ensures the card stretches to the full width available
              decoration: BoxDecoration(
                color: _isTapped ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                        color: Colors.grey, // Grey color for the border
                        width: 1.0, // Border width
                      ),
                
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Service(s) here',
                    style: TextStyle(
                      color: _isTapped ? Colors.white : Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: _isTapped ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${widget.startTime} - ${widget.endTime}',
                    style: TextStyle(
                      color: _isTapped ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class AppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example list of appointment times.
    final List<Map<String, dynamic>> appointments = [
      {
        'startTime': '9:00 AM',
        'endTime': '10:45 AM',
        'duration': '1h 45min',
      },
      {
        'startTime': '11:00 AM',
        'endTime': '11:30 AM',
        'duration': '30min',
      },
      {
        'startTime': '2:05 PM',
        'endTime': '2:30 PM',
        'duration': '25min',
      },
      {
        'startTime': '4:00 PM',
        'endTime': '6:30 PM',
        'duration': '2h 30min',
      },
      // Add more appointments as needed.
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        //title: Text('February 2024'),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // Remove shadow
          flexibleSpace: HeaderBar(), // Use HeaderBar as the flexibleSpace
        ),
      ),
      
      body: ListView(
        
        children: <Widget>[
          
          Container(
            width: double.infinity, // ensures the container fills the width available
            height: 1.0, // height of the line, can be adjusted to desired thickness
            color: Colors.grey, // color of the line
          ),
          ListView.builder(
          shrinkWrap: true,
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            return AppointmentCard(
              startTime: appointments[index]['startTime'],
              endTime: appointments[index]['endTime'],
              duration: appointments[index]['duration'],
            );
          },
        ),
          // Add your appointment widgets here
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        //currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Selected item color in black
        unselectedItemColor: Colors.black, // Unselected items in black
        //onTap: (){},
        showUnselectedLabels: true, // This ensures that labels are always shown
      ),
      floatingActionButton: InkWell(
      onTap: () {
        // Add your onPressed code here
      },
      
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      //shape: BoxShape.circle,
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
