import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_list_tile.dart';
import 'package:socialmediaapp/helper/helper_function.dart';
import '../components/back_button.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.0, left: 25.0),
                child: MyBackButton(),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("Users").snapshots(),
              builder: (context, snapshot) {
                // Any errors
                if (snapshot.hasError) {
                  displayMessageToUser("Something went wrong", context);
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // Show loading circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Handle no data case
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data"));
                }

                // Get all users
                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    String userName = user["username"];
                    String email = user["email"];
                    return MyListTile(title: userName, subtitle: email);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
