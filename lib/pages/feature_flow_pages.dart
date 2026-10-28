import 'dart:math' as math;

import 'package:flutter/material.dart';

// ============================================================
// FEATURE FLOW  (3 pages in one file)
//
//   [Configure] button
//        ↓
//   ConfigureFeaturePage   "Configure Feature"
//        │  "Manage Access" link ─────────► OrganizationAccessPage (push)
//        ↓  [Save Changes]
//   OrganizationAccessPage "Organization Access"
//        ↓  [Save Changes]
//   FeatureUsagePage       "Feature Usage Monitoring"
//        ↓  [Close]  → back to the Feature Management list
//
//   The [Usage] button on the list opens FeatureUsagePage directly.
//
// All three pages edit the same feature map
// ({name, module, license, enabled, accessScope, orgs, lastUpdated}),
// then call onSaved() so the list refreshes.
// TODO markers show where to call your API.
// ============================================================

const Color _navy = Color(0xFF1E2A5A);
const Color _blue = Color(0xFF1726D8);
const Color _green = Color(0xFF14945C);
const Color _red = Color(0xFFE64646);
const Color _textStrong = Color(0xFF172033);
const Color _textMedium = Color(0xFF354258);
const Color _textSoft = Color(0xFF7A8490);
const Color _border = Color(0xFFD5DBE7);
const Color _fieldBg = Color(0xFFFFFFFF);

const List<String> kModules = [
  'Identity',
  'Workflow',
  'AI Services',
  'Analytics',
  'Integration',
];

const List<String> kLicensePlans = ['Standard', 'Premium', 'Enterprise'];

const List<String> kSampleOrganizations = [
  'Acme Corporation',
  'Globex Industries',
  'Initech Solutions',
  'Umbrella Group',
  'Hooli Systems',
  'Stark Enterprises',
  'Wayne Technologies',
  'Wonka Foods',
  'Soylent Labs',
  'Cyberdyne Systems',
  'Vandelay Imports',
  'Pied Piper',
];

// ------------------------------------------------------------
// SMALL HELPERS
// ------------------------------------------------------------

String _formatNow() {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  final d = DateTime.now();
  final int hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final String ampm = d.hour >= 12 ? 'PM' : 'AM';

  return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}, '
      '${hour12.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} $ampm';
}

String _scopeOf(Map<String, dynamic> f) =>
    (f['accessScope'] as String?) ?? 'All Organizations';

List<String> _orgsOf(Map<String, dynamic> f) =>
    List<String>.from((f['orgs'] as List?) ?? const <String>[]);

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
}

// ------------------------------------------------------------
// SHARED PAGE SHELL: back arrow + title, scrolling body,
// optional bottom bar
// ------------------------------------------------------------

class _PageShell extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget bottom;
  final VoidCallback? onBack;

  const _PageShell({
    required this.title,
    required this.body,
    required this.bottom,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 18, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed:
                            onBack ?? () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, size: 20),
                        color: _textStrong,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _textStrong,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                    child: body,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFEEF0F4)),
                    ),
                  ),
                  child: bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [Cancel] [primary] bottom bar used by Configure + Organization Access.
class _CancelAndPrimary extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onCancel;

  const _CancelAndPrimary({
    required this.primaryLabel,
    required this.onPrimary,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 48,
            child: TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: _textStrong,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 6,
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onPrimary,
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                primaryLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _fieldLabel(String text, {bool required = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _textStrong,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: _red),
            ),
        ],
      ),
    ),
  );
}

Widget _dropdownBox<T>({
  required T value,
  required List<DropdownMenuItem<T>> items,
  required ValueChanged<T> onChanged,
}) {
  return Container(
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      color: _fieldBg,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: _border),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 20,
          color: _textMedium,
        ),
        style: const TextStyle(fontSize: 13.5, color: _textStrong),
        items: items,
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    ),
  );
}

// ============================================================
// 1) CONFIGURE FEATURE
// ============================================================

class ConfigureFeaturePage extends StatefulWidget {
  final Map<String, dynamic> feature;
  final VoidCallback onSaved;

  const ConfigureFeaturePage({
    super.key,
    required this.feature,
    required this.onSaved,
  });

  @override
  State<ConfigureFeaturePage> createState() => _ConfigureFeaturePageState();
}

