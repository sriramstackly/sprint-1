import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

// ============================================================
// EXPORT FEATURE MANAGEMENT REPORT  (full page)
//
// Opened by the blue "Export Report" button on the Feature
// Management page.
//
//   Export Report Name        (editable, default Feature_Management_Report_<today>)
//   Export Scope              All / Enabled / Disabled features
//   Document Format           CSV / Excel / PDF
//   Telemetry & Usage Interval  Today / Last 7 Days / Last 30 Days
//   Include Data Sections     3 checkboxes
//   [Cancel]  [Download Export]
//
// The file is built in plain Dart (no packages):
//   CSV   → real .csv      Excel → SpreadsheetML .xls (opens in Excel)
//   PDF   → real multi-page PDF
//
// Saving to the device needs one small package — see _saveFile().
// The telemetry numbers are SAMPLE data: replace _metricsFor() with
// your real API data.
// ============================================================

class ExportFeatureReportPage extends StatefulWidget {
  /// The feature list from the Feature Management page
  /// (name, module, license, enabled).
  final List<Map<String, dynamic>> features;

  const ExportFeatureReportPage({super.key, required this.features});

  @override
  State<ExportFeatureReportPage> createState() =>
      _ExportFeatureReportPageState();
}

class _ExportFeatureReportPageState
    extends State<ExportFeatureReportPage> {
  static const Color _navy = Color(0xFF1E2A5A);
  static const Color _blue = Color(0xFF1726D8);
  static const Color _green = Color(0xFF3FAE5A);
  static const Color _textStrong = Color(0xFF172033);
  static const Color _textSoft = Color(0xFF5F6B80);
  static const Color _border = Color(0xFFD5DBE7);

  static const List<String> _scopes = [
    'All Features (65 records)',
    'Enabled Features (52 records)',
    'Disabled Features (13 records)',
  ];

  static const List<String> _formats = [
    'CSV (Comma Separated)',
    'Excel Spreadsheet (.xls)',
    'PDF Document',
  ];

  static const List<String> _intervals = [
    'Today',
    'Last 7 Days',
    'Last 30 Days',
  ];

  late final TextEditingController nameController;

  String scope = _scopes[0];
  String format = _formats[0];
  String interval = _intervals[2];

  bool includeAdoption = true;
  bool includeLimits = false;
  bool includeLicense = false;

  bool exporting = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    nameController = TextEditingController(
      text: 'Feature_Management_Report_${_date(now)}',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String _date(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

  String get _extension {
    if (format.startsWith('CSV')) return 'csv';
    if (format.startsWith('Excel')) return 'xls';
    return 'pdf';
  }

  // ------------------------------------------------------------
  // WHICH FEATURES ARE EXPORTED
  // ------------------------------------------------------------

  List<Map<String, dynamic>> _selectedFeatures() {
    if (scope == _scopes[1]) {
      return widget.features.where((f) => f['enabled'] == true).toList();
    }
    if (scope == _scopes[2]) {
      return widget.features.where((f) => f['enabled'] != true).toList();
    }
    return List<Map<String, dynamic>>.from(widget.features);
  }

  /// SAMPLE telemetry — replace with your real API data.
  Map<String, String> _metricsFor(Map<String, dynamic> feature) {
    final String name = feature['name'] as String;
    final String license = feature['license'] as String;
    final int seed = name.codeUnits.fold(0, (a, b) => a + b);

    final int days = interval == 'Today'
        ? 1
        : interval == 'Last 7 Days'
            ? 7
            : 30;

    const limits = ['500 req/min', '1000 req/min', '2000 req/min', '5000 req/min'];
    const flags = ['Audit logged', 'Approval required', 'None'];

    return {
      'Tenant Adoption': '${40 + seed % 55}%',
      'API Calls': '${((seed * 37) % 9000 + 1000) * days}',
      'Avg Latency': '${60 + seed % 140} ms',
      'Rate Limit': limits[seed % 4],
      'Concurrency': '${20 + seed % 80}',
      'Governance Flag': flags[seed % 3],
      'License Tier': license,
      'Notes': 'Requires $license plan',
    };
  }

  // ------------------------------------------------------------
  // TABLE (shared by CSV / Excel / PDF)
  // ------------------------------------------------------------

  List<String> _headers() {
    return [
      'Feature Name',
      'Module',
      'License',
      'Status',
      if (includeAdoption) ...['Tenant Adoption', 'API Calls', 'Avg Latency'],
      if (includeLimits) ...['Rate Limit', 'Concurrency', 'Governance Flag'],
      if (includeLicense) ...['License Tier', 'Notes'],
    ];
  }

  List<List<String>> _dataRows() {
    final headers = _headers();

    return [
      for (final f in _selectedFeatures())
        () {
          final m = _metricsFor(f);
          final base = {
            'Feature Name': f['name'] as String,
            'Module': f['module'] as String,
            'License': f['license'] as String,
            'Status': (f['enabled'] == true) ? 'Enabled' : 'Disabled',
          };
          return [
            for (final h in headers) base[h] ?? m[h] ?? '',
          ];
        }(),
    ];
  }

  List<List<String>> _metaRows(String reportName, DateTime now) {
    return [
      [reportName],
      ['Scope', scope],
      ['Interval', interval],
      ['Generated', '${_date(now)} ${_two(now.hour)}:${_two(now.minute)}'],
      [],
    ];
  }

  // ------------------------------------------------------------
  // FILE BUILDERS
  // ------------------------------------------------------------

  Uint8List _buildCsv(List<List<String>> rows) {
    String cell(String v) {
      if (v.contains(',') || v.contains('"') || v.contains('\n')) {
        return '"${v.replaceAll('"', '""')}"';
      }
      return v;
    }

    final text = rows.map((r) => r.map(cell).join(',')).join('\r\n');

    // BOM so Excel opens UTF-8 correctly.
    return Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(text)]);
  }

  Uint8List _buildExcelXml(List<List<String>> rows) {
    String esc(String v) => v
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');

    final b = StringBuffer()
      ..write('<?xml version="1.0" encoding="UTF-8"?>')
      ..write('<?mso-application progid="Excel.Sheet"?>')
      ..write('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" '
          'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">')
      ..write('<Worksheet ss:Name="Feature Report"><Table>');

    for (final row in rows) {
      b.write('<Row>');
      for (final v in row) {
        b.write('<Cell><Data ss:Type="String">${esc(v)}</Data></Cell>');
      }
      b.write('</Row>');
    }

    b.write('</Table></Worksheet></Workbook>');
    return Uint8List.fromList(utf8.encode(b.toString()));
  }

  Uint8List _buildPdf(List<List<String>> meta, List<String> headers,
      List<List<String>> data) {
    // lines: [text, size, bold]
    final lines = <(String, double, bool)>[
      (meta.first.first, 18, true),
      for (final m in meta.skip(1))
        if (m.isNotEmpty) ('${m[0]}: ${m.length > 1 ? m[1] : ''}', 10, false),
      ('', 8, false),
    ];

    for (final row in data) {
      lines.add((row[0], 12, true));
      for (var i = 1; i < headers.length; i++) {
        lines.add(('   ${headers[i]}: ${row[i]}', 10, false));
      }
      lines.add(('', 6, false));
    }

    if (data.isEmpty) {
      lines.add(('No features match this scope.', 11, false));
    }

    String esc(String s) {
      final b = StringBuffer();
      for (final c in s.codeUnits) {
        if (c == 0x5C || c == 0x28 || c == 0x29) {
          b.write('\\');
          b.writeCharCode(c);
        } else if (c < 32 || c > 126) {
          b.write('?');
        } else {
          b.writeCharCode(c);
        }
      }
      return b.toString();
    }

    // lay out on pages
    final streams = <StringBuffer>[StringBuffer()];
    double y = 790;

    for (final l in lines) {
      if (y < 60) {
        streams.add(StringBuffer());
        y = 790;
      }
      if (l.$1.isNotEmpty) {
        streams.last.write(
          'BT /${l.$3 ? 'F2' : 'F1'} ${l.$2} Tf 50 ${y.toStringAsFixed(1)} Td (${esc(l.$1)}) Tj ET\n',
        );
      }
      y -= l.$2 + 6;
    }

    final n = streams.length;
    final objs = <String>[
      '<< /Type /Catalog /Pages 2 0 R >>',
      '<< /Type /Pages /Kids [${[
        for (var i = 0; i < n; i++) '${5 + 2 * i} 0 R'
      ].join(' ')}] /Count $n >>',
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>',
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>',
    ];

    for (var i = 0; i < n; i++) {
      final c = streams[i].toString();
      objs.add('<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] '
          '/Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> '
          '/Contents ${6 + 2 * i} 0 R >>');
      objs.add('<< /Length ${c.length} >>\nstream\n$c\nendstream');
    }

    final out = StringBuffer('%PDF-1.4\n');
    final offsets = <int>[];

    for (var i = 0; i < objs.length; i++) {
      offsets.add(out.length);
      out.write('${i + 1} 0 obj\n${objs[i]}\nendobj\n');
    }

    final xref = out.length;
    out.write('xref\n0 ${objs.length + 1}\n0000000000 65535 f \n');
    for (final o in offsets) {
      out.write('${o.toString().padLeft(10, '0')} 00000 n \n');
    }
    out.write(
        'trailer\n<< /Size ${objs.length + 1} /Root 1 0 R >>\nstartxref\n$xref\n%%EOF');

    return Uint8List.fromList(out.toString().codeUnits);
  }

  // ------------------------------------------------------------
  // DOWNLOAD
  // ------------------------------------------------------------

  Future<void> _download() async {
    if (exporting) return;

    final String reportName = nameController.text.trim();

    if (reportName.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Enter an export report name.'),
          ),
        );
      return;
    }

    FocusScope.of(context).unfocus();

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => exporting = true);

    try {
      final now = DateTime.now();
      final headers = _headers();
      final data = _dataRows();
      final meta = _metaRows(reportName, now);

      final Uint8List bytes;

      if (_extension == 'pdf') {
        bytes = _buildPdf(meta, headers, data);
      } else {
        final rows = [...meta, headers, ...data];
        bytes = _extension == 'csv' ? _buildCsv(rows) : _buildExcelXml(rows);
      }

      final safeName = reportName.replaceAll(RegExp(r'[^A-Za-z0-9_.\-]'), '_');
      final fileName = '$safeName.$_extension';

      await _saveFile(fileName, bytes);

      if (!mounted) return;

      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Export ready: $fileName (${(bytes.length / 1024).toStringAsFixed(1)} KB)',
            ),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      setState(() => exporting = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Export failed. Please try again.'),
          ),
        );
    }
  }

  /// SAVES THE FILE.
  ///
  /// Stock Flutter cannot write to the Downloads folder, so this is the
  /// one place that needs a package. Add to pubspec.yaml:
  ///
  ///   file_saver: ^0.2.14
  ///
  /// then `import 'package:file_saver/file_saver.dart';` and replace the
  /// body with:
  ///
  ///   final dot = fileName.lastIndexOf('.');
  ///   await FileSaver.instance.saveFile(
  ///     name: fileName.substring(0, dot),
  ///     bytes: bytes,
  ///     fileExtension: fileName.substring(dot + 1),
  ///     mimeType: switch (_extension) {
  ///       'csv' => MimeType.csv,
  ///       'xls' => MimeType.microsoftExcel,
  ///       _ => MimeType.pdf,
  ///     },
  ///   );
  Future<void> _saveFile(String fileName, Uint8List bytes) async {
    // Placeholder so the app compiles with stock Flutter only.
    // `bytes` is already a complete, valid file.
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

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
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Export Report Name'),
                        _nameField(),
                        const SizedBox(height: 18),
                        _label('Export Scope'),
                        _dropdown(
                          value: scope,
                          items: _scopes,
                          onChanged: (v) => setState(() => scope = v),
                        ),
                        const SizedBox(height: 18),
                        _label('Document Format'),
                        _dropdown(
                          value: format,
                          items: _formats,
                          onChanged: (v) => setState(() => format = v),
                        ),
                        const SizedBox(height: 18),
                        _label('Telemetry & Usage Interval'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final i in _intervals) _pill(i),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _label('Include Data Sections'),
                        _checkRow(
                          'Include tenant adoption, daily calls & latency stats',
                          includeAdoption,
                          (v) => setState(() => includeAdoption = v),
                        ),
                        _checkRow(
                          'Include rate limits, concurrency & governance flags',
                          includeLimits,
                          (v) => setState(() => includeLimits = v),
                        ),
                        _checkRow(
                          'Include license tier requirements and feature notes',
                          includeLicense,
                          (v) => setState(() => includeLicense = v),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 18, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: exporting ? null : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, size: 20),
            color: _textStrong,
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Export Feature Management Report',
              style: TextStyle(
                fontSize: 17,
                height: 1.25,
                fontWeight: FontWeight.w700,
                color: _textStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _textStrong,
        ),
      ),
    );
  }

  // REPORT NAME (dark border, pencil icon)
  Widget _nameField() {
    return TextField(
      controller: nameController,
      enabled: !exporting,
      style: const TextStyle(fontSize: 13, color: _textStrong),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: const Icon(
          Icons.edit_outlined,
          size: 17,
          color: _textSoft,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _navy, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _navy, width: 1.6),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _border),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: _textSoft,
          ),
          style: const TextStyle(fontSize: 13, color: _textStrong),
          items: [
            for (final item in items)
              DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: exporting
              ? null
              : (v) {
                  if (v != null) onChanged(v);
                },
        ),
      ),
    );
  }

  Widget _pill(String label) {
    final bool selected = interval == label;

    return InkWell(
      onTap: exporting ? null : () => setState(() => interval = label),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? _navy : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : _textSoft,
          ),
        ),
      ),
    );
  }

  Widget _checkRow(
    String text,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: exporting ? null : () => onChanged(!value),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                onChanged: exporting ? null : (v) => onChanged(v ?? false),
                activeColor: _green,
                checkColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: _border, width: 1.4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: _textSoft,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEF0F4))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 48,
              child: TextButton(
                onPressed: exporting ? null : () => Navigator.of(context).pop(),
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
              child: ElevatedButton.icon(
                onPressed: exporting ? null : _download,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _blue.withValues(alpha: 0.7),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: exporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.file_download_outlined, size: 18),
                label: Text(
                  exporting ? 'Preparing…' : 'Download Export',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}