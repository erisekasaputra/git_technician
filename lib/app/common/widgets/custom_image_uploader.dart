import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:santai_technician/app/data/models/common/base_error.dart';
import 'package:santai_technician/app/theme/app_theme.dart';

class CustomImageUploader extends StatelessWidget {
  final File? selectedImage;
  final String? selectedImageUrl;
  final Function(ImageSource) onImageSourceSelected;
  final double height;
  final double borderRadius;
  final bool isLoading;
  final String fieldName;
  final Rx<ErrorResponse?> error;

  const CustomImageUploader({
    super.key,
    this.selectedImage,
    this.selectedImageUrl,
    required this.onImageSourceSelected,
    this.height = 150,
    this.borderRadius = 10,
    this.isLoading = false,
    required this.fieldName,
    required this.error,
  });

  void showImageSourceDialog(BuildContext context) {
    final Color primary_300 = Theme.of(context).colorScheme.primary_300;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          elevation: 5,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Image Source',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primary_300, // Primary color
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 20),
                _buildListTile(
                  icon: Icons.photo_library,
                  title: 'Gallery',
                  onTap: () {
                    Navigator.of(context).pop();
                    onImageSourceSelected(ImageSource.gallery);
                  },
                ),
                _buildListTile(
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  onTap: () {
                    Navigator.of(context).pop();
                    onImageSourceSelected(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon,
          color: const Color(0xFF818898), size: 30), // Custom icon color
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w500, // Lighter text style
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.borderInput_01;

    return Column(
      children: [
        GestureDetector(
          onTap: () => showImageSourceDialog(context),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: _buildImageContent(),
          ),
        ),
        if (error.value != null && error.value!.errors != null) ...[
          const SizedBox(height: 5),
          for (var error in error.value!.errors!) ...[
            if (error.propertyName
                .toLowerCase()
                .contains(fieldName.toLowerCase())) ...[
              Row(
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 12,
                  ),
                  const SizedBox(width: 5), // Space between icon and text
                  Expanded(
                    child: Text(
                      error.errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ]
          ]
        ],
        if (error.value != null && error.value!.validationErrors != null) ...[
          const SizedBox(height: 5),
          for (var entry in error.value!.validationErrors!.entries) ...[
            if (entry.key.toLowerCase().contains(fieldName.toLowerCase())) ...[
              for (var errorMessage in entry.value) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 5), // Space between icon and text
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ]
            ]
          ]
        ],
      ],
    );
  }

  // Widget _buildImageContent() {
  //   if (selectedImage != null) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(borderRadius),
  //       child: Image.file(
  //         selectedImage!,
  //         fit: BoxFit.cover,
  //         width: double.infinity,
  //       ),
  //     );
  //   } else if (selectedImageUrl != null && selectedImageUrl!.isNotEmpty) {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(borderRadius),
  //       child: Image.network(
  //         selectedImageUrl!,
  //         fit: BoxFit.cover,
  //         width: double.infinity,
  //         loadingBuilder: (context, child, loadingProgress) {
  //           if (loadingProgress == null) return child;
  //           return const Center(child: CircularProgressIndicator());
  //         },
  //         errorBuilder: (context, error, stackTrace) {
  //           return const Center(child: Icon(Icons.error));
  //         },
  //       ),
  //     );
  //   } else {
  //     return const Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.add_circle_outline_outlined, size: 40),
  //           Text('Upload here'),
  //         ],
  //       ),
  //     );
  //   }
  // }

  Widget _buildImageContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    } else if (selectedImageUrl != null && selectedImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          selectedImageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
          },
        ),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_outlined,
              size: 40,
              color: Color(0xFF818898),
            ),
            Text('Upload here'),
          ],
        ),
      );
    }
  }
}
