import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iot_flutter/create_data.dart';
import 'package:iot_flutter/delete_date.dart';
import 'package:iot_flutter/update_data,dart';

class DataListingPage extends StatefulWidget {
  const DataListingPage({super.key});

  @override
  State<DataListingPage> createState() => _DataListingPageState();
}

class _DataListingPageState extends State<DataListingPage> {
  List<dynamic> users = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    var headers = {
      'Content-Type': 'application/json',
      'X-CSRFToken': 'EJQ23vQ3emaFGYmdm1Emc13jYe7vuaJX',
      'Accept': 'application/json'
    };

    try {
      var request =
          http.Request('GET', Uri.parse('http://127.0.0.1:8000/read/'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print("Fetch Data Response: $responseBody");

        var data = json.decode(responseBody);
        if (data is Map<String, dynamic> && data.containsKey('users')) {
          setState(() {
            users = data['users'];
            isLoading = false;
          });
        } else if (data is List) {
          // Handle case where response is directly a list
          setState(() {
            users = data;
            isLoading = false;
          });
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Failed to load users: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Fetch Data Exception: $e");
      setState(() {
        errorMessage = "Error loading data: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchData,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : users.isEmpty
                  ? Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var user = users[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                user['username']
                                        ?.substring(0, 1)
                                        ?.toUpperCase() ??
                                    '?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(user['username'] ?? 'Unknown'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Phone: ${user['phone'] ?? 'N/A'}'),
                                Text(
                                    'Status: ${user['Status'] == true ? 'Active' : 'Inactive'}'),
                                // In your DataListingPage or wherever you're displaying the list of users
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DeleteUserPage(userData: user),
                                      ),
                                    );

                                    // If the deletion was successful, refresh the list
                                    if (result == true) {
                                      fetchData();
                                    }
                                  },
                                ),
                              ],
                            ),
                            // In your DataListingPage or wherever you're displaying the list of users
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateUserPage(userData: user),
                                ),
                              );

                              // If the update was successful, refresh the list
                              if (result == true) {
                                fetchData();
                              }
                            },

                            isThreeLine: true,
                            trailing: Text('ID: ${user['id']}'),
                          ),
                        );
                      },
                    ),
      bottomNavigationBar: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateUserPage(),
                ));
          },
          icon: Icon(Icons.add)),
    );
  }
}
