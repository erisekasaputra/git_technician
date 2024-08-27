import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomImageUploader extends StatelessWidget {
  final File? selectedImage;
  final Function(ImageSource) onImageSourceSelected;
  final double height;
  final double borderRadius;
  final String uploadText;

  const CustomImageUploader({
    Key? key,
    required this.selectedImage,
    required this.onImageSourceSelected,
    this.height = 150,
    this.borderRadius = 10,
    this.uploadText = 'Upload here',
  }) : super(key: key);

  void showImageSourceDialog(BuildContext context) {
    final Color primary_200 = Theme.of(context).colorScheme.primary_200;
    final Color primary_50 = Theme.of(context).colorScheme.primary_50;
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Select Image Source',
              style: TextStyle(color: primary_200, fontSize: 22),
            ),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    Icon(Icons.photo_library, color: primary_300, size: 30),
                title: Text('Gallery',
                    style: TextStyle(color: primary_50, fontSize: 20)),
                onTap: () {
                  Navigator.of(context).pop();
                  onImageSourceSelected(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: primary_300, size: 30),
                title: Text('Camera',
                    style: TextStyle(color: primary_50, fontSize: 20)),
                onTap: () {
                  Navigator.of(context).pop();
                  onImageSourceSelected(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return GestureDetector(
      onTap: () => showImageSourceDialog(context),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline_outlined, size: 40),
                    Text(uploadText),
                  ],
                ),
              ),
      ),
    );
  }
}
