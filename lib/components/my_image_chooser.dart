import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyImageChooser extends StatefulWidget {
  const MyImageChooser({super.key});

  @override
  _ProfilePictureComponentState createState() => _ProfilePictureComponentState();
}

class _ProfilePictureComponentState extends State<MyImageChooser> {
  File? _selectedImage; // Variable to hold the selected image

  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Set the selected image
      });
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Set the selected image
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Profile Picture'),
          content: const Text('Would you like to pick from the gallery or take a new picture?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _pickImage();
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                _takePicture();
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _showImageSourceDialog(context), // Show dialog on tap
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
              image: _selectedImage != null
                  ? DecorationImage(
                image: FileImage(_selectedImage!),
                fit: BoxFit.cover,
              )
                  : null, // Show the selected image or nothing
            ),
            child: _selectedImage == null
                ? const Icon(
              Icons.camera_alt,
              color: Colors.grey,
              size: 60,
            )
                : null, // Only show icon if no image is selected
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
