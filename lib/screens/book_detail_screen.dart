import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final String title; // Kitap başlığı
  final String author; // Yazar
  final double rating; // Puan
  final String note; // Kullanıcı notu
  final String bookId; // Kitap ID'si

  const BookDetailScreen({
    required this.title,
    required this.author,
    required this.rating,
    required this.note,
    required this.bookId, // Kitap ID'si parametre olarak ekleniyor
    Key? key,
  }) : super(key: key);

  // Firestore'dan kitap silme fonksiyonu
  Future<void> _deleteBook(BuildContext context) async {
    try {
      // Kitap verisini silmek için doğru ID kullanılıyor
      await FirebaseFirestore.instance.collection('books').doc(bookId).delete();

      // Silme işlemi başarılı olduktan sonra kullanıcıya bilgi ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book deleted successfully')),
      );

      Navigator.of(context).pop(); // Kitap silindiğinde bir önceki ekrana dön
    } catch (e) {
      // Hata olursa ekrana yazdır
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete book: $e')),
      );
      print("Error deleting book: $e"); // Hata logunu konsola yazdır
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Title
            Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Author Name
            Row(
              children: [
                const Icon(Icons.person, color: Colors.teal, size: 24),
                const SizedBox(width: 8),
                Text(
                  "Author: $author",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, // Make author bold
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Rating
            Row(
              children: [
                const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Rating: ${rating.toStringAsFixed(1)}",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // User Notes
            if (note.trim().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Notes:",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Text(
                      note,
                      style: Theme.of(context).textTheme.bodyLarge, // Increase note text size
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Delete Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Silme işlemi için onay al
                  bool? shouldDelete = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Book',),
                        content: const Text('Are you sure you want to delete this book?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // Kullanıcı iptal etti
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // Kullanıcı sildi
                            },
                            child: const Text('Delete',),
                          ),
                        ],
                      );
                    },
                  );

                  // Eğer kullanıcı silme işlemini onayladıysa, işlemi başlat
                  if (shouldDelete == true) {
                    _deleteBook(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Delete button color
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Delete Book',style :TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}