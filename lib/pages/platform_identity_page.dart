import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'login_background_sheet.dart';

// One file, two sheets:
//   PlatformColorPicker.show(...)       → "Upload Favicon" sheet (image bytes)
//   PlatformColorPicker.pickColor(...)  → color picker sheet (Color)
import 'platform_color_picker.dart';

// "Change Login Background Image" sheet (presets + upload).
import 'login_background_sheet.dart';

// ============================================================
// WHAT'S NEW IN THIS VERSION
//
// FAVICON UPLOAD
//   - "Upload Favicon" button and the favicon box both open the
//     upload sheet (PlatformColorPicker.show).
//   - After "Upload" the picked image appears inside the favicon box
//     and the button changes to "Change Favicon".
//   - A small ✕ button removes the favicon again.
//   - The bytes are kept in faviconBytes — send them to your API in
//     the Save button (see the TODO there).
//
// OVERFLOW FIXES (from the previous version, kept)
//   1. Login Background preview box is 92px tall (was 78).
//   2. The color picker sheet width follows the available space.
//   3. Color rows use a flexible label + minimum hex field width.
//   4. Sheets are max 90% of the screen height and scroll inside.
// ============================================================

class PlatformIdentityPage extends StatefulWidget {
  const PlatformIdentityPage({super.key});

  @override
  State<PlatformIdentityPage> createState() =>
      _PlatformIdentityPageState();
}

class _PlatformIdentityPageState extends State<PlatformIdentityPage> {
  // CONTROLLERS

  final platformNameController =
      TextEditingController(text: 'Java Enterprise Suite');

  final companyNameController =
      TextEditingController(text: 'Oracle Corporation');

  final taglineController =
      TextEditingController(text: 'Empowering Enterprise Intelligence');

  final welcomeMessageController = TextEditingController(
    text: 'Welcome to Java Enterprise Suite.\n'
        'Please authenticate to continue.',
  );

  final footerController =
      TextEditingController(text: 'System Maintained by IT Dept.');

  final copyrightController = TextEditingController(
    text: '© 2024 platform branding. All rights reserved.',
  );

  final primaryColorController =
      TextEditingController(text: '#1976D2');

  final secondaryColorController =
      TextEditingController(text: '#FFFFFF');

  final accentColorController =
      TextEditingController(text: '#4CAF50');

  bool lightMode = true;

  // UPLOADED FILES

  Uint8List? faviconBytes;

  // Login background: a preset number, or an uploaded image (wins if set).
  int loginBgPreset = 0;
  Uint8List? loginBgBytes;

  // COLORS

  static const Color blue = Color(0xFF1976D2);
  static const Color darkText = Color(0xFF202631);
  static const Color greyText = Color(0xFF66717D);
  static const Color borderColor = Color(0xFFDCE2E8);

  // DISPOSE

  @override
  void dispose() {
    platformNameController.dispose();
    companyNameController.dispose();
    taglineController.dispose();
    welcomeMessageController.dispose();
    footerController.dispose();
    copyrightController.dispose();
    primaryColorController.dispose();
    secondaryColorController.dispose();
    accentColorController.dispose();
    super.dispose();
  }

  // HEX CONVERSION

