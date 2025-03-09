import 'package:flutter/material.dart';
//import 'dart:math';
import 'moving_vehicle.dart';

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
      "location": "Avadi",
      "type": "Vegetarian",
      "capacity": "Serves 3",
      "prepared": "Today 12:00 PM",
      "delivery": "Pickup",
      "provider": "John Doe",
      "organization": "Helping Hands"
    },
    {
      "food": "Bread & Soup",
      "location": "Porur",
      "type": "Vegan",
      "capacity": "Serves 2",
      "prepared": "Today 3:00 PM",
      "delivery": "Delivery",
      "provider": "Jane Smith",
      "organization": "Food for All"
    },
    {
      "food": "Briyani,chicken 65,mutton gravy",
      "location": "Pallavaram",
      "type": "Vegan",
      "capacity": "Serves 2",
      "prepared": "Today 3:00 PM",
      "delivery": "Delivery",
      "provider": "Jane Smith",
      "organization": "Food for one"
    },


  ];

  List<Map<String, String>> recommendedFood = [];
  List<Map<String, String>> justInFood = [];
  Map<String, String>? selectedItem;

  @override
  void initState() {
    super.initState();
    _generateRecommendations();
  }

  void _generateRecommendations() {
    recommendedFood = availableFood.where((food) => food["type"] == "Vegan").toList();
    justInFood = availableFood.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("Available Food", style: TextStyle(color: Color(0xFFED254E))),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xFFED254E)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          _buildSection("Just In", justInFood),
          _buildSection("Recommended for You", recommendedFood),
          if (selectedItem != null) _buildFinalDetails(selectedItem!),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> foodList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Color(0xFFED254E), fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: foodList.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.grey[900],
              margin: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(
                  foodList[index]["food"]!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text("Location: ${foodList[index]["location"]}", style: TextStyle(color: Colors.grey[400])),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFED254E)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(
                          foodData: foodList[index],
                          onAddToCart: (selected) {
                            setState(() {
                              selectedItem = selected;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('View', style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFinalDetails(Map<String, String> food) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Final Selection", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Food: ${food["food"]}", style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("Location: ${food["location"]}", style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("Provider: ${food["provider"]}", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFED254E)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovingVehicleMap(orderDetails: food)),
                );
              },
              child: Text("Proceed", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// Food Detail Page
class FoodDetailPage extends StatelessWidget {
  final Map<String, String> foodData;
  final Function(Map<String, String>) onAddToCart;

  FoodDetailPage({required this.foodData, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(foodData["food"]!, style: TextStyle(color: Color(0xFFED254E))),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Food Name: ${foodData["food"]}", style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("Food Type: ${foodData["type"]}", style: TextStyle(color: Colors.white, fontSize: 16)),
            Text("Location: ${foodData["location"]}", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFED254E)),
                onPressed: () {
                  onAddToCart(foodData);
                  Navigator.pop(context);
                },
                child: Text("Add to Cart", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
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
