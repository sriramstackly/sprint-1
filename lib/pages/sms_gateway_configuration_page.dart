import 'package:flutter/material.dart';

class SmsGatewayConfigurationPage extends StatefulWidget {
  const SmsGatewayConfigurationPage({super.key});

  @override
  State<SmsGatewayConfigurationPage> createState() =>
      _SmsGatewayConfigurationPageState();
}

class _SmsGatewayConfigurationPageState
    extends State<SmsGatewayConfigurationPage> {
  static const Color blue = Color(0xFF172DE0);
  static const Color border = Color(0xFFE0E6ED);
  static const Color textColor = Color(0xFF263238);

  final _formKey = GlobalKey<FormState>();
  final _providerController = TextEditingController(text: 'Stackly');
  final _nameController = TextEditingController(text: 'Stackly Primary');
  final _urlController = TextEditingController(
    text: 'https://api.stackly.com/2010-04-01',
  );
  final _accountSidController = TextEditingController();
  final _senderController = TextEditingController(text: '+14155552671');
  final _timeoutController = TextEditingController(text: '30');
  final _tokenController = TextEditingController();
  final _serviceSidController = TextEditingController(
    text: 'MGXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
  );

  bool _hideAccountSid = true;
  bool _hideToken = true;
  bool _enabled = true;
  bool _saving = false;

  @override
  void dispose() {
    _providerController.dispose();
    _nameController.dispose();
    _urlController.dispose();
    _accountSidController.dispose();
    _senderController.dispose();
    _timeoutController.dispose();
    _tokenController.dispose();
    _serviceSidController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    String? helper,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              children: [
                TextSpan(text: label),
                if (requiredField)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            validator: validator ?? (requiredField ? _required : null),
            keyboardType: keyboardType,
            obscureText: obscure,
            style: const TextStyle(fontSize: 11, color: textColor),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              suffixIcon: suffix,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 38,
                minHeight: 36,
              ),
              errorStyle: const TextStyle(fontSize: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: blue, width: 1.2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
          if (helper != null) ...[
            const SizedBox(height: 3),
            Text(
              helper,
              style: const TextStyle(fontSize: 8, color: Color(0xFF64748B)),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      // TODO: Send these values to your secure backend API.
      // This placeholder deliberately does not claim the config was saved.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _message(
        'Backend API is not connected. Configuration has not been saved.',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 20, color: textColor),
        ),
        titleSpacing: 0,
        title: const Text(
          'SMS Gateway Configuration',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: ColoredBox(
            color: Color(0xFF1769FF),
            child: SizedBox(height: 3),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _field(
                        label: 'Gateway Provider',
                        controller: _providerController,
                      ),
                      _field(
                        label: 'Gateway Name',
                        controller: _nameController,
                      ),
                      _field(
                        label: 'API Base URL',
                        controller: _urlController,
                        keyboardType: TextInputType.url,
                        helper: 'Base URL for Stackly API',
                      ),
                      _field(
                        label: 'Account SID',
                        controller: _accountSidController,
                        obscure: _hideAccountSid,
                        helper: 'Your Stackly Account SID',
                        suffix: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(
                            () => _hideAccountSid = !_hideAccountSid,
                          ),
                          icon: Icon(
                            _hideAccountSid
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                          ),
                        ),
                      ),
                      _field(
                        label: 'From Number/ Sender ID',
                        controller: _senderController,
                        helper: 'Phone number or Sender ID to send SMS from',
                      ),
                      _field(
                        label: 'Connection Timeout (Seconds)',
                        controller: _timeoutController,
                        keyboardType: TextInputType.number,
                        helper: 'Timeout for API requests',
                        validator: (value) {
                          final timeout = int.tryParse(value ?? '');
                          if (timeout == null || timeout < 1 || timeout > 300) {
                            return 'Enter timeout from 1 to 300';
                          }
                          return null;
                        },
                      ),
                      _field(
                        label: 'Auth Token',
                        controller: _tokenController,
                        obscure: _hideToken,
                        helper: 'Your Stackly Auth Token',
                        suffix: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(
                            () => _hideToken = !_hideToken,
                          ),
                          icon: Icon(
                            _hideToken
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                          ),
                        ),
                      ),
                      _field(
                        label: 'Messaging Service SID (Optional)',
                        controller: _serviceSidController,
                        helper: 'Stackly Messaging Service SID',
                        requiredField: false,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Enable this SMS gateway',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          Switch(
                            value: _enabled,
                            activeThumbColor: Colors.white,
                            activeTrackColor: blue,
                            onChanged: (value) => setState(
                              () => _enabled = value,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5EAF0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textColor,
                          side: const BorderSide(color: border),
                          minimumSize: const Size(0, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saving ? null : _saveConfiguration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(0, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Configuration',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
