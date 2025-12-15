import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        // Crop the image
        final croppedFile = await _cropImage(pickedFile.path);
        return croppedFile;
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    return null;
  }

  /// Capture image from camera
  static Future<File?> captureImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        // Crop the image
        final croppedFile = await _cropImage(pickedFile.path);
        return croppedFile;
      }
    } catch (e) {
      print('Error capturing image from camera: $e');
    }
    return null;
  }

  /// Crop image
  static Future<File?> _cropImage(String imagePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: const Color(0xFF2563EB),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );
      
      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      print('Error cropping image: $e');
      return null;
    }
  }

  /// Compress image
  static Future<File?> compressImage(File imageFile, {int quality = 80}) async {
    try {
      // For now, we'll just return the original file
      // In a real implementation, you would use a package like flutter_image_compress
      return imageFile;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }
}