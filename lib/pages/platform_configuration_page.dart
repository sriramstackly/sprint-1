import 'package:flutter/material.dart';
import 'smtp_configuration_page.dart';
import 'sms_gateway_configuration_page.dart';
import 'api_gateway_configuration_page.dart';

class PlatformConfigurationPage extends StatefulWidget {
  const PlatformConfigurationPage({super.key});

  @override
  State<PlatformConfigurationPage> createState() =>
      _PlatformConfigurationPageState();
}

class _PlatformConfigurationPageState
    extends State<PlatformConfigurationPage> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF075BC5);
  static const Color saveBlue = Color(0xFF1769FF);
  static const Color borderColor = Color(0xFFDCE3EA);
  static const Color dividerColor = Color(0xFFE5EAF0);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF475569);

  static const double mobileBreakpoint = 700;

  // ============================================================
  // FORM STATE
  // ============================================================

  late final TextEditingController _nameController;
  late final TextEditingController _urlController;

  static const List<String> _timeZones = [
    'UTC +05:30 (India Standard Time)',
    'UTC +00:00 (Greenwich Mean Time)',
    'UTC +01:00 (Central European Time)',
    'UTC -05:00 (Eastern Time)',
    'UTC -08:00 (Pacific Time)',
  ];

  static const List<String> _languages = [
    'English',
    'Hindi',
    'Tamil',
    'Spanish',
  ];

  String _savedName = 'Java Enterprise Suite';
  String _savedUrl = 'https://app.javasuite.enterprise';
  String _savedTimeZone = 'UTC +05:30 (India Standard Time)';
  String _savedLanguage = 'English';

  late String _timeZone;
  late String _language;

  bool _showSavedMessage = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: _savedName,
    );

    _urlController = TextEditingController(
      text: _savedUrl,
    );

    _timeZone = _savedTimeZone;
    _language = _savedLanguage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  // ============================================================
  // SAVE
  // ============================================================

  void _handleSave() {
    setState(() {
      _savedName = _nameController.text;
      _savedUrl = _urlController.text;
      _savedTimeZone = _timeZone;
      _savedLanguage = _language;
      _showSavedMessage = true;
    });
  }

  // ============================================================
  // CANCEL
  // ============================================================

  void _handleCancel() {
    setState(() {
      _nameController.text = _savedName;
      _urlController.text = _savedUrl;
      _timeZone = _savedTimeZone;
      _language = _savedLanguage;
      _showSavedMessage = false;
    });
  }

  // ============================================================
  // CONFIGURE
  // ============================================================

  

