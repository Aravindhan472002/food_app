import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class FoodItem {
  String? name;
  int quantity;
  DateTime? placementTime;
  DateTime reminderTime;

  FoodItem({this.name, required this.quantity, this.placementTime, required this.reminderTime});
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<FoodItem> _foodItems = [];
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Management '),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'userlogin') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } else if (value == 'numberoftimealert') {
                _handleNumberOfTimeAlert();
              } else if (value == 'aboutus') {
                // Handle about us action
              }
            },
            itemBuilder: (BuildContext context) {
              return {'User Login', 'Number of Time Alert', 'About Us'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase().replaceAll(' ', ''),
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add Food Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _itemNameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add Item'),
            ),
            SizedBox(height: 32),
            Text(
              'Food Items',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Column(
              children: _foodItems.map((foodItem) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailsScreen(foodItem: foodItem),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(foodItem.name ?? ''),
                      subtitle: Text('Quantity: ${foodItem.quantity}'),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                accountName: Text(
                  "Aravindhan P",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("aravindhan4722@gmail.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.green),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' My Course '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text(' Go Premium '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Saved Videos '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleNumberOfTimeAlert() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlertStatisticsPage()),
    );
  }

  void _addItem() {
    setState(() {
      String name = _itemNameController.text;
      int quantity = int.tryParse(_quantityController.text) ?? 0;

      if (name.isNotEmpty && quantity > 0) {
        _foodItems.add(FoodItem(
          name: name,
          quantity: quantity,
          reminderTime: DateTime.now(), // You can set the reminder time as needed
        ));
        _itemNameController.clear();
        _quantityController.clear();
      }
    });
  }
}

class FoodDetailsScreen extends StatefulWidget {
  final FoodItem foodItem;

  FoodDetailsScreen({required this.foodItem});

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late DateTime _placementTime = DateTime.now();
  late DateTime _reminderTime = DateTime.now(); // Added _reminderTime

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Food Item: ${widget.foodItem.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Enter Placement Details:'),
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _placementTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _placementTime) {
                  setState(() {
                    _placementTime = picked;
                  });
                }
              },
              child: Text('Select Date: ${_placementTime.toString().substring(0, 10)}'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_placementTime),
                );
                if (picked != null) {
                  setState(() {
                    _placementTime = DateTime(
                      _placementTime.year,
                      _placementTime.month,
                      _placementTime.day,
                      picked.hour,
                      picked.minute,
                    );
                  });
                }
              },
              child: Text('Select Time: ${_placementTime.toString().substring(11, 16)}'),
            ),
            SizedBox(height: 16),
            Text('Enter Reminder Details:'), // Added text
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _reminderTime, // Use _reminderTime here
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _reminderTime) {
                  setState(() {
                    _reminderTime = picked; // Update _reminderTime
                  });
                }
              },
              child: Text('Select Date: ${_reminderTime.toString().substring(0, 10)}'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_reminderTime), // Use _reminderTime here
                );
                if (picked != null) {
                  setState(() {
                    _reminderTime = DateTime(
                      _reminderTime.year,
                      _reminderTime.month,
                      _reminderTime.day,
                      picked.hour,
                      picked.minute,
                    );
                  });
                }
              },
              child: Text('Select Time: ${_reminderTime.toString().substring(11, 16)}'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Perform actions with placement and remainder details
                // You can access widget.foodItem for the food item details
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'User Login',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Implement your login logic here
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertStatisticsPage extends StatefulWidget {
  @override
  _AlertStatisticsPageState createState() => _AlertStatisticsPageState();
}

class _AlertStatisticsPageState extends State<AlertStatisticsPage> {
  int numberOfAlerts = 0;
  int correctlyStopped = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alert Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Number of Alerts: $numberOfAlerts',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Correctly Stopped: $correctlyStopped',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
