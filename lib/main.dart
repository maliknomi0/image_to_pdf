import 'package:flutter/material.dart';
import 'package:image_to_pdf/ImageToPDFPage/Homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PdfHomePage(),
    );
  }
}

/// 👨‍💻 Developer: Malik Nomi
/// 🌐 Connect with me:
/// 📇 LinkedIn: [Malik Nomi](https://www.linkedin.com/in/maliknomi0/)
/// 📂 GitHub: [maliknomi0](https://github.com/maliknomi0)
///
/// Passionate about building efficient, scalable software solutions and
/// continuously learning and sharing knowledge in the tech community!

