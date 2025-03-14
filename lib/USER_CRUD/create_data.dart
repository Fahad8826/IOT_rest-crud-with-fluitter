import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _status = true;

  Future<void> _createUser() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'X-CSRFToken': 'EJQ23vQ3emaFGYmdm1Emc13jYe7vuaJX',
        'Accept': 'application/json'
      };

      var response = await http.post(
        Uri.parse('http://127.0.0.1:8000/create'),
        headers: headers,
        body: json.encode({
          "username": _usernameController.text,
          "phone": _phoneController.text,
          "Status": _status
        }),
      );

      if (response.statusCode == 201) {
        print("User created successfully");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User created successfully")));
        Navigator.pop(context);
      } else {
        throw Exception("Failed to create user");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to create user")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create User")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
            SwitchListTile(
              title: Text("Status"),
              value: _status,
              onChanged: (bool value) {
                setState(() {
                  _status = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createUser,
              child: Text("Create User"),
            ),
          ],
        ),
      ),
    );
  }
}