  Color _colorFromHex(String value, Color fallback) {
    final hex = value.trim().replaceFirst('#', '');

    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hex)) {
      return fallback;
    }

    return Color(int.parse('FF$hex', radix: 16));
  }

  String _hexFromColor(Color color) {
    final value = color.toARGB32() & 0xFFFFFF;
    return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  // FAVICON UPLOAD
  //   Opens the upload sheet. If the person taps "Upload", the picked
  //   image is stored and shown in the favicon box.

  Future<void> _uploadFavicon() async {
    FocusScope.of(context).unfocus();

    final Uint8List? bytes = await PlatformColorPicker.show(
      context,
      title: 'Upload Favicon',
      initialColor: blue,
      initialImage: faviconBytes,
    );

    if (bytes == null || !mounted) return;

    setState(() => faviconBytes = bytes);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Favicon selected.')),
    );
  }

  void _removeFavicon() {
    setState(() => faviconBytes = null);
  }

  // LOGIN BACKGROUND
  //   "Change Image" (or tapping the preview) opens the
  //   "Change Login Background Image" sheet. Apply → the preview updates.

  Future<void> _changeLoginBackground() async {
    FocusScope.of(context).unfocus();

    final LoginBackgroundChoice? choice = await LoginBackgroundSheet.show(
      context,
      currentPreset: loginBgPreset,
      currentImage: loginBgBytes,
    );

    if (choice == null || !mounted) return;

    setState(() {
      loginBgPreset = choice.presetIndex;
      loginBgBytes = choice.imageBytes;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login background updated.')),
    );
  }

  // COLOR PICKER

  Future<void> _openColorPicker(
    String title,
    TextEditingController controller,
    Color fallback,
  ) async {
    FocusScope.of(context).unfocus();

    final Color? result = await PlatformColorPicker.pickColor(
      context,
      title: title,
      initialColor: _colorFromHex(controller.text, fallback),
    );

    if (result != null && mounted) {
      setState(() {
        controller.text = _hexFromColor(result);
      });
    }
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return _mobileLayout();
        }
        return _desktopLayout();
      },
    );
  }

  // MOBILE LAYOUT

  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader(),
        const SizedBox(height: 12),
        _platformIdentityCard(),
        const SizedBox(height: 10),
        _visualAssetsCard(),
        const SizedBox(height: 10),
        _loginBackgroundCard(),
        const SizedBox(height: 10),
        _welcomeMessageCard(),
        const SizedBox(height: 10),
        _securityRulesCard(),
        const SizedBox(height: 10),
        _themeConfigurationCard(),
        const SizedBox(height: 14),
        _bottomButtons(),
      ],
    );
  }

  // DESKTOP LAYOUT

  Widget _desktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader(),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _platformIdentityCard(),
                  const SizedBox(height: 12),
                  _visualAssetsCard(),
                  const SizedBox(height: 12),
                  _themeConfigurationCard(),
                ],
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 292,
              child: Column(
                children: [
                  _loginBackgroundCard(),
                  const SizedBox(height: 12),
                  _welcomeMessageCard(),
                  const SizedBox(height: 12),
                  _securityRulesCard(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _bottomButtons(),
      ],
    );
  }

  // PAGE HEADER

  Widget _pageHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform Administration / Platform Identity',
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF7A8490),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Platform Identity',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Manage platform identity, branding, login appearance and theme.',
          style: TextStyle(fontSize: 10, color: greyText),
        ),
      ],
    );
  }

  // PLATFORM IDENTITY

  Widget _platformIdentityCard() {
    return _sectionCard(
      title: 'Platform Identity',
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          'Basic Info',
          style: TextStyle(fontSize: 8, color: greyText),
        ),
      ),
      child: Column(
        children: [
          _textField(
            label: 'Platform Name',
            controller: platformNameController,
          ),
          const SizedBox(height: 10),
          _textField(
            label: 'Company Name',
            controller: companyNameController,
          ),
          const SizedBox(height: 10),
          _textField(
            label: 'Tagline',
            controller: taglineController,
          ),
        ],
      ),
    );
  }

  // VISUAL ASSETS

  Widget _visualAssetsCard() {
    return _sectionCard(
      title: 'Visual Assets',
      trailing: const Text(
        'PNG, SVG up to 5MB.',
        style: TextStyle(fontSize: 8, color: Color(0xFF9299A2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _companyLogo(),
          const SizedBox(height: 12),
          _favicon(),
          const SizedBox(height: 12),
          _emailHeaderLogo(),
          const SizedBox(height: 12),
          _textField(
            label: 'Footer Text',
            controller: footerController,
          ),
          const SizedBox(height: 10),
          _textField(
            label: 'Copyright Text',
            controller: copyrightController,
          ),
        ],
      ),
    );
  }

  // COMPANY LOGO

  Widget _companyLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Company Logo',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4C5663),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 105,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.business, size: 27, color: blue),
                const SizedBox(width: 7),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'SYNERGY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF176CB7),
                      ),
                    ),
                    Text(
                      'ENTERPRISE SOFTWARE',
                      style: TextStyle(fontSize: 5, color: greyText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // FAVICON
  //   Tap the box or the button → upload sheet.
  //   The uploaded image replaces the star icon in the box.

  Widget _favicon() {
    final bool hasFavicon = faviconBytes != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Favicon',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4C5663),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            // FAVICON BOX
            InkWell(
              onTap: _uploadFavicon,
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: 46,
                height: 46,
                padding: EdgeInsets.all(hasFavicon ? 8 : 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: hasFavicon
                    ? Image.memory(
                        faviconBytes!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image_outlined,
                          size: 18,
                          color: greyText,
                        ),
                      )
                    : const Icon(
                        Icons.star_border,
                        size: 18,
                        color: blue,
                      ),
              ),
            ),
            const SizedBox(width: 10),

            // UPLOAD / CHANGE BUTTON
            Flexible(
              child: OutlinedButton(
                onPressed: _uploadFavicon,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(105, 36),
                  side: const BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  hasFavicon ? 'Change Favicon' : 'Upload Favicon',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 8, color: darkText),
                ),
              ),
            ),

            // REMOVE
            if (hasFavicon)
              IconButton(
                tooltip: 'Remove favicon',
                onPressed: _removeFavicon,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                icon: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: greyText,
                ),
              ),
          ],
        ),
      ],
    );
  }

  // EMAIL HEADER LOGO

  Widget _emailHeaderLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Header Logo',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4C5663),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'No file chosen',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8, color: greyText),
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(65, 36),
                side: const BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Upload',
                style: TextStyle(fontSize: 8, color: darkText),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // LOGIN BACKGROUND

  Widget _loginBackgroundCard() {
    final bool hasImage = loginBgBytes != null;

    return _sectionCard(
      title: 'Login Background',
      trailing: TextButton(
        onPressed: _changeLoginBackground,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(70, 25),
        ),
        child: const Text(
          'Change Image',
          style: TextStyle(fontSize: 8, color: blue),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preview',
            style: TextStyle(fontSize: 8, color: greyText),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _changeLoginBackground,
            child: Container(
              height: 145,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: hasImage
                    ? null
                    : LoginBackgroundSheet.presets[loginBgPreset].gradient,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // UPLOADED IMAGE (covers the gradient)
                  if (hasImage)
                    Image.memory(
                      loginBgBytes!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                  // MINI LOGIN BOX
                  // Needs 85px (10 + 6 + 11 + 6 + 11 + 6 + 15 = 65, plus
                  // 20 padding). It was 78px → "overflowed by 7 pixels".
                  Center(
                    child: Container(
                      width: 100,
                      height: 92,
                      padding: const EdgeInsets.all(10),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .93),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 10,
                            color: const Color(0xFFE1E4E7),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 11,
                            color: const Color(0xFFE1E4E7),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 11,
                            color: const Color(0xFFE1E4E7),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 15,
                            color: const Color(0xFF171C4C),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WELCOME MESSAGE

  Widget _welcomeMessageCard() {
    return _sectionCard(
      title: 'Welcome Message',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome message',
            style: TextStyle(fontSize: 8, color: greyText),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: welcomeMessageController,
            maxLines: 4,
            maxLength: 250,
            style: const TextStyle(fontSize: 9, color: darkText),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: borderColor),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              ),
              counterStyle: const TextStyle(fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }

  // SECURITY RULES

  Widget _securityRulesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE4EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.security_outlined, size: 16, color: greyText),
              SizedBox(width: 6),
              Text(
                'Security & Rules',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: greyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'VALIDATION RULES',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          _rule('Images: PNG, JPG, SVG max 5MB.\nBackground max 10MB.'),
          _rule('Text fields max 100 chars;\nMessages max 250 chars.'),
          _rule('Colors must be valid hex values.'),
          const SizedBox(height: 7),
          const Divider(color: Color(0xFFD7DEE6)),
          const SizedBox(height: 7),
          const Text(
            'SECURITY HANDLING',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          _rule(
            'Super Admin (RBAC) access only.',
            icon: Icons.lock_outline,
          ),
          _rule(
            'All changes logged to Audit Trail.',
            icon: Icons.history_outlined,
          ),
        ],
      ),
    );
  }

  Widget _rule(
    String text, {
    IconData icon = Icons.check_circle_outline,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 12, color: greyText),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 8,
                height: 1.35,
                color: greyText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // THEME CONFIGURATION

  Widget _themeConfigurationCard() {
    return _sectionCard(
      title: 'Theme Configuration',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _themeButton('Light mode', lightMode, () {
                  setState(() => lightMode = true);
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _themeButton('Dark mode', !lightMode, () {
                  setState(() => lightMode = false);
                }),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _colorInput(
            'Primary Color',
            primaryColorController,
            const Color(0xFF1976D2),
          ),
          const SizedBox(height: 8),
          _colorInput(
            'Secondary Color',
            secondaryColorController,
            Colors.white,
          ),
          const SizedBox(height: 8),
          _colorInput(
            'Accent Color',
            accentColorController,
            const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  // THEME BUTTON

  Widget _themeButton(
    String title,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: selected ? blue : borderColor,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: selected ? blue : greyText,
          ),
        ),
      ),
    );
  }

  // COLOR INPUT WITH LIVE PREVIEW

  Widget _colorInput(
    String label,
    TextEditingController controller,
    Color fallback,
  ) {
    final currentColor = _colorFromHex(controller.text, fallback);

    return Row(
      children: [
        // Flexible label so narrow phones can't overflow.
        Flexible(
          flex: 0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 60,
              maxWidth: 82,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 8, color: greyText),
            ),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => _openColorPicker(label, controller, fallback),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor),
            ),
            child: Icon(
              Icons.colorize,
              size: 13,
              color: currentColor.computeLuminance() > 0.55
                  ? Colors.black54
                  : Colors.white70,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 70),
            child: SizedBox(
              height: 32,
              child: TextField(
                controller: controller,
                style: const TextStyle(fontSize: 10, color: darkText),
                onSubmitted: (_) => setState(() {}),
                onTapOutside: (_) {
                  setState(() {});
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: blue),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 2),
        IconButton(
          tooltip: 'Choose color',
          onPressed: () => _openColorPicker(label, controller, fallback),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 28,
            minHeight: 28,
          ),
          icon: const Icon(
            Icons.palette_outlined,
            size: 17,
            color: blue,
          ),
        ),
      ],
    );
  }

  // BOTTOM BUTTONS

  Widget _bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 38,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preview is ready to implement.'),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Preview',
                style: TextStyle(
                  fontSize: 9,
                  color: blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 38,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {});

                // TODO: send to your API:
                //   faviconBytes (Uint8List?) — the uploaded favicon
                //   loginBgBytes (Uint8List?) or loginBgPreset (int) — login background
                //   primaryColorController.text, secondaryColorController.text,
                //   accentColorController.text, text fields, lightMode

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Platform Identity saved successfully.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined, size: 13),
              label: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // SECTION CARD

  Widget _sectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE1E6EC)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFCFCFD),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE6EAF0)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }

  // COMMON TEXT FIELD

  Widget _textField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 8.5,
            color: Color(0xFF424B56),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 9, color: darkText),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 9,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: blue),
            ),
          ),
        ),
      ],
    );
  }
}