class _ConfigureFeaturePageState extends State<ConfigureFeaturePage> {
  late String module;
  late String license;
  late bool enabled;
  late String scope;

  static const List<String> _scopes = [
    'All Organizations',
    'Selected Organizations',
  ];

  @override
  void initState() {
    super.initState();

    final f = widget.feature;
    module = f['module'] as String;
    license = f['license'] as String;
    enabled = f['enabled'] as bool;
    scope = _scopeOf(f);

    // keep the dropdown values valid even for unexpected data
    if (!kModules.contains(module)) module = kModules.first;
    if (!kLicensePlans.contains(license)) license = kLicensePlans.first;
  }

  int get _orgCount =>
      scope == 'All Organizations' ? kSampleOrganizations.length : _orgsOf(widget.feature).length;

  void _applyToFeature() {
    final f = widget.feature;
    f['module'] = module;
    f['license'] = license;
    f['enabled'] = enabled;
    f['accessScope'] = scope;
    f['lastUpdated'] = _formatNow();
  }

  /// [Save Changes] → save, then go to Organization Access.
  void _save() {
    // TODO: validate + send to your API, and write the Audit Log entry.
    _applyToFeature();
    widget.onSaved();

    _toast(context, 'Configuration saved.');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OrganizationAccessPage(
          feature: widget.feature,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }

  /// "Manage Access" link → open Organization Access (and come back).
  Future<void> _manageAccess() async {
    // keep what was typed so far
    _applyToFeature();

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrganizationAccessPage(
          feature: widget.feature,
          onSaved: widget.onSaved,
        ),
      ),
    );

