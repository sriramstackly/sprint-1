
import 'package:flutter/material.dart';

class ApiGatewayConfigurationPage extends StatefulWidget {
  const ApiGatewayConfigurationPage({super.key});

  @override
  State<ApiGatewayConfigurationPage> createState() =>
      _ApiGatewayConfigurationPageState();
}

class _ApiGatewayConfigurationPageState
    extends State<ApiGatewayConfigurationPage> {
  static const Color primaryBlue = Color(0xFF3949FF);
  static const Color borderColor = Color(0xFFE1E5EB);

  final _formKey = GlobalKey<FormState>();

  final gatewayNameController = TextEditingController();
  final baseUrlController = TextEditingController();
  final apiVersionController = TextEditingController();
  final apiKeyController = TextEditingController();
  final apiSecretController = TextEditingController();
  final headerNameController = TextEditingController();
  final timeoutController = TextEditingController();
  final retryController = TextEditingController();
  final rateLimitController = TextEditingController();

  String? selectedEnvironment;
  String? selectedAuthentication;

  bool showApiKey = false;
  bool showApiSecret = false;
  bool enableGateway = true;

  @override
  void dispose() {
    gatewayNameController.dispose();
    baseUrlController.dispose();
    apiVersionController.dispose();
    apiKeyController.dispose();
    apiSecretController.dispose();
    headerNameController.dispose();
    timeoutController.dispose();
    retryController.dispose();
    rateLimitController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _fieldLabel(String label, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
          ),
          if (required)
            const Text(
              ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _helperText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF718096),
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
    String hint = '',
    String? helper,
    bool required = true,
    bool numeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label, required: required),
          TextFormField(
            controller: controller,
            keyboardType:
                numeric ? TextInputType.number : TextInputType.text,
            decoration: _inputDecoration(hint),
            style: const TextStyle(fontSize: 13),
            validator: (value) {
              if (required && (value == null || value.trim().isEmpty)) {
                return 'Please enter $label';
              }
              if (numeric &&
                  value != null &&
                  value.isNotEmpty &&
                  int.tryParse(value) == null) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),
          if (helper != null) _helperText(helper),
        ],
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    String? helper,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label),
          DropdownButtonFormField<String>(
            value: value,
            hint: const Text(
              'Select',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 13,
              ),
            ),
            decoration: _inputDecoration(''),
            items: options
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            validator: (value) =>
                value == null ? 'Please select $label' : null,
          ),
          if (helper != null) _helperText(helper),
        ],
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
    String? helper,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label),
          TextFormField(
            controller: controller,
            obscureText: !visible,
            style: const TextStyle(fontSize: 13),
            decoration: _inputDecoration('').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  visible ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                  color: Colors.black87,
                ),
                onPressed: onToggle,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
          if (helper != null) _helperText(helper),
        ],
      ),
    );
  }

  void _saveConfiguration() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuration validated successfully'),
        backgroundColor: primaryBlue,
      ),
    );

    // TODO: Send configuration to your backend API.
  }

  void _testConnection() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Configuration validated. Connect an API to test the gateway.',
        ),
      ),
    );

    // TODO: Implement actual API connection testing.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leadingWidth: 45,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Color(0xFF111827),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        titleSpacing: 5,
        title: const Text(
          'API Gateway Configuration',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(
            height: 2,
            thickness: 2,
            color: primaryBlue,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 16, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _textField(
                      label: 'Gateway Name',
                      controller: gatewayNameController,
                      hint: 'Enter gateway name',
                    ),
                    _dropdownField(
                      label: 'Environment',
                      value: selectedEnvironment,
                      options: const [
                        'Development',
                        'Testing',
                        'Staging',
                        'Production',
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedEnvironment = value;
                        });
                      },
                    ),
                    _textField(
                      label: 'Base URL',
                      controller: baseUrlController,
                      hint: 'Enter base URL',
                      helper: 'Base URL of the API Gateway',
                    ),
                    _textField(
                      label: 'API Version',
                      controller: apiVersionController,
                      hint: 'Enter API version',
                      helper: 'API version (e.g. v1, v2)',
                    ),
                    _dropdownField(
                      label: 'Authentication Type',
                      value: selectedAuthentication,
                      options: const [
                        'API Key',
                        'Bearer Token',
                        'Basic Authentication',
                        'OAuth 2.0',
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedAuthentication = value;
                        });
                      },
                    ),
                    _passwordField(
                      label: 'API Key',
                      controller: apiKeyController,
                      visible: showApiKey,
                      onToggle: () {
                        setState(() {
                          showApiKey = !showApiKey;
                        });
                      },
                    ),
                    _passwordField(
                      label: 'API Secret',
                      controller: apiSecretController,
                      visible: showApiSecret,
                      onToggle: () {
                        setState(() {
                          showApiSecret = !showApiSecret;
                        });
                      },
                      helper: 'Secret used to authenticate API requests',
                    ),
                    _textField(
                      label: 'Header Name (Optional)',
                      controller: headerNameController,
                      hint: 'Enter header name',
                      required: false,
                      helper: 'Custom header name for API key (if required)',
                    ),
                    _textField(
                      label: 'Request Timeout (Seconds)',
                      controller: timeoutController,
                      hint: 'Enter timeout',
                      numeric: true,
                      helper: 'Timeout for API requests',
                    ),
                    _textField(
                      label: 'Retry Attempts',
                      controller: retryController,
                      hint: 'Enter retry attempts',
                      numeric: true,
                      helper: 'Number of retry attempts on failure',
                    ),
                    _textField(
                      label: 'Rate Limit (requests/minute)',
                      controller: rateLimitController,
                      hint: 'Enter rate limit',
                      numeric: true,
                      helper:
                          'Maximum number of requests allowed per minute',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Enable Gateway',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Switch(
                          value: enableGateway,
                          activeColor: primaryBlue,
                          onChanged: (value) {
                            setState(() {
                              enableGateway = value;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        const Expanded(
                          child: Text(
                            'Enable this gateway',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _testConnection,
                          icon: const Icon(
                            Icons.send_outlined,
                            size: 16,
                          ),
                          label: const Text(
                            'Test Connection',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryBlue,
                            side: const BorderSide(color: primaryBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: borderColor),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: borderColor),
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveConfiguration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 44),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Save Configuration'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
