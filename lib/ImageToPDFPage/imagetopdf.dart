import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ImageToPDFPage extends StatefulWidget {
  const ImageToPDFPage({super.key});

  @override
  _ImageToPDFPageState createState() => _ImageToPDFPageState();
}

class _ImageToPDFPageState extends State<ImageToPDFPage> {
  final List<File> _selectedImages = [];
  final picker = ImagePicker();
  final _scrollController = ScrollController();

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
    });
  }

  Future<void> _captureImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _createPDF() async {
    if (_selectedImages.isEmpty) {
      _showMessage('Please select or capture at least one image');
      return;
    }

    String? pdfName = await _askForPDFName();
    if (pdfName == null || pdfName.isEmpty) return;

    final pdf = pw.Document();
    for (var imageFile in _selectedImages) {
      final image = pw.MemoryImage(imageFile.readAsBytesSync());
      pdf.addPage(pw.Page(build: (_) => pw.Center(child: pw.Image(image))));
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$pdfName.pdf");
    await file.writeAsBytes(await pdf.save());

    _showMessage('PDF saved to ${file.path}');
  }

  Future<String?> _askForPDFName() async {
    final TextEditingController textController = TextEditingController();
    String? pdfName;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Enter PDF Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Enter PDF name',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    pdfName = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: pdfName != null && pdfName!.isNotEmpty
                      ? () => Navigator.pop(context, pdfName)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image to PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _selectedImages.isEmpty ? null : _createPDF,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _selectedImages.isEmpty
                ? _buildPlaceholder() // Show placeholder when no images are selected
                : _buildImageList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.add_photo_alternate,
                  label: 'Pick Images',
                  onPressed: _pickMultipleImages,
                ),
                const SizedBox(width: 15.0),
                _buildActionButton(
                  icon: Icons.camera_alt,
                  label: 'Capture Image',
                  onPressed: _captureImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate,
              size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            'Add images to create a PDF',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 5),
          Text(
            'Tap on "Pick Images" or "Capture Image" below',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildImageList() {
    return ReorderableBuilder(
      scrollController: _scrollController,
      onReorder: (reorderList) {
        setState(() {
          _selectedImages
            ..clear()
            ..addAll(reorderList(_selectedImages.map(_buildImageCard).toList())
                .map((card) => File((card.key as ValueKey<String>).value)));
        });
      },
      builder: (children) => GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 15.0,
        crossAxisSpacing: 15.0,
        children: children,
      ),
      children: _selectedImages.map(_buildImageCard).toList(),
    );
  }

  Widget _buildImageCard(File imageFile) {
    return Card(
      key: ValueKey(imageFile.path),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      child: Stack(
        children: [
          Image.file(imageFile,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _selectedImages.remove(imageFile)),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.delete, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
