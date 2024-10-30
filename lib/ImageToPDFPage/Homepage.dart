import 'package:flutter/material.dart';
import 'package:image_to_pdf/ImageToPDFPage/save_share_pdf.dart';
import 'package:image_to_pdf/ImageToPDFPage/imagetopdf.dart';

class PdfHomePage extends StatelessWidget {
  const PdfHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Manager'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildGridItem(
              context,
              'Make PDF',
              'assets/pdf.png',
              const ImageToPDFPage(),
              Colors.blueAccent,
            ),
            _buildGridItem(
              context,
              'Saved PDF',
              'assets/dpdf.png',
              const PdfReaderPage(),
              Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, String imagePath,
      Widget page, Color color) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.22,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10.0, offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: color.withOpacity(0.2),
              ),
              child: Center(
                child: Image.asset(imagePath, width: 40.0, height: 40.0),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
