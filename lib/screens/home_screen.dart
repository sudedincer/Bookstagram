import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'book_detail_screen.dart'; // BookDetailScreen sınıfının olduğu dosya

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser; // Current user
  late Stream<QuerySnapshot> booksStream; // Stream of books

  @override
  void initState() {
    super.initState();

    // Firestore'dan kitapları alacak stream'i başlatıyoruz
    booksStream = FirebaseFirestore.instance
        .collection('books')
        .where('userId', isEqualTo: user?.email)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          "My Books",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: booksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred.'));
          }

          final books = snapshot.data?.docs ?? [];

          if (books.isEmpty) {
            return const Center(child: Text('You have not added any books yet.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index].data() as Map<String, dynamic>;
              final bookId = books[index].id; // Kitap ID'sini alıyoruz
              final title = book['title'] ?? 'No Title';
              final author = book['author'] ?? 'No Author';
              final rating = book['rating'] ?? 0.0;
              final note = book['note'] ?? 'No Notes';

              return Card(
                elevation: 8,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Icon(Icons.book_outlined, color: Colors.teal, size: 40),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  subtitle: Text(
                    author,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      Text(
                        '$rating',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Kitap detay sayfasına yönlendirme yapalım
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailScreen(
                          title: title,
                          author: author,
                          rating: rating,
                          note: note,
                          bookId: bookId, // Kitap ID'sini gönderiyoruz
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}