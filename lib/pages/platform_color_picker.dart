import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ============================================================
// PLATFORM COLOR PICKER  — one file, two bottom sheets
//
// 1) PlatformColorPicker.show(...)       → "Upload Favicon" sheet
//      (dashed drop box, BROWSER TAB PREVIEW "Stackly Portal",
//       Cancel / Upload — exactly like the design)
//      Returns the picked image bytes (Uint8List) or null.
//
//      final Uint8List? bytes = await PlatformColorPicker.show(
//        context,
//        title: 'Upload Favicon',
//        initialImage: currentBytes,   // optional
//      );
//
// 2) PlatformColorPicker.pickColor(...)  → real color picker sheet
//      (palette + hue slider + Hex / R / G / B boxes)
//      Returns a Color or null.
//
//      final Color? color = await PlatformColorPicker.pickColor(
//        context,
//        title: 'Primary Color',
//        initialColor: const Color(0xFF1976D2),
//      );
//
// pubspec.yaml:
//   dependencies:
//     file_picker: ^13.1.0          (static FilePicker.pickFile API)
//     flutter_colorpicker: ^1.1.0
// ============================================================

class PlatformColorPicker {
  static const int _maxBytes = 5 * 1024 * 1024; // 5 MB

  static const Color _uploadBlue = Color(0xFF354BFF);
  static const Color _buttonBlue = Color(0xFF172CE5);
  static const Color _lineColor = Color(0xFFE0E5ED);
  static const Color _text = Color(0xFF172033);

  // ==========================================================
  // 1) UPLOAD FAVICON / LOGO SHEET
  // ==========================================================

