import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:to_do/auth.dart';
import 'package:to_do/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> tasks = [];
  TextEditingController taskController = TextEditingController();
  void addTask() async {
    String newTask = taskController.text.trim();
    if (newTask.isNotEmpty) {
      try {
        // Save the task to Firebase
        await FirebaseFirestore.instance.collection('tasks').add({
          'task': newTask,
          'userId': FirebaseAuth.instance.currentUser!.uid,
        });

        // Optionally, update the local list
        setState(() {
          tasks.add(newTask);
          taskController.clear(); // Clear the text field after adding the task
        });
      } catch (error) {
        print('Error adding task to Firebase: $error');
      }
    }
  }

  CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                 onPressed: () {
  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
},


                  icon: const Icon(
                    Icons.logout,
                  ),
                )
              ],
              title: Text(
                'WELCOME ${FirebaseAuth.instance.currentUser!.displayName}',
              ),
            ),
            body: Column(
              children: [
                Text(
                  'What is Your Plan for today?',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.blue,
                  ),
                ),
                // Task input field
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    hintText: 'Enter a new task',
                  ),
                ),
                // Button to add task
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('Add Task'),
                ),
                // List of tasks
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tasks[index]),
                      );
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }
}
