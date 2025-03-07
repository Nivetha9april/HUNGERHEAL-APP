import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: FoodRecipientPage()));
}

class FoodRecipientPage extends StatefulWidget {
  @override
  _FoodRecipientPageState createState() => _FoodRecipientPageState();
}

class _FoodRecipientPageState extends State<FoodRecipientPage> {
  final List<Map<String, String>> availableFood = [
    {
      "food": "Rice & Curry",
      "location": "Community Center",
      "type": "Vegetarian",
      "capacity": "Serves 3",
      "prepared": "Today 12:00 PM",
      "delivery": "Pickup",
      "provider": "John Doe",
      "organization": "Helping Hands"
    },
    {
      "food": "Bread & Soup",
      "location": "Food Bank",
      "type": "Vegan",
      "capacity": "Serves 2",
      "prepared": "Today 3:00 PM",
      "delivery": "Delivery",
      "provider": "Jane Smith",
      "organization": "Food for All"
    },
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title:
            Text("Available Food", style: TextStyle(color: Color(0xFFED254E))),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xFFED254E)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: availableFood.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                availableFood[index]["food"]!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              subtitle: Text("Location: ${availableFood[index]["location"]}",
                  style: TextStyle(color: Colors.grey[400])),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFED254E)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FoodDetailPage(foodData: availableFood[index]),
                    ),
                  );
                },
                child: Text('View', style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: "Live Location"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chatbot"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Food Detail Page
class FoodDetailPage extends StatelessWidget {
  final Map<String, String> foodData;

  FoodDetailPage({required this.foodData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title:
            Text(foodData["food"]!, style: TextStyle(color: Color(0xFFED254E))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFED254E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[700], // Grey Placeholder for Image
              child: Center(
                child: Text(
                  "Food Image",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Food Name: ${foodData["food"]}", style: foodDetailStyle),
            Text("Food Type: ${foodData["type"]}", style: foodDetailStyle),
            Text("Location: ${foodData["location"]}", style: foodDetailStyle),
            Text("Prepared Time: ${foodData["prepared"]}",
                style: foodDetailStyle),
            Text("Serves: ${foodData["capacity"]}", style: foodDetailStyle),
            Text("Delivery: ${foodData["delivery"]}", style: foodDetailStyle),
            Text("Provider: ${foodData["provider"]}", style: foodDetailStyle),
            Text("Organization: ${foodData["organization"]}",
                style: foodDetailStyle),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFED254E)),
                onPressed: () {},
                child:
                    Text("Add to Cart", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle foodDetailStyle = TextStyle(color: Colors.white, fontSize: 16);

// Profile Page with Input Boxes
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("Profile", style: TextStyle(color: Color(0xFFED254E))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFED254E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileField("Full Name"),
            ProfileField("Phone Number"),
            ProfileField("Email Address"),
            ProfileField("Current Location"),
            ProfileField("Availability (Days & Time)"),
            ProfileField("Preferred Service Area"),
            ProfileField("Mode of Transport"),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFED254E)),
                child: Text("Sign Out", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Input Field with Box
class ProfileField extends StatelessWidget {
  final String label;
  ProfileField(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[400]),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFED254E))),
          filled: true,
          fillColor: Colors.grey[900],
        ),
      ),
    );
  }
}

// Notification Page
class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title:
            Text("Notifications", style: TextStyle(color: Color(0xFFED254E))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFED254E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          NotificationItem("Your food listing was accepted."),
          NotificationItem("New donation request received."),
          NotificationItem("Reminder: Your food expires in 2 hours."),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String message;
  NotificationItem(this.message);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(message, style: TextStyle(color: Colors.white)),
    );
  }
}