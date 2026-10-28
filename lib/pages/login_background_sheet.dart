import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// The selected login background. [presetIndex] identifies the gradient
/// preset, and [imageBytes] contains an uploaded image when one is selected.
class LoginBackgroundChoice {
  final int presetIndex;
  final Uint8List? imageBytes;

  const LoginBackgroundChoice({
    required this.presetIndex,
    required this.imageBytes,
  });
}

/// A gradient preset used by the login-background picker and preview.
class LoginBackgroundPreset {
  final String name;
  final Gradient gradient;

  const LoginBackgroundPreset({
    required this.name,
    required this.gradient,
  });
}

/// Bottom sheet for selecting a preset gradient or uploading a background.
class LoginBackgroundSheet {
  static const int _maxBytes = 10 * 1024 * 1024;

  static const List<LoginBackgroundPreset> presets = [
    LoginBackgroundPreset(
      name: 'Ocean Blue',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF031B4E), Color(0xFF064E8C), Color(0xFF009BD1)],
      ),
    ),
    LoginBackgroundPreset(
      name: 'Purple Dream',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF30105A), Color(0xFF7B2FF7), Color(0xFFF107A3)],
      ),
    ),
    LoginBackgroundPreset(
      name: 'Forest Green',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF12372A), Color(0xFF436850), Color(0xFFADBC9F)],
      ),
    ),
    LoginBackgroundPreset(
      name: 'Sunset',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7F1D1D), Color(0xFFEA580C), Color(0xFFFBBF24)],
      ),
    ),
    LoginBackgroundPreset(
      name: 'Midnight',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF111827), Color(0xFF312E81), Color(0xFF1D4ED8)],
      ),
    ),
    LoginBackgroundPreset(
      name: 'Teal Mist',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF134E4A), Color(0xFF0F766E), Color(0xFF67E8F9)],
      ),
    ),
  ];

  static Future<LoginBackgroundChoice?> show(
    BuildContext context, {
    int currentPreset = 0,
    Uint8List? currentImage,
  }) async {
    int selectedPreset = currentPreset.clamp(0, presets.length - 1);
    Uint8List? selectedImage = currentImage;
    String? errorText;

    return showModalBottomSheet<LoginBackgroundChoice>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> chooseImage() async {
              try {
                final file = await FilePicker.pickFile(
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg', 'jpeg', 'webp'],
                );
                if (file == null) return;

                final bytes = await file.readAsBytes();
                if (bytes.isEmpty) {
                  setSheetState(() {
                    errorText = 'Could not read this image. Please try another.';
                  });
                  return;
                }
                if (bytes.length > _maxBytes) {
                  setSheetState(() {
                    errorText = 'Image is too large. Maximum size is 10 MB.';
                  });
                  return;
                }

                setSheetState(() {
                  selectedImage = bytes;
                  errorText = null;
                });
              } catch (_) {
                setSheetState(() {
                  errorText = 'Unable to open the file picker. Please try again.';
                });
              }
            }

            Widget preview({
              required Gradient gradient,
              Uint8List? image,
              double height = 84,
            }) {
              return Container(
                height: height,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: image == null ? gradient : null,
                ),
                child: image == null
                    ? const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 25,
                          color: Colors.white70,
                        ),
                      )
                    : Image.memory(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    10,
                    16,
                    16 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD5DAE5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Change Login Background Image',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF202631),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Choose a gradient or upload your own image.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF66717D)),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'GRADIENT PRESETS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF66717D),
                          letterSpacing: .5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: presets.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.65,
                        ),
                        itemBuilder: (context, index) {
                          final item = presets[index];
                          final isSelected =
                              selectedPreset == index && selectedImage == null;
                          return InkWell(
                            onTap: () {
                              setSheetState(() {
                                selectedPreset = index;
                                selectedImage = null;
                                errorText = null;
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1976D2)
                                      : const Color(0xFFDCE2E8),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: item.gradient,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    bottom: 7,
                                    right: 8,
                                    child: Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black54,
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Positioned(
                                      right: 6,
                                      top: 6,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CUSTOM IMAGE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF66717D),
                          letterSpacing: .5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (selectedImage != null)
                        preview(
                          gradient: presets[selectedPreset].gradient,
                          image: selectedImage,
                          height: 110,
                        )
                      else
                        preview(
                          gradient: presets[selectedPreset].gradient,
                          height: 74,
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: chooseImage,
                              icon: const Icon(Icons.upload_file, size: 18),
                              label: Text(
                                selectedImage == null
                                    ? 'Upload Image'
                                    : 'Change Image',
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 42),
                                foregroundColor: const Color(0xFF1976D2),
                                side: const BorderSide(
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                            ),
                          ),
                          if (selectedImage != null) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: 'Remove uploaded image',
                              onPressed: () {
                                setSheetState(() {
                                  selectedImage = null;
                                  errorText = null;
                                });
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ],
                      ),
                      if (errorText != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(sheetContext),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 44),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  sheetContext,
                                  LoginBackgroundChoice(
                                    presetIndex: selectedPreset,
                                    imageBytes: selectedImage,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 44),
                              ),
                              child: const Text('Apply Background'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
