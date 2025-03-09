import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodProviderPage extends StatefulWidget {
  @override
  _FoodProviderPageState createState() => _FoodProviderPageState();
}

class _FoodProviderPageState extends State<FoodProviderPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  // Food listing fields
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _foodTypeController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _pickupLocationController = TextEditingController();
  
  bool _isEditing = false; // Toggle Edit Mode
  String _role = ""; // User role (donors/recipients/volunteers)
  String userId = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> pastActivities = []; // Stores past donations/receipts/volunteering

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // 🔍 Check in 'donors' collection
      DocumentSnapshot donorDoc = await firestore.collection('donors').doc(userId).get();
      if (donorDoc.exists) {
        setState(() {
          _nameController.text = donorDoc['name'] ?? "";
          _emailController.text = donorDoc['email'] ?? "";
          _phoneController.text = donorDoc['phone'] ?? "";
          _role = "donors";
        });
        fetchPastDonations();
        return;
      }

      // 🔍 Check in 'recipients' collection
      DocumentSnapshot recipientDoc = await firestore.collection('recipients').doc(userId).get();
      if (recipientDoc.exists) {
        setState(() {
          _nameController.text = recipientDoc['name'] ?? "";
          _emailController.text = recipientDoc['email'] ?? "";
          _phoneController.text = recipientDoc['phone'] ?? "";
          _role = "recipients";
        });
        fetchPastReceivedFood();
        return;
      }

      // 🔍 Check in 'volunteers' collection
      DocumentSnapshot volunteerDoc = await firestore.collection('volunteers').doc(userId).get();
      if (volunteerDoc.exists) {
        setState(() {
          _nameController.text = volunteerDoc['name'] ?? "";
          _emailController.text = volunteerDoc['email'] ?? "";
          _phoneController.text = volunteerDoc['phone'] ?? "";
          _role = "volunteers";
        });
        fetchVolunteerActivities();
        return;
      }
    }
  }

  // 🔥 Fetch past donations (For Donors)
  Future<void> fetchPastDonations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot donationSnapshot = await firestore
        .collection('donations')
        .where('donorId', isEqualTo: userId)
        .get();

    setState(() {
      pastActivities = donationSnapshot.docs.map((doc) {
        return {
          'title': doc['foodName'],
          'date': doc['donationDate'],
        };
      }).toList();
    });
  }

  // 🔥 Fetch past received food (For Recipients)
  Future<void> fetchPastReceivedFood() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot receivedSnapshot = await firestore
        .collection('received_food')
        .where('recipientId', isEqualTo: userId)
        .get();

    setState(() {
      pastActivities = receivedSnapshot.docs.map((doc) {
        return {
          'title': doc['foodName'],
          'date': doc['receivedDate'],
        };
      }).toList();
    });
  }

  // 🔥 Fetch past volunteer activities (For Volunteers)
  Future<void> fetchVolunteerActivities() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot volunteerSnapshot = await firestore
        .collection('volunteer_activities')
        .where('volunteerId', isEqualTo: userId)
        .get();

    setState(() {
      pastActivities = volunteerSnapshot.docs.map((doc) {
        return {
          'title': doc['activityName'],
          'date': doc['activityDate'],
        };
      }).toList();
    });
  }

  // ✅ Store Food Listing in Firestore
  Future<void> addFoodListing() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('donations').add({
      'donorId': userId,
      'foodName': _foodNameController.text,
      'foodType': _foodTypeController.text,
      'expiryDate': _expiryDateController.text,
      'quantity': _quantityController.text,
      'pickupLocation': _pickupLocationController.text,
      'donationDate': DateTime.now().toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Food listing added successfully!")),
    );

    // Clear input fields
    _foodNameController.clear();
    _foodTypeController.clear();
    _expiryDateController.clear();
    _quantityController.clear();
    _pickupLocationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile & Food Listings"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📝 User Profile Section
              Text("User Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              TextField(controller: _nameController, style: TextStyle(color: Colors.white),decoration: InputDecoration(labelText: "Full Name"), enabled: _isEditing),
              TextField(controller: _emailController,style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Email"), enabled: false),
              TextField(controller: _phoneController,style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Phone Number"), enabled: _isEditing),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_isEditing) {
                    fetchUserData();
                  }
                  setState(() => _isEditing = !_isEditing);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: Text(_isEditing ? "Save Changes" : "Edit Profile"),
              ),
              SizedBox(height: 20),

              // 🛠 Add Food Listing Section
              Text("Role: $_role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Add Food Listing", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextField(controller: _foodNameController, style: TextStyle(color: Colors.white),decoration: InputDecoration(labelText: "Food Name")),
              TextField(controller: _foodTypeController,style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Food Type")),
              TextField(controller: _expiryDateController,style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Expiry Date")),
              TextField(controller: _quantityController, style: TextStyle(color: Colors.white),decoration: InputDecoration(labelText: "Quantity")),
              TextField(controller: _pickupLocationController, style: TextStyle(color: Colors.white),decoration: InputDecoration(labelText: "Pickup Location")),
              SizedBox(height: 10),
              ElevatedButton(onPressed: addFoodListing, child: Text("Submit Food Listing")),

              SizedBox(height: 20),

              // 📌 Past Activities Section
              Text("Past Activities", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              pastActivities.isEmpty
                  ? Center(child: Text("No past activities found"))
                  : Column(
                      children: pastActivities.map((activity) => ListTile(
                        title: Text(activity['title'], style: TextStyle(color: Colors.white)),
                        subtitle: Text("Date: ${activity['date']}", style: TextStyle(color: Colors.white)),
                      )).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}