
import 'package:flutter/material.dart';

class SmtpConfigurationPage extends StatefulWidget {
  const SmtpConfigurationPage({super.key});

  @override
  State<SmtpConfigurationPage> createState() =>
      _SmtpConfigurationPageState();
}

class _SmtpConfigurationPageState
    extends State<SmtpConfigurationPage> {
  static const Color primaryBlue = Color(0xFF1769FF);
  static const Color borderColor = Color(0xFFE0E6ED);
  static const Color textColor = Color(0xFF263238);

  final _formKey = GlobalKey<FormState>();

  final _hostController =
      TextEditingController(text: 'smtp.stackly.com');
  final _portController =
      TextEditingController(text: '587');
  final _usernameController =
      TextEditingController(text: 'noreply@stackly.com');
  final _passwordController =
      TextEditingController();
  final _fromEmailController =
      TextEditingController(text: 'noreply@stackly.com');
  final _fromNameController =
      TextEditingController(text: 'Stackly Platform');

  String _encryption = 'TLS';
  bool _hidePassword = true;
  bool _isTesting = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _fromEmailController.dispose();
    _fromNameController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _portValidator(String? value) {
    final port = int.tryParse(value ?? '');

    if (port == null || port < 1 || port > 65535) {
      return 'Enter a valid port (1–65535)';
    }

    return null;
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isTesting = true);

    try {
      // TODO: Call your backend SMTP test API here.
      // A real connection test requires a backend service.
      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      _showMessage(
        'SMTP test API is not connected yet. '
        'Connect your backend to test the server.',
      );
    } finally {
      if (mounted) {
        setState(() => _isTesting = false);
      }
    }
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // TODO: Send the configuration to your backend API.
      // Do not treat local form validation as a real save.
      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );

      if (!mounted) return;

      _showMessage(
        'Backend API is not connected. '
        'Configuration has not been saved.',
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF344054),
              ),
            ),
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator ?? _requiredValidator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 11,
            color: textColor,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 38,
              minHeight: 38,
            ),
            errorStyle: const TextStyle(fontSize: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: primaryBlue,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
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
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Configure SMTP',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: Color(0xFFE5EAF0),
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
                  padding: const EdgeInsets.fromLTRB(
                    6, 12, 6, 12,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _field(
                        label: 'SMTP Host',
                        controller: _hostController,
                      ),
                      const SizedBox(height: 10),
                      _field(
                        label: 'Port',
                        controller: _portController,
                        keyboardType: TextInputType.number,
                        validator: _portValidator,
                      ),
                      const SizedBox(height: 10),
                      _field(
                        label: 'Username',
                        controller: _usernameController,
                        keyboardType:
                            TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      _field(
                        label: 'Password',
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        suffixIcon: IconButton(
                          tooltip: _hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 18,
                            color: textColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Encryption *',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF344054),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _encryption,
                        isExpanded: true,
                        style: const TextStyle(
                          fontSize: 11,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: primaryBlue,
                            ),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'TLS',
                            child: Text('TLS'),
                          ),
                          DropdownMenuItem(
                            value: 'SSL',
                            child: Text('SSL'),
                          ),
                          DropdownMenuItem(
                            value: 'None',
                            child: Text('None'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _encryption = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      _field(
                        label: 'From Email',
                        controller: _fromEmailController,
                        keyboardType:
                            TextInputType.emailAddress,
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 10),
                      _field(
                        label: 'From Name',
                        controller: _fromNameController,
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _isTesting
                            ? null
                            : _testConnection,
                        icon: _isTesting
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send_outlined,
                                size: 15,
                              ),
                        label: Text(
                          _isTesting
                              ? 'Testing...'
                              : 'Test Connection',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryBlue,
                          side: const BorderSide(
                            color: primaryBlue,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
                color: Color(0xFFE5EAF0),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  6, 10, 6, 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textColor,
                          side: const BorderSide(
                            color: borderColor,
                          ),
                          minimumSize:
                              const Size(0, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : _saveConfiguration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF172DE0,
                          ),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize:
                              const Size(0, 42),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
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