  static Future<Uint8List?> show(
    BuildContext context, {
    required String title,
    Color initialColor = _uploadBlue, // color of the dashed border + icon
    Uint8List? initialImage,
  }) async {
    Uint8List? selectedImage = initialImage;
    String? errorText;

    return showModalBottomSheet<Uint8List>(
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
                  allowedExtensions: ['ico', 'png', 'jpg', 'jpeg'],
                );

                if (file == null) return;

                final Uint8List bytes = await file.readAsBytes();

                if (bytes.isEmpty) {
                  setSheetState(() {
                    errorText = 'Could not read this file. Try another one.';
                  });
                  return;
                }

                if (bytes.length > _maxBytes) {
                  setSheetState(() {
                    errorText = 'File is too large. Maximum size is 5 MB.';
                  });
                  return;
                }

                setSheetState(() {
                  selectedImage = bytes;
                  errorText = null;
                });
              } catch (_) {
                setSheetState(() {
                  errorText = 'Could not open the file picker.';
                });
              }
            }

            Widget dot(Color color) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                );

            return Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // grab handle
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD5DAE5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // TITLE + CLOSE
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: const Icon(Icons.close, size: 19),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // DASHED DROP / BROWSE BOX
                      InkWell(
                        onTap: chooseImage,
                        borderRadius: BorderRadius.circular(10),
                        child: CustomPaint(
                          foregroundPainter: _DashedRRectPainter(
                            color: errorText == null
                                ? initialColor
                                : const Color(0xFFD32F2F),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 126,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFBFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (selectedImage != null)
                                  Image.memory(
                                    selectedImage!,
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.broken_image_outlined,
                                      size: 35,
                                    ),
                                  )
                                else
                                  CircleAvatar(
                                    backgroundColor:
                                        initialColor.withValues(alpha: .12),
                                    child: Icon(
                                      Icons.upload_outlined,
                                      color: initialColor,
                                    ),
                                  ),

                                const SizedBox(height: 10),

                                Text(
                                  selectedImage == null
                                      ? 'Drag & drop your favicon here'
                                      : 'Image selected successfully',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedImage == null
                                      ? 'or click to browse files'
                                      : 'click to choose a different file',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(height: 8),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'ICO, PNG format supported — '
                                    '32x32 or 16x16 pixels recommended',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (errorText != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            errorText!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 22),

                      // BROWSER TAB PREVIEW
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F5FA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE1E7F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BROWSER TAB PREVIEW',
                              style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF555D6B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: _lineColor),
                              ),
                              child: Row(
                                children: [
                                  dot(const Color(0xFFFF5F57)),
                                  dot(const Color(0xFFFEBC2E)),
                                  dot(const Color(0xFF28C840)),
                                  const SizedBox(width: 8),
                                  if (selectedImage != null)
                                    Image.memory(
                                      selectedImage!,
                                      width: 14,
                                      height: 14,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(
                                        Icons.broken_image_outlined,
                                        size: 14,
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.apps,
                                      size: 14,
                                      color: _buttonBlue,
                                    ),
                                  const SizedBox(width: 5),
                                  const Expanded(
                                    child: Text(
                                      'Stackly Portal',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CANCEL / UPLOAD
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(sheetContext),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 42),
                                side: const BorderSide(color: _lineColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: _text, fontSize: 11),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedImage == null
                                  ? null
                                  : () => Navigator.pop(
                                        sheetContext,
                                        selectedImage,
                                      ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _buttonBlue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 42),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Upload',
                                style: TextStyle(fontSize: 11),
                              ),
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

  // ==========================================================
  // 2) COLOR PICKER SHEET
  // ==========================================================

  static String _hex(Color color) {
    final int rgb = color.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  static Future<Color?> pickColor(
    BuildContext context, {
    required String title,
    required Color initialColor,
  }) async {
    const Color blue = Color(0xFF1976D2);
    const Color border = Color(0xFFDCE2E8);

    Color selectedColor = initialColor;

    final hexController = TextEditingController();
    final rController = TextEditingController();
    final gController = TextEditingController();
    final bController = TextEditingController();

    void syncInputs(Color color) {
      hexController.text = _hex(color);
      rController.text = (color.r * 255).round().toString();
      gController.text = (color.g * 255).round().toString();
      bController.text = (color.b * 255).round().toString();
    }

    syncInputs(selectedColor);

    try {
      return await showModalBottomSheet<Color>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        builder: (sheetContext) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              void updateColor(Color color) {
                setModalState(() {
                  selectedColor = color;
                  syncInputs(color);
                });
              }

              bool applyHex() {
                final hex =
                    hexController.text.trim().replaceFirst('#', '');

                if (RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hex)) {
                  updateColor(Color(int.parse('FF$hex', radix: 16)));
                  return true;
                }
                return false;
              }

              bool applyRgb() {
                final r = int.tryParse(rController.text);
                final g = int.tryParse(gController.text);
                final b = int.tryParse(bController.text);

                if (r == null || g == null || b == null) return false;

                if (r < 0 || r > 255 ||
                    g < 0 || g > 255 ||
                    b < 0 || b > 255) {
                  return false;
                }

                updateColor(Color.fromARGB(255, r, g, b));
                return true;
              }

              Widget numberField(
                String label,
                TextEditingController inputController, {
                bool hex = false,
              }) {
                return Expanded(
                  flex: hex ? 2 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: inputController,
                        keyboardType: hex
                            ? TextInputType.text
                            : TextInputType.number,
                        style: const TextStyle(fontSize: 11),
                        onSubmitted: (_) {
                          if (hex) {
                            applyHex();
                          } else {
                            applyRgb();
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1D5DB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: selectedColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: border),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    Navigator.pop(sheetContext),
                                icon: const Icon(Icons.close, size: 18),
                              ),
                            ],
                          ),

                          // Picker width follows the space we have.
                          LayoutBuilder(
                            builder: (context, box) {
                              final double pickerWidth =
                                  box.maxWidth < 300 ? box.maxWidth : 300;

                              return Center(
                                child: ColorPicker(
                                  pickerColor: selectedColor,
                                  onColorChanged: updateColor,
                                  enableAlpha: false,
                                  displayThumbColor: true,
                                  portraitOnly: true,
                                  colorPickerWidth: pickerWidth,
                                  paletteType: PaletteType.hsvWithHue,
                                  labelTypes: const [],
                                  pickerAreaHeightPercent: 0.65,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              numberField('Hex', hexController, hex: true),
                              const SizedBox(width: 6),
                              numberField('R', rController),
                              const SizedBox(width: 6),
                              numberField('G', gController),
                              const SizedBox(width: 6),
                              numberField('B', bController),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Navigator.pop(sheetContext),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Apply Hex first, then RGB if it differs.
                                    applyHex();

                                    final r = int.tryParse(rController.text);
                                    final g = int.tryParse(gController.text);
                                    final b = int.tryParse(bController.text);

                                    if (r != null &&
                                        g != null &&
                                        b != null &&
                                        r >= 0 && r <= 255 &&
                                        g >= 0 && g <= 255 &&
                                        b >= 0 && b <= 255) {
                                      final rgbColor =
                                          Color.fromARGB(255, r, g, b);

                                      if (rgbColor != selectedColor) {
                                        updateColor(rgbColor);
                                      }
                                    }

                                    Navigator.pop(
                                      sheetContext,
                                      selectedColor,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _buttonBlue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Select'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } finally {
      // Wait until the sheet has finished sliding away, otherwise the
      // closing sheet can still use these controllers after dispose.
      Future.delayed(const Duration(milliseconds: 500), () {
        hexController.dispose();
        rController.dispose();
        gController.dispose();
        bController.dispose();
      });
    }
  }
}

// Dashed rounded border (like the design) — no extra packages needed.
class _DashedRRectPainter extends CustomPainter {
  final Color color;

  const _DashedRRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(10),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
        distance += 9;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) => old.color != color;
}