void _handleConfigure(String title) {
  if (title == 'SMTP Configuration') {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            const SmtpConfigurationPage(),
      ),
    );
    return;
  }

  if (title == 'SMS Gateway') {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            const SmsGatewayConfigurationPage(),
      ),
    );
    return;
  }

  if (title == 'API Gateway') {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            const ApiGatewayConfigurationPage(),
      ),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$title configuration coming soon'),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile =
            constraints.maxWidth < mobileBreakpoint;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(mobile),

            SizedBox(
              height: mobile ? 14 : 17,
            ),

            if (_showSavedMessage) ...[
              _successMessage(),
              const SizedBox(height: 13),
            ],

            if (mobile)
              ..._mobileBody()
            else
              ..._desktopBody(),

            const SizedBox(height: 14),

            _deploymentNote(),

            const SizedBox(height: 18),

            _actionButtons(mobile),

            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header(bool mobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Platform Administration',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),

            SizedBox(width: 6),

            Text(
              '/',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
              ),
            ),

            SizedBox(width: 6),

            Text(
              'Platform Configuration',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          'Platform Configuration',
          style: TextStyle(
            fontSize: mobile ? 22 : 24,
            fontWeight: FontWeight.w800,
            color: textDark,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Manage core platform identity, regional defaults, and security handling.',
          style: TextStyle(
            fontSize: 12,
            color: textMuted,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  Widget _successMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD9E7DE),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF15803D),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(width: 12),

          const Icon(
            Icons.check_circle,
            size: 17,
            color: Color(0xFF15803D),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Your changes have been saved successfully.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF15803D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          InkWell(
            onTap: () {
              setState(() {
                _showSavedMessage = false;
              });
            },
            child: const Icon(
              Icons.close,
              size: 16,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE BODY
  // ============================================================

  List<Widget> _mobileBody() {
    return [
      _basicConfiguration(mobile: true),

      const SizedBox(height: 14),

      _regionalConfiguration(mobile: true),

      const SizedBox(height: 14),

      _securityHandling(),

      const SizedBox(height: 14),

      _communicationIntegration(),
    ];
  }

  // ============================================================
  // DESKTOP BODY
  // ============================================================

  List<Widget> _desktopBody() {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _basicConfiguration(
                  mobile: false,
                ),

                const SizedBox(height: 12),

                _regionalConfiguration(
                  mobile: false,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 3,
            child: _securityHandling(),
          ),
        ],
      ),

      const SizedBox(height: 12),

      _communicationIntegration(),
    ];
  }

  // ============================================================
  // BASIC CONFIGURATION
  // ============================================================

  Widget _basicConfiguration({
    required bool mobile,
  }) {
    return _sectionCard(
      title: 'Basic Configuration',
      icon: Icons.settings_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(
            'Platform Name',
            mobile,
          ),

          _textField(
            _nameController,
          ),

          const SizedBox(height: 16),

          _label(
            'Platform URL',
            mobile,
          ),

          _textField(
            _urlController,
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REGIONAL CONFIGURATION
  // ============================================================

  Widget _regionalConfiguration({
    required bool mobile,
  }) {
    final timeZoneBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(
          'Default Time Zone',
          mobile,
        ),

        _dropdown(
          value: _timeZone,
          items: _timeZones,
          onChanged: (value) {
            setState(() {
              _timeZone = value;
            });
          },
        ),
      ],
    );

    final languageBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(
          'Default Language',
          mobile,
        ),

        _dropdown(
          value: _language,
          items: _languages,
          onChanged: (value) {
            setState(() {
              _language = value;
            });
          },
        ),
      ],
    );

    return _sectionCard(
      title: 'Regional Configuration',
      icon: Icons.language,
      child: mobile
          ? Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                timeZoneBlock,
                const SizedBox(height: 16),
                languageBlock,
              ],
            )
          : Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: timeZoneBlock,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: languageBlock,
                ),
              ],
            ),
    );
  }

  // ============================================================
  // SECURITY HANDLING
  // ============================================================

  Widget _securityHandling() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F5FB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.security,
                  size: 18,
                  color: primaryBlue,
                ),

                SizedBox(width: 8),

                Text(
                  'Security Handling',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _securityItem(
                  Icons.verified_user_outlined,
                  'Configuration version control',
                  'All changes are tracked and can be rolled back.',
                ),

                const SizedBox(height: 18),

                _securityItem(
                  Icons.lock_outline,
                  'Encryption of sensitive credentials',
                  'API keys and passwords are AES-256 encrypted.',
                ),

                const SizedBox(height: 18),

                _securityItem(
                  Icons.manage_search,
                  'Audit logs',
                  'Comprehensive logging of administrative actions.',
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                top: BorderSide(
                  color: dividerColor,
                ),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE1EBF6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: primaryBlue,
                  ),
                ),

                const SizedBox(width: 10),

                const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Health',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      'Optimal State',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECURITY ITEM
  // ============================================================

  Widget _securityItem(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF0066D6),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // COMMUNICATION & INTEGRATION
  // ============================================================

  Widget _communicationIntegration() {
    return _sectionCard(
      title: 'Communication & Integration',
      icon: Icons.hub_outlined,
      child: Column(
        children: [
          _integrationRow(
            'SMTP Configuration',
            'Manage email server settings',
          ),

          _integrationRow(
            'SMS Gateway',
            'Twilio integration settings',
          ),

          _integrationRow(
            'API Gateway',
            'External system access tokens',
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INTEGRATION ROW
  // ============================================================

  Widget _integrationRow(
    String title,
    String subtitle, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(
                  color: dividerColor,
                ),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            height: 30,
            child: OutlinedButton(
              onPressed: () {
                _handleConfigure(title);
              },
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                side: const BorderSide(
                  color: Color(0xFF1464D2),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Configure',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DEPLOYMENT NOTE
  // ============================================================

  Widget _deploymentNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 19,
            color: Color(0xFF075985),
          ),

          SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Deployment Note',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Changes to core platform configurations may require a service restart for integrated modules to reflect the updates completely.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CANCEL + SAVE
  // MATCHING YOUR SCREENSHOT
  // ============================================================

  Widget _actionButtons(bool mobile) {
    final cancelButton = TextButton(
      onPressed: _handleCancel,
      style: TextButton.styleFrom(
        foregroundColor:
            const Color(0xFF354258),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        minimumSize: const Size(
          110,
          48,
        ),
        tapTargetSize:
            MaterialTapTargetSize.padded,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: const Text(
        'Cancel',
      ),
    );

    final saveButton = ElevatedButton.icon(
      onPressed: _handleSave,

      icon: const Icon(
        Icons.save_outlined,
        size: 19,
      ),

      label: const Text(
        'Save',
      ),

      style: ElevatedButton.styleFrom(
        backgroundColor: saveBlue,
        foregroundColor: Colors.white,
        elevation: 0,

        minimumSize: Size(
          mobile ? 150 : 330,
          58,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 16,
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10),
        ),

        textStyle:
            const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (mobile) {
      return Row(
        mainAxisAlignment:
            MainAxisAlignment.end,
        children: [
          cancelButton,

          const SizedBox(width: 8),

          Expanded(
            child: saveButton,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.end,
      children: [
        cancelButton,

        const SizedBox(width: 14),

        saveButton,
      ],
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration:
                const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: primaryBlue,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    title,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _label(
    String text,
    bool mobile,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 7,
      ),
      child: Text(
        mobile
            ? text
            : text.toUpperCase(),
        style: TextStyle(
          fontSize:
              mobile ? 12 : 10,
          fontWeight:
              FontWeight.w600,
          letterSpacing:
              mobile ? 0 : 0.4,
          color: textMuted,
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _textField(
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,

      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF263238),
      ),

      decoration:
          InputDecoration(
        isDense: true,
        filled: true,
        fillColor:
            const Color(0xFFF8FAFC),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8),
          borderSide:
              const BorderSide(
            color: Color(0xFFE0E6ED),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8),
          borderSide:
              const BorderSide(
            color: saveBlue,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        color:
            const Color(0xFFF8FAFC),
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E6ED),
        ),
      ),

      child:
          DropdownButtonHideUnderline(
        child:
            DropdownButton<String>(
          value: value,
          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Color(0xFF64748B),
          ),

          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF263238),
          ),

          items: [
            for (final item in items)
              DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ),
          ],

          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}