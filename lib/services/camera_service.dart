import 'package:image_picker/image_picker.dart';

enum ImageCaptureSource { camera, gallery }

abstract class CameraGalleryService {
  Future<String?> captureFromCamera();
  Future<String?> pickFromGallery();
}

class MobileCameraGalleryService implements CameraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> captureFromCamera() async {
    try {
      
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );
      return photo?.path;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> pickFromGallery() async {
    try {
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );
      return image?.path;
    } catch (e) {
      return null;
    }
  }
}
