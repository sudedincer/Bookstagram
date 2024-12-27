import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser; // Current user

class AddBookScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  double rating = 0; // Initial rating value

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "Add a Book",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Book Title
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Book Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.book, color: Colors.teal),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Book title cannot be empty.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Author Name
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: "Author",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.teal),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Author name cannot be empty.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // User Note
              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Notes About the Book",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.notes, color: Colors.teal),
                ),
              ),
              SizedBox(height: 20),

              // Rating Header
              Center(
                child: Text(
                  "Rate This Book",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Rating Component
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  glow: true,
                  glowColor: Colors.amberAccent,
                  itemCount: 5,
                  itemSize: 40,
                  unratedColor: Colors.grey.shade300,
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    rating = value;
                  },
                ),
              ),
              SizedBox(height: 30),

              // Add Book Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Add book to Firebase
                     await FirebaseFirestore.instance.collection('books').add({
                        'title': titleController.text.trim(),
                        'author': authorController.text.trim(),
                        'note': noteController.text.trim(),
                        'rating': rating,
                        'userId': user?.email,
                      });


                      // Success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Book added successfully!')),
                      );

                      // Clear the form
                      titleController.clear();
                      authorController.clear();
                      noteController.clear();
                      rating = 0; // Reset the rating
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text(
                  "Add Book",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}