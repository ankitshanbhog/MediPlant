import 'package:image_picker/image_picker.dart';

/// Selection source for plant images
enum ImageCaptureSource { camera, gallery }

/// Abstract contract for Camera and Gallery interactions
abstract class CameraGalleryService {
  Future<String?> captureFromCamera();
  Future<String?> pickFromGallery();
}

/// Implementation with image_picker and sample fallbacks
class MobileCameraGalleryService implements CameraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> captureFromCamera() async {
    try {
      // =======================================================================
      // TODO: [CAMERA_INTEGRATION]
      // Connect native device camera preview & capture controller
      // Configuration: High resolution, autofocus, flash modes
      // =======================================================================
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
      // =======================================================================
      // TODO: [GALLERY_INTEGRATION]
      // Native photo library / gallery picker
      // =======================================================================
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