    if (!mounted) return;
    setState(() {
      scope = _scopeOf(widget.feature);
    });
  }

  Widget _statusItem(bool isEnabled) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isEnabled ? const Color(0xFF18A957) : _red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(isEnabled ? 'Enabled' : 'Disabled'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PageShell(
      title: 'Configure Feature',
      bottom: _CancelAndPrimary(
        primaryLabel: 'Save Changes',
        onPrimary: _save,
        onCancel: () => Navigator.of(context).pop(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FEATURE NAME (read only)
          _fieldLabel('Feature Name'),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.feature['name'] as String,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF9AA4B2),
                    ),
                  ),
                ),
                const Icon(
                  Icons.lock_outline,
                  size: 17,
                  color: Color(0xFF9AA4B2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // MODULE
          _fieldLabel('Module', required: true),
          _dropdownBox<String>(
            value: module,
            items: [
              for (final m in kModules)
                DropdownMenuItem(value: m, child: Text(m)),
            ],
            onChanged: (v) => setState(() => module = v),
          ),

          const SizedBox(height: 18),

          // STATUS
          _fieldLabel('Status'),
          _dropdownBox<bool>(
            value: enabled,
            items: [
              DropdownMenuItem(value: true, child: _statusItem(true)),
              DropdownMenuItem(value: false, child: _statusItem(false)),
            ],
            onChanged: (v) => setState(() => enabled = v),
          ),

          const SizedBox(height: 18),

          // LICENSE PLAN
          _fieldLabel('License Plan', required: true),
          _dropdownBox<String>(
            value: license,
            items: [
              for (final l in kLicensePlans)
                DropdownMenuItem(value: l, child: Text(l)),
            ],
            onChanged: (v) => setState(() => license = v),
          ),

          const SizedBox(height: 18),

          // ACCESS SCOPE
          _fieldLabel('Access Scope'),
          _dropdownBox<String>(
            value: scope,
            items: [
              for (final s in _scopes)
                DropdownMenuItem(value: s, child: Text(s)),
            ],
            onChanged: (v) => setState(() => scope = v),
          ),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '$_orgCount organizations selected  ·  ',
                style: const TextStyle(fontSize: 11.5, color: _textSoft),
              ),
              GestureDetector(
                onTap: _manageAccess,
                child: const Text(
                  'Manage Access',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _blue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // FEATURE CONFIGURATION (toggle)
          _fieldLabel('Feature Configuration'),
          Row(
            children: [
              Switch(
                value: enabled,
                onChanged: (v) => setState(() => enabled = v),
                activeThumbColor: Colors.white,
                activeTrackColor: _textStrong,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD1D5DB),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
              const SizedBox(width: 8),
              Text(
                enabled ? 'Enabled' : 'Disabled',
                style: const TextStyle(fontSize: 13.5, color: _textStrong),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // INFO BANNER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD6E4FF)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 17, color: Color(0xFF2F6BFF)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Changes are validated before saving and recorded in the Audit Log.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF2F4A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 2) ORGANIZATION ACCESS
// ============================================================

class OrganizationAccessPage extends StatefulWidget {
  final Map<String, dynamic> feature;
  final VoidCallback onSaved;

  const OrganizationAccessPage({
    super.key,
    required this.feature,
    required this.onSaved,
  });

  @override
  State<OrganizationAccessPage> createState() =>
      _OrganizationAccessPageState();
}

class _OrganizationAccessPageState extends State<OrganizationAccessPage> {
  late bool allOrganizations;
  late Set<String> selectedOrgs;

  @override
  void initState() {
    super.initState();
    allOrganizations = _scopeOf(widget.feature) == 'All Organizations';
    selectedOrgs = _orgsOf(widget.feature).toSet();
  }

  /// [Save Changes] → save, then go to Feature Usage Monitoring.
  void _save() {
    if (!allOrganizations && selectedOrgs.isEmpty) {
      _toast(context, 'Select at least one organization.');
      return;
    }

    // TODO: send to your API, and write the Audit Log entry.
    final f = widget.feature;
    f['accessScope'] =
        allOrganizations ? 'All Organizations' : 'Selected Organizations';
    f['orgs'] = allOrganizations ? <String>[] : selectedOrgs.toList();
    f['lastUpdated'] = _formatNow();
    widget.onSaved();

    _toast(context, 'Organization access saved.');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => FeatureUsagePage(feature: widget.feature),
      ),
    );
  }

  Widget _radioCard({
    required bool selected,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF7F8FB) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? _textStrong : Colors.transparent,
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? _textStrong : const Color(0xFF9AA4B2),
                  width: 1.4,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: _textStrong,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textStrong,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: _textSoft,
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

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        color: _textSoft,
      ),
    );
  }

  Widget _summaryItem(String label, String value, {bool mono = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              letterSpacing: 0.8,
              color: _textSoft,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: mono ? 'monospace' : null,
              color: _textStrong,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    final String summaryOrgs =
        allOrganizations ? 'All' : '${selectedOrgs.length} selected';

    return _PageShell(
      title: 'Organization Access',
      bottom: _CancelAndPrimary(
        primaryLabel: 'Save Changes',
        onPrimary: _save,
        onCancel: () => Navigator.of(context).pop(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('ORGANIZATION ACCESS'),
          const SizedBox(height: 12),

          _radioCard(
            selected: allOrganizations,
            title: 'All Organizations',
            subtitle: 'Enable this feature for all organizations.',
            onTap: () => setState(() => allOrganizations = true),
          ),
          const SizedBox(height: 10),
          _radioCard(
            selected: !allOrganizations,
            title: 'Selected Organizations',
            subtitle: 'Enable this feature only for selected organizations.',
            onTap: () => setState(() => allOrganizations = false),
          ),

          // ORGANIZATION CHECKLIST (only for "Selected Organizations")
          if (!allOrganizations) ...[
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _border),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < kSampleOrganizations.length; i++) ...[
                    if (i > 0)
                      const Divider(height: 1, color: Color(0xFFEEF0F4)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          final org = kSampleOrganizations[i];
                          if (!selectedOrgs.remove(org)) {
                            selectedOrgs.add(org);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: selectedOrgs
                                  .contains(kSampleOrganizations[i]),
                              onChanged: (v) {
                                setState(() {
                                  final org = kSampleOrganizations[i];
                                  if (v == true) {
                                    selectedOrgs.add(org);
                                  } else {
                                    selectedOrgs.remove(org);
                                  }
                                });
                              },
                              activeColor: _textStrong,
                              visualDensity: VisualDensity.compact,
                            ),
                            Expanded(
                              child: Text(
                                kSampleOrganizations[i],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _textStrong,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 26),

          _sectionTitle('ACCESS SUMMARY'),
          const SizedBox(height: 14),

          _summaryItem('FEATURE', f['name'] as String),
          _summaryItem('LICENSE PLAN', f['license'] as String),
          _summaryItem('SELECTED ORGANIZATIONS', summaryOrgs),
          _summaryItem(
            'LAST UPDATED',
            (f['lastUpdated'] as String?) ?? '14 Aug 2026, 10:42 AM',
            mono: true,
          ),

          const SizedBox(height: 4),

          if (!allOrganizations)
            const Text(
              'Only selected organizations will have access to this feature.',
              style: TextStyle(fontSize: 12, height: 1.4, color: _textSoft),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// 3) FEATURE USAGE MONITORING
//    Numbers are SAMPLE data — replace _usage() with your API data.
// ============================================================

class FeatureUsagePage extends StatelessWidget {
  final Map<String, dynamic> feature;

  const FeatureUsagePage({super.key, required this.feature});

  int get _seed =>
      (feature['name'] as String).codeUnits.fold(0, (a, b) => a + b);

  List<double> _trend() {
    return [
      for (var i = 0; i < 7; i++)
        (0.18 + i * 0.075 + 0.12 * math.sin(_seed + i * 2.1))
            .clamp(0.06, 0.95),
    ];
  }

  List<String> _dateLabels() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();

    return [
      for (var i = 6; i >= 0; i--)
        () {
          final d = now.subtract(Duration(days: i));
          return '${months[d.month - 1]} ${d.day.toString().padLeft(2, '0')}';
        }(),
    ];
  }

  Widget _infoItem(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 11.5, color: _textSoft),
          ),
          Flexible(child: value),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value, String change) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11.5, color: _textSoft),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _textStrong,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              change,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: _textStrong,
        ),
      ),
    );
  }

  Widget _activityRow(String org, String activities, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  org,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: _textStrong,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activities,
                  style: const TextStyle(fontSize: 11.5, color: _textSoft),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 11.5, color: _textSoft),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = feature['enabled'] as bool;
    final int orgs = _scopeOf(feature) == 'All Organizations'
        ? kSampleOrganizations.length
        : _orgsOf(feature).length;
    final int users = 1000 + _seed % 600;
    final int total = 3000 + (_seed * 7) % 2500;
    final int adoption = 55 + _seed % 35;
    final labels = _dateLabels();

    return _PageShell(
      title: 'Feature Usage Monitoring',
      bottom: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: _blue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Close',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FEATURE / MODULE / PLAN / STATUS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoItem(
                      'Feature',
                      Text(
                        feature['name'] as String,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _textStrong,
                        ),
                      ),
                    ),
                    _infoItem(
                      'Plan',
                      Text(
                        feature['license'] as String,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _textStrong,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoItem(
                      'Module',
                      Text(
                        feature['module'] as String,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _textStrong,
                        ),
                      ),
                    ),
                    _infoItem(
                      'Status',
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: enabled
                                  ? const Color(0xFF18A957)
                                  : _red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            enabled ? 'Enabled' : 'Disabled',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: enabled ? _green : _red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // USAGE SUMMARY
          _heading('Usage Summary'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statTile('Active Orgs', '$orgs', '↑ 8.3%'),
              _statTile('Active Users', _comma(users), '↑ 12.1%'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statTile('Total Usage', _comma(total), '↑ 5.7%'),
              _statTile('Adoption Rate', '$adoption%', '↑ 3.2%'),
            ],
          ),

          // USAGE TREND
          _heading('Usage Trend'),
          const SizedBox(height: 6),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(painter: _TrendPainter(_trend())),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final l in labels)
                Text(
                  l,
                  style: const TextStyle(fontSize: 9, color: _textSoft),
                ),
            ],
          ),

          // RECENT ACTIVITY
          _heading('Recent Activity'),
          _activityRow('Acme Corporation', '428 activities', '2 min ago'),
          const Divider(height: 1, color: Color(0xFFEEF0F4)),
          _activityRow('Globex Industries', '316 activities', '18 min ago'),
          const Divider(height: 1, color: Color(0xFFEEF0F4)),
          _activityRow('Initech Solutions', '284 activities', '42 min ago'),
        ],
      ),
    );
  }

  String _comma(int n) {
    final s = n.toString();
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return b.toString();
  }
}

class _TrendPainter extends CustomPainter {
  final List<double> values; // 0..1, higher = more usage

  const _TrendPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFEEF0F4)
      ..strokeWidth = 1;

    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final line = Paint()
      ..color = const Color(0xFF2F3FE0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(_TrendPainter old) => old.values != values;
}