import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteUserPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DeleteUserPage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  bool _isLoading = false;

  Future<void> _deleteUser() async {
    setState(() => _isLoading = true);

    try {
      var response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/delete/${widget.userData['id']}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User deleted successfully')),
        );
        Navigator.pop(context, true);
      } else {
        _showError('Failed to delete user');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      _showError('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete User'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Warning message
            Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: Icon(Icons.warning, color: Colors.red),
                title: Text('Are you sure you want to delete this user?'),
                subtitle: Text('This action cannot be undone.'),
              ),
            ),
            SizedBox(height: 16),

            // User info
            ListTile(
              title: Text(widget.userData['username']),
              subtitle: Text(widget.userData['phone']),
              trailing: Text(widget.userData['Status'] ? 'Active' : 'Inactive'),
            ),

            Spacer(),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _deleteUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Delete User'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
