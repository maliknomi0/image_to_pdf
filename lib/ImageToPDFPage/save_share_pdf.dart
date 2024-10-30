import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfReaderPage extends StatefulWidget {
  const PdfReaderPage({super.key});

  @override
  _PdfReaderPageState createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage>
    with SingleTickerProviderStateMixin {
  List<File> _pdfFiles = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  Future<void> _loadPdfFiles() async {
    final dir = await getTemporaryDirectory();
    final pdfFiles = dir
        .listSync()
        .where((file) => file.path.endsWith('.pdf'))
        .map((file) => File(file.path))
        .toList();

    setState(() {
      _pdfFiles = pdfFiles;
    });
  }

  void _openPDF(File file) {
    OpenFile.open(file.path);
  }

  void _sharePDF(File file) {
    Share.shareXFiles([XFile(file.path)], text: 'Check out this PDF!');
  }

  void _deletePDF(File file) {
    file.delete();
    setState(() {
      _pdfFiles.remove(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved PDFs'),
      ),
      body: FadeTransition(
        opacity: _animationController,
        child: _pdfFiles.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf,
                        size: 100, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    Text(
                      'No PDFs found',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _pdfFiles.length,
                itemBuilder: (context, index) {
                  final file = _pdfFiles[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      color: Colors.grey.shade100,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.shade100,
                          child: const Icon(Icons.picture_as_pdf,
                              color: Colors.redAccent),
                        ),
                        title: Text(
                          file.path.split('/').last,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        subtitle: Text(
                          'PDF Document',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share,
                                  color: Colors.blueAccent),
                              onPressed: () => _sharePDF(file),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () => _deletePDF(file),
                            ),
                          ],
                        ),
                        onTap: () => _openPDF(file),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
