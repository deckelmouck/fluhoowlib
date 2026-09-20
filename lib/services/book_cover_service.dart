import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class StoredCoverImage {
  const StoredCoverImage({required this.key, required this.absolutePath});

  final String key;
  final String absolutePath;
}

class BookCoverService {
  BookCoverService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  static const String _coversDirName = 'book_covers';

  final ImagePicker _picker;

  Future<StoredCoverImage?> pickFromCameraAndStore() async {
    return _pickAndStore(ImageSource.camera);
  }

  Future<StoredCoverImage?> pickFromGalleryAndStore() async {
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

  static Future<void> deleteImage({
    String? imageKey,
    String? fallbackPath,
  }) async {
    final absoluteFromKey = await resolveImagePath(
      imageKey: imageKey,
      fallbackPath: null,
    );
    final normalizedFallback = _normalizeValue(fallbackPath);

    final candidates = <String>{};
    if (absoluteFromKey != null) {
      candidates.add(absoluteFromKey);
    }
    if (normalizedFallback != null) {
      candidates.add(normalizedFallback);
    }

    for (final path in candidates) {
      await deleteImageAtPath(path);
    }
  }

  static Future<String?> resolveImagePath({
    String? imageKey,
    String? fallbackPath,
  }) async {
    final normalizedKey = _normalizeValue(imageKey);
    if (normalizedKey != null) {
      if (p.isAbsolute(normalizedKey)) {
        return normalizedKey;
      }

      final docsDir = await getApplicationDocumentsDirectory();
      final keyPath = normalizedKey.replaceAll('\\\\', '/');
      final segments = keyPath
          .split('/')
          .where((segment) => segment.isNotEmpty);
      return p.normalize(p.joinAll([docsDir.path, ...segments]));
    }

    return _normalizeValue(fallbackPath);
  }

  static Future<String?> ensureStableKey({
    String? imageKey,
    String? fallbackPath,
  }) async {
    final normalizedKey = _normalizeValue(imageKey);
    if (normalizedKey != null) {
      if (!p.isAbsolute(normalizedKey)) {
        return normalizedKey.replaceAll('\\\\', '/');
      }
      return _migrateLegacyAbsolutePath(normalizedKey);
    }

    final normalizedFallback = _normalizeValue(fallbackPath);
    if (normalizedFallback == null) {
      return null;
    }

    if (!p.isAbsolute(normalizedFallback)) {
      return normalizedFallback.replaceAll('\\\\', '/');
    }
    return _migrateLegacyAbsolutePath(normalizedFallback);
  }

  Future<StoredCoverImage?> _pickAndStore(ImageSource source) async {
    // Balanced tradeoff: reduce storage while keeping cover quality solid.
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (picked == null) {
      return null;
    }

    final coverDir = await _coverDirectory();
    final extension = p.extension(picked.path).toLowerCase();
    final safeExt = extension.isEmpty ? '.jpg' : extension;
    final fileName = 'cover_${DateTime.now().microsecondsSinceEpoch}$safeExt';
    final targetPath = p.join(coverDir.path, fileName);

    final copied = await File(picked.path).copy(targetPath);
    return StoredCoverImage(
      key: _buildKey(fileName),
      absolutePath: copied.path,
    );
  }

  static Future<Directory> _coverDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final targetDir = Directory(p.join(docsDir.path, _coversDirName));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }
    return targetDir;
  }

  static Future<String?> _migrateLegacyAbsolutePath(String absolutePath) async {
    final legacyFile = File(absolutePath);
    final coverDir = await _coverDirectory();
    final legacyFileName = p.basename(absolutePath);
    final fallbackInCurrentDir = File(p.join(coverDir.path, legacyFileName));

    if (await fallbackInCurrentDir.exists()) {
      return _buildKey(legacyFileName);
    }

    if (!await legacyFile.exists()) {
      return null;
    }

    if (p.normalize(p.dirname(legacyFile.path)) == p.normalize(coverDir.path)) {
      return _buildKey(legacyFileName);
    }

    final extension = p.extension(legacyFileName).toLowerCase();
    final safeExt = extension.isEmpty ? '.jpg' : extension;
    final newFileName =
        'cover_${DateTime.now().microsecondsSinceEpoch}_migrated$safeExt';
    final targetPath = p.join(coverDir.path, newFileName);
    await legacyFile.copy(targetPath);
    return _buildKey(newFileName);
  }

  static String _buildKey(String fileName) {
    return '$_coversDirName/$fileName';
  }

  static String? _normalizeValue(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
