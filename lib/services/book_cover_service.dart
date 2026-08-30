import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BookCoverService {
  BookCoverService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pickFromCameraAndStore() async {
    return _pickAndStore(ImageSource.camera);
  }

  Future<String?> pickFromGalleryAndStore() async {
    return _pickAndStore(ImageSource.gallery);
  }

  static Future<void> deleteImageAtPath(String? imagePath) async {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return;
    }
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<String?> _pickAndStore(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 88);
    if (picked == null) {
      return null;
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final targetDir = Directory(p.join(docsDir.path, 'book_covers'));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final extension = p.extension(picked.path).toLowerCase();
    final safeExt = extension.isEmpty ? '.jpg' : extension;
    final fileName = 'cover_${DateTime.now().microsecondsSinceEpoch}$safeExt';
    final targetPath = p.join(targetDir.path, fileName);

    final copied = await File(picked.path).copy(targetPath);
    return copied.path;
  }
}
