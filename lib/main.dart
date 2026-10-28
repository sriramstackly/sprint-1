// NOTE ABOUT THE FIRST SCREEN (NEW)
// ---------------------------------
// The app opens on WelcomePage. It is drawn fully in code (logo, headline,
// glowing ring with the "1E" badge, four cards, footer and the SIGN IN
// button), so it does not need any picture file. Tapping SIGN IN opens the
// login page. On the login page, the phone's back button returns to the
// welcome page.
//
// NOTE ABOUT THE LOGO UPLOAD FIELD
// ---------------------------------
// The "Upload logo" box below is a placeholder (tapping it shows a
// snackbar) so this file compiles with ONLY stock Flutter — no extra
// packages required. To let people actually pick a real image file,
// add the `image_picker` package to pubspec.yaml:
//
//   dependencies:
//     image_picker: ^1.1.2
//
// then run `flutter pub get`, add `import 'package:image_picker/
// image_picker.dart';` at the top of this file, and replace the body
// of pickLogo() below with:
//
//   final file = await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (file == null) return;
//   final bytes = await file.readAsBytes();
//   setState(() { logoBytes = bytes; logoFileName = file.name; });
//
// The rest of the UI (thumbnail preview, remove button) already
// supports this — it just needs real bytes to display.
//
// NOTE ABOUT THE DEMO PASSWORD CHECK
// ---------------------------------
// There is no backend yet, so the password step uses a fake check
// (see _checkPassword). A password chosen on the Create Account page
// works for that email on the sign in page. For any other email, the
// only password that works is "Password@123" (while _demoValidation
// is true). A wrong password counts as a failed attempt; after 5 the
// account locks for 15 minutes. Replace _checkPassword with your
// real login API call.
//
// After the correct password the app goes straight to LandingPage.
// Set _requireTwoStep to true to bring back the 6-digit code step.
//
// NOTE ABOUT THE MOBILE HEADER
// ---------------------------------
// On phones / narrow windows there's no room for the full left-side
// panel, so MobileBrandHeader shows a cropped, edge-to-edge slice of
// the SAME assets/icons/image.png used on desktop — just the logo,
// eyebrow line and headline, with the lower part (diagram, footer)
// clipped off. The crop height is `screen width * _kHeaderAspect`;
// tweak _kHeaderAspect below if your image needs a taller/shorter
// slice to stop exactly before the circular diagram begins.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/landing_page.dart';

// ============================================================
// APP COLORS
// ============================================================

class AppColors {
  static const Color navy = Color(0xFF101331);
  static const Color black = Color(0xFF000000);
  static const Color text = Color(0xFF11142F);
  static const Color muted = Color(0xFF6B7280);
  static const Color hint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE2E5EA);
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color teal = Color(0xFF3CC8B4);
  static const Color link = Color(0xFF2F6BFF);
  static const Color progressDone = Color(0xFF6C63FF);
  static const Color bannerBg = Color(0xFFEEF0FF);
  static const Color bannerBorder = Color(0xFFDCE0FA);
  static const Color successBg = Color(0xFFE3F6EA);
  static const Color success = Color(0xFF1FA463);

  // Welcome screen
  static const Color welcomeButton = Color(0xFF2B35D9);

  // Error / lockout colors
  static const Color error = Color(0xFFB42318);
  static const Color errorField = Color(0xFFE0524A);
  static const Color errorBg = Color(0xFFFDECEC);
  static const Color errorBorder = Color(0xFFF6C8C8);
  static const Color warnBg = Color(0xFFFBF1DC);
  static const Color warnBorder = Color(0xFFF3E1B5);
  static const Color warnText = Color(0xFF8A5A00);
  static const Color lockBg = Color(0xFFFCE4E4);
}

// ============================================================
// MAIN
// ============================================================

void main() {
  runApp(const MyApp());
}

// ============================================================
// MY APP
// ============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outline(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'One Enterprise',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          hintStyle: const TextStyle(color: AppColors.hint, fontSize: 13),
          border: outline(AppColors.border),
          enabledBorder: outline(AppColors.border),
          focusedBorder: outline(AppColors.navy, 1.3),
        ),
      ),
      home: const StartPage(),
    );
  }
}

// ============================================================
// START PAGE
//   Decides which screen opens first. Always the WelcomePage.
// ============================================================

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomePage();
  }
}

// ============================================================
// WELCOME PAGE
//   First screen, drawn fully in code (no picture file needed):
//   logo, headline, glowing ring with the "1E" badge and four
//   cards (People, Applications, Security, Analytics), a footer
//   line and the SIGN IN button.
//   SIGN IN opens the login page.
// ============================================================

class _WelcomeColors {
  static const Color background = Color(0xFF05070F);
  static const Color card = Color(0xFF0C1226);
  static const Color cardBorder = Color(0xFF22305F);
  static const Color iconBox = Color(0xFF16224A);
  static const Color blue = Color(0xFF3D6BFF);
  static const Color blueSoft = Color(0xFF86A5FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFA9B3D6);
  static const Color eyebrow = Color(0xFFB8C2FF);
  static const Color line = Color(0xFF2C3868);
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _openLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _WelcomeColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 480,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // TOP: logo, small line, headline, dotted line
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF5B7CFF),
                                        Color(0xFF2B35D9),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.layers_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'STACKLY',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                    color: _WelcomeColors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'CLOUD PLATFORM · HRMS · CRM · ERP · FINANCE · AI',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                letterSpacing: 1.2,
                                height: 1.5,
                                color: _WelcomeColors.eyebrow,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'One identity.\n',
                                    style: TextStyle(
                                      color: _WelcomeColors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Infinite ',
                                    style: TextStyle(
                                      color: _WelcomeColors.blue,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Potential.',
                                    style: TextStyle(
                                      color: _WelcomeColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const _DashedLine(),
                          ],
                        ),
                      ),

                      // MIDDLE: ring + badge + four cards
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: _WelcomeDiagram(),
                        ),
                      ),

                      // BOTTOM: dotted line, footer, SIGN IN button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _DashedLine(),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 2,
                                        color: _WelcomeColors.blue,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Secure  ·  Scalable  ·  Future-Ready',
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 9.5,
                                          letterSpacing: 0.5,
                                          color: _WelcomeColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'BUILT FOR\nA BRIGHTER\nTOMORROW',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 8.5,
                                    letterSpacing: 1.2,
                                    height: 1.4,
                                    color: _WelcomeColors.muted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x663D6BFF),
                                    blurRadius: 24,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: () => _openLogin(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.welcomeButton,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                    ),
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
          },
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// DASHED LINE (blue dotted divider)
// ------------------------------------------------------------

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 2,
      child: CustomPaint(
        painter: _DashedLinePainter(_WelcomeColors.blue),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + 3, size.height / 2),
        paint,
      );
      x += 7;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// ------------------------------------------------------------
// DIAGRAM (glowing ring, "1E" badge, four cards)
// ------------------------------------------------------------

class _WelcomeDiagram extends StatelessWidget {
  const _WelcomeDiagram();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        final double h = constraints.maxHeight;
        final double cardW = w * 0.44;
        const double cardH = 70;
        final double topY = h * 0.07;
        final double bottomY = h - cardH - h * 0.07;
        final double ringRadius = w * 0.30;

        return Stack(
          children: [
            // RING, GLOW AND LINES
            Positioned.fill(
              child: CustomPaint(
                painter: _DiagramPainter(
                  cardW: cardW,
                  cardH: cardH,
                  topY: topY,
                  bottomY: bottomY,
                  ringRadius: ringRadius,
                ),
              ),
            ),

            // TOP LEFT CARD
            Positioned(
              left: 0,
              top: topY,
              width: cardW,
              height: cardH,
              child: const _InfoCard(
                icon: Icons.groups_outlined,
                title: 'People',
                subtitle: 'Manage users & teams',
              ),
            ),

            // TOP RIGHT CARD
            Positioned(
              right: 0,
              top: topY,
              width: cardW,
              height: cardH,
              child: const _InfoCard(
                icon: Icons.apps_rounded,
                title: 'Applications',
                subtitle: 'Integrate & manage',
              ),
            ),

            // BOTTOM LEFT CARD
            Positioned(
              left: 0,
              top: bottomY,
              width: cardW,
              height: cardH,
              child: const _InfoCard(
                icon: Icons.shield_outlined,
                title: 'Security',
                subtitle: 'Protect every access',
              ),
            ),

            // BOTTOM RIGHT CARD
            Positioned(
              right: 0,
              top: bottomY,
              width: cardW,
              height: cardH,
              child: const _InfoCard(
                icon: Icons.bar_chart_rounded,
                title: 'Analytics',
                subtitle: 'Turn data into insights',
              ),
            ),

            // CENTER "1E" BADGE
            Positioned(
              left: w / 2 - 32,
              top: h / 2 - 32,
              width: 64,
              height: 64,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _WelcomeColors.blueSoft,
                    width: 1.5,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B2A66), Color(0xFF0A1030)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x883D6BFF),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const Text(
                  '1E',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _WelcomeColors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DiagramPainter extends CustomPainter {
  final double cardW;
  final double cardH;
  final double topY;
  final double bottomY;
  final double ringRadius;

  const _DiagramPainter({
    required this.cardW,
    required this.cardH,
    required this.topY,
    required this.bottomY,
    required this.ringRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // SOFT BLUE GLOW BEHIND THE RING
    final double glowRadius = ringRadius * 1.5;
    final Paint glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x403D6BFF), Color(0x00000000)],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
    canvas.drawCircle(center, glowRadius, glowPaint);

    // LINES FROM THE CENTER TO EACH CARD
    final Paint linePaint = Paint()
      ..color = _WelcomeColors.line
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;

    final List<Offset> targets = [
      Offset(cardW, topY + cardH / 2),
      Offset(size.width - cardW, topY + cardH / 2),
      Offset(cardW, bottomY + cardH / 2),
      Offset(size.width - cardW, bottomY + cardH / 2),
    ];
    for (final Offset target in targets) {
      canvas.drawLine(center, target, linePaint);
    }

    // RING GLOW
    final Paint ringGlow = Paint()
      ..color = const Color(0x773D6BFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, ringRadius, ringGlow);

    // RING
    final Paint ring = Paint()
      ..color = _WelcomeColors.blueSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, ringRadius, ring);

    // THIN INNER RING
    final Paint innerRing = Paint()
      ..color = const Color(0x553D6BFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, ringRadius * 0.82, innerRing);
  }

  @override
  bool shouldRepaint(covariant _DiagramPainter oldDelegate) {
    return oldDelegate.cardW != cardW ||
        oldDelegate.cardH != cardH ||
        oldDelegate.topY != topY ||
        oldDelegate.bottomY != bottomY ||
        oldDelegate.ringRadius != ringRadius;
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _WelcomeColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _WelcomeColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _WelcomeColors.iconBox,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 17, color: _WelcomeColors.blueSoft),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _WelcomeColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    height: 1.3,
                    color: _WelcomeColors.muted,
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
// LOGIN PAGE
// ============================================================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool desktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: Colors.white,
      // Mobile isn't wrapped in SafeArea here: MobileBrandHeader paints
      // the status-bar area itself (edge-to-edge black), and LoginForm
      // applies SafeArea(top: false) internally around the scrollable
      // form so only the bottom / side insets are respected there.
      body: desktop
          ? Row(
              children: [
                // LEFT PANEL
                const Expanded(flex: 52, child: LeftImagePanel()),

                // DIVIDER
                Container(width: 1, color: const Color(0xFFE1E4E9)),

                // RIGHT LOGIN PANEL
                const Expanded(flex: 48, child: LoginForm()),
              ],
            )
          : const LoginForm(compact: true),
    );
  }
}

// ============================================================
// LEFT IMAGE PANEL
// ============================================================

class LeftImagePanel extends StatelessWidget {
  const LeftImagePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        'assets/icons/image.png',
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'image.png not found',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// LOGIN FORM
//   Desktop (compact=false): centered, scrollable, padded column.
//   Mobile (compact=true): full-bleed MobileBrandHeader pinned to
//   the top, with the scrollable padded form filling the rest of
//   the screen underneath it.
// ============================================================

class LoginForm extends StatelessWidget {
  final bool compact;

  const LoginForm({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MobileBrandHeader(),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: const LoginContent(),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Center(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: const LoginContent(),
        ),
      ),
    );
  }
}

// ============================================================
// AUTH VIEW
//   Which UI is currently shown inside LoginContent.
//   Everything stays on the same page/route — this only
//   switches which block of widgets is built.
// ============================================================

enum AuthView {
  signIn,
  createAccount,
  welcome,
  forgotPassword,
  checkEmail,
  locked,
}

// ============================================================
// LOGIN CONTENT
//   Sign in flow (same page):
//     Step 0: workspace + work email      → [Continue]
//     Step 1: password                    → [Sign in]
//               wrong password  → red error banner + attempts left
//               5 wrong attempts → "This account is locked" screen
//               "Forgot password?" → Forgot password flow
//     Step 2: two-step verification code  → [Verify and sign in]
//                                            → LandingPage
//
//   Forgot password flow (same page):
//     Forgot your password?  → [Send reset link]
//     Check your email       → [Resend email] / [Back to sign in]
//
//   Locked screen:
//     Countdown (15:00) → [Reset password] / [Back to sign in]
//
//   Create Account flow (same page, no navigation):
//     orgStep 0 — Organization details    → [Continue]
//     orgStep 1 — Super admin account     → [Continue]
//     orgStep 2 — Review and confirm      → [Create account]
//                                            → Welcome screen
//
//   Welcome screen:
//     [Go to sign in] → back to Sign in (workspace + email filled)
//     [Resend verification] → shows a message
// ============================================================

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  // ----------------------------------------------------------
  // SIGN IN controllers / state
  // ----------------------------------------------------------

  final TextEditingController workspaceController =
      TextEditingController(text: 'acmecorp');
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final FocusNode passwordFocus = FocusNode();
  final FocusNode codeFocus = FocusNode();

  int step = 0; // 0 = identify, 1 = password, 2 = verify
  bool hidePassword = true;

  // Verification code countdown
  static const Duration _codeLifetime = Duration(minutes: 5);
  final ValueNotifier<int> _secondsLeft = ValueNotifier<int>(0);
  Timer? _timer;

  static const List<String> _eyebrows = [
    'STEP 1 OF 3 · IDENTIFY',
    'STEP 2 OF 3 · PASSWORD',
    'STEP 3 OF 3 · VERIFY',
  ];

  static const List<String> _titles = [
    'Sign in',
    'Enter your password',
    'Two-Step Verification',
  ];

  String get _signInEyebrow {
    if (_requireTwoStep) return _eyebrows[step];
    return step == 0
        ? 'STEP 1 OF 2 · IDENTIFY'
        : 'STEP 2 OF 2 · PASSWORD';
  }

  String get _subtitle {
    switch (step) {
      case 0:
        return 'Enter your workspace and work email to continue.';
      case 1:
        return 'Signing in to ${workspaceController.text.trim()}.';
      default:
        return 'Enter the 6-digit code from your authenticator app.';
    }
  }

  // ----------------------------------------------------------
  // PASSWORD ATTEMPTS / LOCKOUT / FORGOT PASSWORD
  // ----------------------------------------------------------

  static const int _maxAttempts = 5;
  static const Duration _lockDuration = Duration(minutes: 15);

  // Demo only — replace _checkPassword with your real API call.
  static const bool _demoValidation = true;
  static const String _demoPassword = 'Password@123';

  // After the correct password, go straight to the landing page.
  // Set to true to also require the 6-digit verification step.
  static const bool _requireTwoStep = false;

  // Accounts created on this page (demo only, kept in memory).
  // email (lowercase) -> password
  final Map<String, String> _registeredAccounts = {};

  final TextEditingController forgotEmailController = TextEditingController();

  int failedAttempts = 0;
  bool passwordError = false; // shows the red banner + red field border
  bool rememberDevice = true;

  String? _attemptsEmail; // whose failed attempts we are counting
  String? _lockedEmail; // which email is currently locked (lowercase)
  String resetEmail = ''; // where the reset link was sent

  final ValueNotifier<int> _lockSecondsLeft = ValueNotifier<int>(0);
  Timer? _lockTimer;

  // ----------------------------------------------------------
  // CREATE ACCOUNT — orgStep 0 : Organization details
  // ----------------------------------------------------------

  AuthView view = AuthView.signIn;
  int orgStep = 0; // 0 = organization, 1 = super admin, 2 = review and confirm

  final TextEditingController organizationNameController =
      TextEditingController();
  final TextEditingController organizationCodeController =
      TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final FocusNode organizationCodeFocus = FocusNode();

  bool _codeEditedManually = false;
  bool submittingAccount = false;

  static const List<String> _orgTypes = [
    'Enterprise',
    'Startup',
    'SMB',
    'Non-profit',
    'Government',
  ];
  static const List<String> _industries = [
    'Information Technology',
    'Finance',
    'Healthcare',
    'Manufacturing',
    'Retail',
    'Education',
    'Other',
  ];
  static const List<String> _companySizes = [
    '1-50',
    '51-200',
    '201-500',
    '501-1000',
    '1000+',
  ];
  static const List<String> _countries = [
    'India',
    'United States',
    'United Kingdom',
    'Germany',
    'Singapore',
    'Australia',
    'Other',
  ];
  static const List<String> _statesProvinces = [
    'Andhra Pradesh',
    'Delhi',
    'Karnataka',
    'Maharashtra',
    'Tamil Nadu',
    'Telangana',
    'Other',
  ];
  static const List<String> _timeZones = [
    'Asia/Kolkata (UTC +05:30)',
    'Asia/Dubai (UTC +04:00)',
    'Asia/Singapore (UTC +08:00)',
    'Europe/London (UTC +00:00)',
    'America/New_York (UTC -05:00)',
  ];

  String? orgType = 'Enterprise';
  String? industry = 'Information Technology';
  String? companySize = '501-1000';
  String? country = 'India';
  String? stateProvince = 'Telangana';
  String? timeZone = 'Asia/Kolkata (UTC +05:30)';

  // Logo (real file picking via image_picker)
  Uint8List? logoBytes;
  String? logoFileName;

  // ----------------------------------------------------------
  // CREATE ACCOUNT — orgStep 1 : Super admin account
  // ----------------------------------------------------------

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController officialEmailController =
      TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController adminPasswordController =
      TextEditingController();
  final TextEditingController adminConfirmPasswordController =
      TextEditingController();

  bool hideAdminPassword = true;
  bool hideAdminConfirmPassword = true;

  // ----------------------------------------------------------
  // CREATE ACCOUNT — orgStep 2 : Review and confirm
  // ----------------------------------------------------------

  bool agreeTerms = false; // required
  bool agreeAuthorized = false; // required
  bool agreeDataProcessing = false; // required
  bool agreeUpdates = true; // optional

  @override
  void initState() {
    super.initState();
    organizationNameController.addListener(_autoFillOrganizationCode);
  }

  /// Auto-generates the Organization Code from the Organization Name,
  /// unless the person has chosen to edit the code manually.
  void _autoFillOrganizationCode() {
    if (_codeEditedManually) return;

    final words = organizationNameController.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    String generated = '';
    if (words.length >= 2) {
      final second =
          words[1].length > 4 ? words[1].substring(0, 4) : words[1];
      generated = '${words[0].toUpperCase()}-${second.toUpperCase()}';
    } else if (words.length == 1) {
      generated = words[0].toUpperCase();
    }

    organizationCodeController.value = TextEditingValue(
      text: generated,
      selection: TextSelection.collapsed(offset: generated.length),
    );
  }

  void _editCodeManually() {
    _codeEditedManually = true;
    organizationCodeFocus.requestFocus();
  }

  /// The workspace name made from the organization code,
  /// for example "ABC-TECH" becomes "abc-tech".
  String get _workspaceSlug {
    final code = organizationCodeController.text.trim().toLowerCase();
    if (code.isEmpty) return 'your-workspace';
    return code.replaceAll(RegExp(r'[^a-z0-9_-]'), '-');
  }

  // ==========================================================
  // ACTIONS — shared
  // ==========================================================

  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  /// Back to the first sign in step (workspace + email).
  void goToSignIn() {
    FocusScope.of(context).unfocus();
    passwordController.clear();
    setState(() {
      view = AuthView.signIn;
      step = 0;
      orgStep = 0;
      passwordError = false;
    });
  }

  // ==========================================================
  // ACTIONS — sign in
  // ==========================================================

  /// True while [email] is locked and the countdown is still running.
  bool _isLockedNow(String email) {
    return _lockedEmail != null &&
        _lockedEmail == email.trim().toLowerCase() &&
        _lockSecondsLeft.value > 0;
  }

  /// Step 0 → Step 1 : "Continue"
  void continueToPassword() {
    final workspace = workspaceController.text.trim();
    final email = emailController.text.trim();

    if (workspace.isEmpty) {
      showMessage('Enter your workspace.');
      return;
    }
    if (email.isEmpty) {
      showMessage('Enter your work email.');
      return;
    }
    if (!_isValidEmail(email)) {
      showMessage('Enter a valid work email.');
      return;
    }

    FocusScope.of(context).unfocus();

    // Count failed attempts per email.
    final key = email.toLowerCase();
    if (_attemptsEmail != key) {
      _attemptsEmail = key;
      failedAttempts = 0;
    }
    passwordController.clear();

    // Still locked? Show the locked screen instead of the password step.
    if (_isLockedNow(email)) {
      setState(() {
        passwordError = false;
        view = AuthView.locked;
      });
      return;
    }

    setState(() {
      passwordError = false;
      step = 1;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) passwordFocus.requestFocus();
    });
  }

  /// Fake password check. TODO: replace with your login API
  /// (workspace + email + password).
  bool _checkPassword(String email, String password) {
    // An account created on the Create Account page uses its own password.
    final saved = _registeredAccounts[email.trim().toLowerCase()];
    if (saved != null) return password == saved;

    if (!_demoValidation) return true;
    return password == _demoPassword;
  }

  /// "Switch" on the account chip — pick a different account.
  void switchAccount() {
    FocusScope.of(context).unfocus();
    passwordController.clear();
    setState(() {
      passwordError = false;
      step = 0;
    });
  }

  /// Step 1 → Step 2 : "Sign in"
  void signIn() {
    final email = emailController.text.trim();

    if (_isLockedNow(email)) {
      setState(() => view = AuthView.locked);
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      showMessage('Enter your password.');
      return;
    }

    if (!_checkPassword(email, passwordController.text)) {
      failedAttempts++;

      if (failedAttempts >= _maxAttempts) {
        _lockAccount(email);
        return;
      }

      // Wrong password: show the red banner, empty the field.
      passwordController.clear();
      setState(() => passwordError = true);
      passwordFocus.requestFocus();
      return;
    }

    // Password accepted.
    failedAttempts = 0;
    passwordError = false;

    // TODO: send `rememberDevice` to your API so it can skip the
    // two-step code on this device for 30 days.

    TextInput.finishAutofillContext();
    FocusScope.of(context).unfocus();

    // Correct password → straight to the landing page.
    if (!_requireTwoStep) {
      _openLandingPage();
      return;
    }

    codeController.clear();
    setState(() => step = 2);
    _startCodeTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) codeFocus.requestFocus();
    });
  }

  void _openLandingPage() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
    );
  }

  /// Step 2 → LandingPage : "Verify and sign in"
  void verifyAndSignIn() {
    if (codeController.text.length != 6) {
      showMessage('Enter the 6-digit code.');
      return;
    }
    if (_secondsLeft.value == 0) {
      showMessage('This code has expired. Request a new one.');
      return;
    }

    // TODO: verify the code with your API here.

    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
    );
  }

  void resendCode() {
    codeController.clear();
    _startCodeTimer();
    codeFocus.requestFocus();
    showMessage('A new code was sent.');
    // TODO: call your "resend code" API here.
  }

  void goBack() {
    _timer?.cancel();
    codeController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      passwordError = false;
      step = step - 1;
    });
  }

  void _startCodeTimer() {
    _timer?.cancel();
    _secondsLeft.value = _codeLifetime.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft.value <= 1) {
        _secondsLeft.value = 0;
        timer.cancel();
      } else {
        _secondsLeft.value = _secondsLeft.value - 1;
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ==========================================================
  // ACTIONS — account lockout
  // ==========================================================

  /// Too many wrong passwords → lock the account and show the
  /// "This account is locked" screen with a 15:00 countdown.
  void _lockAccount(String email) {
    // TODO: your server should be the one that really locks the account
    // and writes the security audit log entry.
    FocusScope.of(context).unfocus();
    passwordController.clear();
    _lockedEmail = email.trim().toLowerCase();
    _startLockTimer();
    setState(() {
      passwordError = false;
      view = AuthView.locked;
    });
  }

  void _startLockTimer() {
    _lockTimer?.cancel();
    _lockSecondsLeft.value = _lockDuration.inSeconds;
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lockSecondsLeft.value <= 1) {
        _lockSecondsLeft.value = 0;
        failedAttempts = 0; // lockout is over, start counting again
        timer.cancel();
      } else {
        _lockSecondsLeft.value = _lockSecondsLeft.value - 1;
      }
    });
  }

  void _clearLock() {
    _lockTimer?.cancel();
    _lockSecondsLeft.value = 0;
    _lockedEmail = null;
    failedAttempts = 0;
    passwordError = false;
  }

  // ==========================================================
  // ACTIONS — forgot password
  // ==========================================================

  /// "Forgot password?" (password step) or "Reset password" (locked screen)
  void openForgotPassword() {
    FocusScope.of(context).unfocus();
    setState(() {
      forgotEmailController.text = emailController.text.trim();
      view = AuthView.forgotPassword;
    });
  }

  /// Forgot password → Check your email : "Send reset link"
  void sendResetLink() {
    final email = forgotEmailController.text.trim();

    if (email.isEmpty) {
      showMessage('Enter your work email.');
      return;
    }
    if (!_isValidEmail(email)) {
      showMessage('Enter a valid work email.');
      return;
    }

    // TODO: call your "send password reset link" API here.
    // The link should expire in 30 minutes, and your server should
    // lift the lockout once the password is really reset.

    FocusScope.of(context).unfocus();
    emailController.text = email;
    _clearLock();
    setState(() {
      resetEmail = email;
      view = AuthView.checkEmail;
    });
  }

  void resendResetEmail() {
    showMessage('Reset link sent again.');
    // TODO: call your "resend reset link" API here.
  }

  void contactSupport() {
    showMessage('Contact support selected.');
  }

  // ==========================================================
  // ACTIONS — create account (same page)
  // ==========================================================

  void openCreateAccount() {
    FocusScope.of(context).unfocus();
    setState(() {
      view = AuthView.createAccount;
      orgStep = 0;
    });
  }

  /// Back button while inside the Create Account flow.
  void goBackCreateAccount() {
    FocusScope.of(context).unfocus();
    if (orgStep > 0) {
      setState(() => orgStep = orgStep - 1);
    } else {
      setState(() => view = AuthView.signIn);
    }
  }

  /// "Sign in" links inside the Create Account flow.
  void goToSignInFromCreateAccount() {
    FocusScope.of(context).unfocus();
    setState(() {
      view = AuthView.signIn;
      step = 0;
    });
  }

  void pickLogo() {
    // Placeholder — no extra packages required. See the note at the
    // top of this file for how to wire up real file picking with
    // the `image_picker` package once it's added to pubspec.yaml.
    showMessage('Logo upload selected.');
  }

  void removeLogo() {
    setState(() {
      logoBytes = null;
      logoFileName = null;
    });
  }

  /// orgStep 0 → orgStep 1 : "Continue" (organization details)
  void continueFromOrgDetails() {
    final orgName = organizationNameController.text.trim();
    final orgCode = organizationCodeController.text.trim();
    final city = cityController.text.trim();

    if (orgName.isEmpty) {
      showMessage('Enter your organization name.');
      return;
    }
    if (orgCode.isEmpty) {
      showMessage('Enter your organization code.');
      return;
    }
    if (orgType == null) {
      showMessage('Select an organization type.');
      return;
    }
    if (industry == null) {
      showMessage('Select an industry.');
      return;
    }
    if (companySize == null) {
      showMessage('Select a company size.');
      return;
    }
    if (country == null) {
      showMessage('Select a country.');
      return;
    }
    if (stateProvince == null) {
      showMessage('Select a state / province.');
      return;
    }
    if (city.isEmpty) {
      showMessage('Enter your city.');
      return;
    }
    if (timeZone == null) {
      showMessage('Select a time zone.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => orgStep = 1);
  }

  /// orgStep 1 → orgStep 2 : "Continue" (super admin account)
  void continueFromAdminAccount() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final officialEmail = officialEmailController.text.trim();
    final mobile = mobileController.text.trim();
    final username = usernameController.text.trim();
    final password = adminPasswordController.text;
    final confirmPassword = adminConfirmPasswordController.text;

    if (firstName.isEmpty) {
      showMessage('Enter the first name.');
      return;
    }
    if (lastName.isEmpty) {
      showMessage('Enter the last name.');
      return;
    }
    if (!_isValidEmail(officialEmail)) {
      showMessage('Enter a valid official email.');
      return;
    }
    if (mobile.isEmpty) {
      showMessage('Enter a mobile number.');
      return;
    }
    if (username.isEmpty) {
      showMessage('Choose a username.');
      return;
    }
    if (password.length < 8) {
      showMessage('Password must be at least 8 characters.');
      return;
    }
    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => orgStep = 2);
  }

  /// orgStep 2 → Welcome screen : "Create account"
  void createAccount() {
    if (!agreeTerms) {
      showMessage('Accept the Terms of Service and Privacy Policy.');
      return;
    }
    if (!agreeAuthorized) {
      showMessage(
          'Confirm that you are authorized to register this organization.');
      return;
    }
    if (!agreeDataProcessing) {
      showMessage('Accept the Data Processing Agreement.');
      return;
    }

    // TODO: call your create-organization + create-admin-account API here
    // with all the collected fields, including the picked logo (logoBytes)
    // and the optional "product updates" choice (agreeUpdates).
    // Only show the welcome screen if the API accepts the request.

    // Remember this account so its password works on the sign in page.
    // (Demo only — your real API does this on the server.)
    _registeredAccounts[officialEmailController.text.trim().toLowerCase()] =
        adminPasswordController.text;

    FocusScope.of(context).unfocus();
    setState(() => submittingAccount = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        submittingAccount = false;
        view = AuthView.welcome;
      });
    });
  }

  // ==========================================================
  // ACTIONS — welcome screen
  // ==========================================================

  /// "Go to sign in" — back to the login page, first step,
  /// with the new workspace and email already filled in.
  void goToSignInFromWelcome() {
    _timer?.cancel();
    codeController.clear();
    passwordController.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      workspaceController.text = _workspaceSlug;
      emailController.text = officialEmailController.text.trim();
      step = 0;
      view = AuthView.signIn;
      orgStep = 0;
    });
  }

  void resendVerification() {
    showMessage('Verification email sent again.');
    // TODO: call your "resend verification email" API here.
  }

  @override
  void dispose() {
    _timer?.cancel();
    _lockTimer?.cancel();
    _secondsLeft.dispose();
    _lockSecondsLeft.dispose();
    passwordFocus.dispose();
    codeFocus.dispose();
    workspaceController.dispose();
    emailController.dispose();
    passwordController.dispose();
    codeController.dispose();
    forgotEmailController.dispose();
    organizationNameController.removeListener(_autoFillOrganizationCode);
    organizationNameController.dispose();
    organizationCodeController.dispose();
    organizationCodeFocus.dispose();
    cityController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    officialEmailController.dispose();
    mobileController.dispose();
    usernameController.dispose();
    adminPasswordController.dispose();
    adminConfirmPasswordController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    // FULL-SCREEN STATES (no back button / progress bar)
    if (view == AuthView.welcome) {
      return _buildWelcomeView();
    }
    if (view == AuthView.forgotPassword) {
      return _buildForgotPasswordView();
    }
    if (view == AuthView.checkEmail) {
      return _buildCheckEmailView();
    }
    if (view == AuthView.locked) {
      return _buildLockedView();
    }

    final bool isCreateAccount = view == AuthView.createAccount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // BACK
        //  - sign in steps 1 & 2 → previous sign in step
        //  - create account view → previous create-account step, or sign in
        if (isCreateAccount || step > 0) ...[
          InkWell(
            onTap: isCreateAccount ? goBackCreateAccount : goBack,
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back, size: 14, color: AppColors.muted),
                  SizedBox(width: 6),
                  Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // PROGRESS BAR (create account flow only)
        if (isCreateAccount) ...[
          ProgressBar(currentIndex: orgStep, totalSteps: 3),
          const SizedBox(height: 16),
        ],

        // EYEBROW
        Text(
          isCreateAccount ? _createAccountEyebrows[orgStep] : _signInEyebrow,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 1.2,
            color: AppColors.hint,
          ),
        ),

        const SizedBox(height: 10),

        // TITLE
        Text(
          isCreateAccount ? _createAccountTitles[orgStep] : _titles[step],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),

        const SizedBox(height: 8),

        // DESCRIPTION
        isCreateAccount
            ? _buildCreateAccountSubtitle()
            : Text(
                _subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.muted,
                ),
              ),

        const SizedBox(height: 26),

        // CONTENT (same page, animated swap)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.03, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          layoutBuilder: (current, previous) => Stack(
            alignment: Alignment.topLeft,
            children: [
              ...previous,
              if (current != null) current,
            ],
          ),
          child: KeyedSubtree(
            key: ValueKey(
              isCreateAccount ? 'create-account-$orgStep' : 'sign-in-$step',
            ),
            child: isCreateAccount
                ? switch (orgStep) {
                    0 => _buildOrganizationDetailsStep(),
                    1 => _buildAdminAccountStep(),
                    _ => _buildReviewStep(),
                  }
                : switch (step) {
                    0 => _buildIdentifyStep(),
                    1 => _buildPasswordStep(),
                    _ => _buildVerifyStep(),
                  },
          ),
        ),
      ],
    );
  }

  static const List<String> _createAccountEyebrows = [
    'STEP 1 OF 3 · ORGANIZATION DETAILS',
    'STEP 2 OF 3 · SUPER ADMIN ACCOUNT',
    'STEP 3 OF 3 · TERMS & AUTHORIZATION',
  ];

  static const List<String> _createAccountTitles = [
    'Create Account',
    'Create your admin account',
    'Review and confirm',
  ];

  Widget _buildCreateAccountSubtitle() {
    if (orgStep == 0) {
      return const Text(
        'Tell us about your organization to set up your workspace.',
        style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.muted),
      );
    }

    final orgName = organizationNameController.text.trim();
    final String displayName = orgName.isEmpty ? 'your organization' : orgName;

    if (orgStep == 1) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            height: 1.4,
            color: AppColors.muted,
          ),
          children: [
            const TextSpan(text: "This is the account you'll use to manage "),
            TextSpan(
              text: displayName,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          height: 1.4,
          color: AppColors.muted,
        ),
        children: [
          const TextSpan(text: 'One last step before we create '),
          TextSpan(
            text: orgName.isEmpty ? 'your' : "$orgName's",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const TextSpan(text: ' workspace.'),
        ],
      ),
    );
  }

  // ==========================================================
  // SIGN IN — STEP 0 : IDENTIFY
  // ==========================================================

  Widget _buildIdentifyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const FieldLabel(text: 'Workspace'),

        WorkspaceField(controller: workspaceController),

        const SizedBox(height: 7),

        Wrap(
          children: [
            const Text(
              "Don't know your workspace? ",
              style: TextStyle(fontSize: 11, color: AppColors.muted),
            ),
            GestureDetector(
              onTap: () => showMessage('Workspace finder selected.'),
              child: const Text(
                'Find it here',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        const FieldLabel(text: 'Work email'),

        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => continueToPassword(),
          decoration: const InputDecoration(hintText: 'you@acmecorp.com'),
        ),

        const SizedBox(height: 16),

        PrimaryButton(label: 'Continue', onPressed: continueToPassword),

        const SizedBox(height: 22),

        const OrDivider(text: 'or continue with'),

        const SizedBox(height: 18),

        SocialButton(
          icon: const GoogleIcon(),
          text: 'Google',
          onPressed: () => showMessage('Google sign in selected.'),
        ),

        const SizedBox(height: 9),

        SocialButton(
          icon: const MicrosoftIcon(),
          text: 'Microsoft',
          onPressed: () => showMessage('Microsoft sign in selected.'),
        ),

        const SizedBox(height: 9),

        SocialButton(
          icon: const Icon(
            Icons.groups_outlined,
            size: 18,
            color: AppColors.text,
          ),
          text: 'Company SSO (SAML)',
          onPressed: () => showMessage('Company SSO selected.'),
        ),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 17),

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'New to One Enterprise? ',
                style: TextStyle(fontSize: 11, color: AppColors.muted),
              ),
              GestureDetector(
                onTap: openCreateAccount,
                child: const Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SIGN IN — STEP 1 : PASSWORD
  //   Error banner (after a wrong password), account chip with
  //   "Switch", password field, "Remember this device",
  //   "Forgot password?", [Sign in], password policy footer.
  // ==========================================================

  OutlineInputBorder _errorOutline() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.errorField, width: 1),
    );
  }

  Widget _buildPasswordStep() {
    final int remaining = _maxAttempts - failedAttempts;
    final String attemptsText =
        remaining == 1 ? '1 attempt' : '$remaining attempts';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ERROR BANNER
        if (passwordError) ...[
          ErrorBanner(
            title: 'Incorrect email or password',
            message:
                'You have $attemptsText remaining before this account is temporarily locked.',
          ),
          const SizedBox(height: 14),
        ],

        // ACCOUNT CHIP
        AccountChip(
          email: emailController.text.trim(),
          onSwitch: switchAccount,
        ),

        const SizedBox(height: 18),

        const FieldLabel(text: 'Password'),

        TextField(
          controller: passwordController,
          focusNode: passwordFocus,
          obscureText: hidePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => signIn(),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            enabledBorder: passwordError ? _errorOutline() : null,
            focusedBorder: passwordError ? _errorOutline() : null,
            suffixIcon: IconButton(
              onPressed: () => setState(() => hidePassword = !hidePassword),
              icon: Icon(
                hidePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: AppColors.muted,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // REMEMBER DEVICE  +  FORGOT PASSWORD
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SmallCheckboxRow(
                value: rememberDevice,
                label: 'Remember this device for 30 days',
                onChanged: (v) => setState(() => rememberDevice = v),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: openForgotPassword,
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.link,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        PrimaryButton(label: 'Sign in', onPressed: signIn),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 14),

        Center(
          child: Text(
            'Protected by enterprise password policy · $_maxAttempts attempts before lockout',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.5,
              color: AppColors.muted,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SIGN IN — STEP 2 : TWO-STEP VERIFICATION
  // ==========================================================

  Widget _buildVerifyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        OtpField(
          controller: codeController,
          focusNode: codeFocus,
          onSubmitted: verifyAndSignIn,
        ),

        const SizedBox(height: 12),

        Center(
          child: ValueListenableBuilder<int>(
            valueListenable: _secondsLeft,
            builder: (context, seconds, _) {
              return Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  Text(
                    seconds > 0
                        ? 'Code expires in ${_formatTime(seconds)}'
                        : 'Code expired',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                  const Text(
                    '·',
                    style: TextStyle(fontSize: 11, color: AppColors.hint),
                  ),
                  GestureDetector(
                    onTap: resendCode,
                    child: const Text(
                      'Resend code',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 18),

        PrimaryButton(label: 'Verify and sign in', onPressed: verifyAndSignIn),
      ],
    );
  }

  // ==========================================================
  // FORGOT PASSWORD — "Forgot your password?"
  //   Back to sign in, PASSWORD RECOVERY, work email,
  //   [Send reset link], "Remembered your password? Sign in".
  // ==========================================================

  Widget _buildForgotPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // BACK TO SIGN IN
        InkWell(
          onTap: goToSignIn,
          borderRadius: BorderRadius.circular(6),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 14, color: AppColors.muted),
                SizedBox(width: 6),
                Text(
                  'Back to sign in',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'PASSWORD RECOVERY',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            letterSpacing: 1.2,
            color: AppColors.hint,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Forgot your password?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "Enter your work email and we'll send you a link to reset it.",
          style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.muted),
        ),

        const SizedBox(height: 26),

        const FieldLabel(text: 'Work email'),

        TextField(
          controller: forgotEmailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => sendResetLink(),
          decoration: const InputDecoration(hintText: 'you@acmecorp.com'),
        ),

        const SizedBox(height: 16),

        PrimaryButton(label: 'Send reset link', onPressed: sendResetLink),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 17),

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Remembered your password? ',
                style: TextStyle(fontSize: 11, color: AppColors.muted),
              ),
              GestureDetector(
                onTap: goToSignIn,
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.link,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // FORGOT PASSWORD — "Check your email"
  //   Green mail icon, message, [Resend email],
  //   [Back to sign in], spam / contact support note.
  // ==========================================================

  Widget _buildCheckEmailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const StatusIcon(
          icon: Icons.mail_outline,
          background: AppColors.successBg,
          color: AppColors.success,
        ),

        const SizedBox(height: 18),

        const Text(
          'Check your email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),

        const SizedBox(height: 10),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: AppColors.muted,
            ),
            children: [
              const TextSpan(text: "We've sent a password reset link to "),
              TextSpan(
                text: resetEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const TextSpan(text: '.\nThe link expires in 30 minutes.'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        SecondaryButton(label: 'Resend email', onPressed: resendResetEmail),

        const SizedBox(height: 10),

        PrimaryButton(label: 'Back to sign in', onPressed: goToSignIn),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 17),

        Wrap(
          alignment: WrapAlignment.center,
          children: [
            const Text(
              "Didn't get it? Check spam, or ",
              style: TextStyle(fontSize: 11, color: AppColors.muted),
            ),
            GestureDetector(
              onTap: contactSupport,
              child: const Text(
                'contact support',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.link,
                ),
              ),
            ),
            const Text(
              '.',
              style: TextStyle(fontSize: 11, color: AppColors.muted),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // ACCOUNT LOCKED — "This account is locked"
  //   Red lock icon, message, "Try again in 15:00" box,
  //   [Reset password], [Back to sign in], audit log note.
  // ==========================================================

  Widget _buildLockedView() {
    final String lockedEmail = emailController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const StatusIcon(
          icon: Icons.lock_outline,
          background: AppColors.lockBg,
          color: AppColors.errorField,
        ),

        const SizedBox(height: 18),

        const Text(
          'This account is locked',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),

        const SizedBox(height: 10),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: AppColors.muted,
            ),
            children: [
              const TextSpan(
                text: 'Too many failed sign-in attempts. For your security, ',
              ),
              TextSpan(
                text: lockedEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              TextSpan(
                text:
                    ' has been temporarily locked for ${_lockDuration.inMinutes} minutes.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // COUNTDOWN BOX
        ValueListenableBuilder<int>(
          valueListenable: _lockSecondsLeft,
          builder: (context, seconds, _) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warnBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warnBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.schedule,
                      size: 14,
                      color: AppColors.warnText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          seconds > 0
                              ? 'Try again in ${_formatTime(seconds)}'
                              : 'You can try signing in again now',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warnText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Or reset your password now to regain access immediately.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: AppColors.warnText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        PrimaryButton(label: 'Reset password', onPressed: openForgotPassword),

        const SizedBox(height: 10),

        SecondaryButton(label: 'Back to sign in', onPressed: goToSignIn),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 17),

        Wrap(
          alignment: WrapAlignment.center,
          children: [
            const Text(
              'This lockout was recorded in the security audit log · ',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 11, height: 1.5, color: AppColors.muted),
            ),
            GestureDetector(
              onTap: contactSupport,
              child: const Text(
                'Contact support',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.link,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // CREATE ACCOUNT — orgStep 0 : organization details
  //   Order: Organization Name, Organization Code,
  //   Organization Type, Industry, Company Size,
  //   Country + State/Province, City + Time Zone,
  //   Organization Logo (optional) → [Continue]
  // ==========================================================

  Widget _buildOrganizationDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ORGANIZATION NAME
        const RequiredFieldLabel(text: 'Organization Name'),
        TextField(
          controller: organizationNameController,
          textInputAction: TextInputAction.next,
          decoration:
              const InputDecoration(hintText: 'ABC Technologies Pvt Ltd'),
        ),

        const SizedBox(height: 18),

        // ORGANIZATION CODE
        const RequiredFieldLabel(text: 'Organization Code'),
        TextField(
          controller: organizationCodeController,
          focusNode: organizationCodeFocus,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.next,
          onChanged: (_) => _codeEditedManually = true,
          decoration: const InputDecoration(hintText: 'ABC-TECH'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: AppColors.hint),
              children: [
                const TextSpan(
                  text: 'Auto-generated from your organization name — ',
                ),
                TextSpan(
                  text: 'edit manually',
                  style: const TextStyle(
                    color: AppColors.link,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = _editCodeManually,
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        // ORGANIZATION TYPE
        const RequiredFieldLabel(text: 'Organization Type'),
        DropdownField<String>(
          value: orgType,
          items: _orgTypes,
          onChanged: (value) => setState(() => orgType = value),
        ),

        const SizedBox(height: 18),

        // INDUSTRY
        const RequiredFieldLabel(text: 'Industry'),
        DropdownField<String>(
          value: industry,
          items: _industries,
          onChanged: (value) => setState(() => industry = value),
        ),

        const SizedBox(height: 18),

        // COMPANY SIZE
        const RequiredFieldLabel(text: 'Company Size'),
        DropdownField<String>(
          value: companySize,
          items: _companySizes,
          onChanged: (value) => setState(() => companySize = value),
        ),

        const SizedBox(height: 18),

        // COUNTRY / STATE-PROVINCE
        ResponsiveFieldRow(
          left: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RequiredFieldLabel(text: 'Country'),
              DropdownField<String>(
                value: country,
                items: _countries,
                onChanged: (value) => setState(() => country = value),
              ),
            ],
          ),
          right: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RequiredFieldLabel(text: 'State / Province'),
              DropdownField<String>(
                value: stateProvince,
                items: _statesProvinces,
                onChanged: (value) => setState(() => stateProvince = value),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // CITY / TIME ZONE
        ResponsiveFieldRow(
          left: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RequiredFieldLabel(text: 'City'),
              TextField(
                controller: cityController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Hyderabad'),
              ),
            ],
          ),
          right: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RequiredFieldLabel(text: 'Time Zone'),
              DropdownField<String>(
                value: timeZone,
                items: _timeZones,
                onChanged: (value) => setState(() => timeZone = value),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // ORGANIZATION LOGO (optional, real file picker)
        Row(
          children: const [
            Text(
              'Organization Logo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            SizedBox(width: 6),
            Text(
              'OPTIONAL',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 9,
                letterSpacing: 0.6,
                color: AppColors.hint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LogoUploadBox(
          onTap: pickLogo,
          onRemove: removeLogo,
          previewBytes: logoBytes,
          fileName: logoFileName,
        ),

        const SizedBox(height: 24),

        // CONTINUE BUTTON → next step (admin account)
        PrimaryButton(
          label: 'Continue',
          onPressed: continueFromOrgDetails,
        ),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 17),

        // ALREADY HAVE AN ORGANIZATION
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Already have an organization? ',
                style: TextStyle(fontSize: 11, color: AppColors.muted),
              ),
              GestureDetector(
                onTap: goToSignInFromCreateAccount,
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CREATE ACCOUNT — orgStep 1 : super admin account
  //   Info banner, First Name / Last Name, Official Email,
  //   Mobile Number, Username, Password / Confirm Password
  //   → [Continue] goes to the review step.
  // ==========================================================

  Widget _buildAdminAccountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // INFO BANNER
        const AdminRoleBanner(),

        const SizedBox(height: 20),

        // FIRST NAME / LAST NAME
        ResponsiveFieldRow(
          left: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RequiredFieldLabel(text: 'First Name'),
              TextField(
                controller: firstNameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Ananya'),
              ),
            ],
          ),
          right: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RequiredFieldLabel(text: 'Last Name'),
              TextField(
                controller: lastNameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Rao'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // OFFICIAL EMAIL
        const RequiredFieldLabel(text: 'Official Email'),
        TextField(
          controller: officialEmailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration:
              const InputDecoration(hintText: 'ananya.rao@abctech.com'),
        ),

        const SizedBox(height: 18),

        // MOBILE NUMBER
        const RequiredFieldLabel(text: 'Mobile Number'),
        TextField(
          controller: mobileController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: '+91 98765 43210'),
        ),

        const SizedBox(height: 18),

        // USERNAME
        const RequiredFieldLabel(text: 'Username'),
        TextField(
          controller: usernameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'ananya.rao'),
        ),

        const SizedBox(height: 18),

        // PASSWORD / CONFIRM PASSWORD
        ResponsiveFieldRow(
          left: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RequiredFieldLabel(text: 'Password'),
              TextField(
                controller: adminPasswordController,
                obscureText: hideAdminPassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Create a password',
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => hideAdminPassword = !hideAdminPassword,
                    ),
                    icon: Icon(
                      hideAdminPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ),
            ],
          ),
          right: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const RequiredFieldLabel(text: 'Confirm Password'),
              TextField(
                controller: adminConfirmPasswordController,
                obscureText: hideAdminConfirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => continueFromAdminAccount(),
                decoration: InputDecoration(
                  hintText: 'Re-enter password',
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                      () => hideAdminConfirmPassword =
                          !hideAdminConfirmPassword,
                    ),
                    icon: Icon(
                      hideAdminConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            'Minimum 8 characters, with at least one number and one symbol.',
            style: TextStyle(fontSize: 11, color: AppColors.hint),
          ),
        ),

        const SizedBox(height: 24),

        // CONTINUE BUTTON → review and confirm
        PrimaryButton(
          label: 'Continue',
          onPressed: continueFromAdminAccount,
        ),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 17),

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Already have an organization? ',
                style: TextStyle(fontSize: 11, color: AppColors.muted),
              ),
              GestureDetector(
                onTap: goToSignInFromCreateAccount,
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CREATE ACCOUNT — orgStep 2 : review and confirm
  //   Three required checkboxes + one optional checkbox
  //   → [Create account] shows the welcome screen.
  // ==========================================================

  Widget _buildReviewStep() {
    final orgName = organizationNameController.text.trim();
    final String displayName = orgName.isEmpty ? 'your organization' : orgName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // AGREEMENTS BOX
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. TERMS + PRIVACY
              AgreementRow(
                value: agreeTerms,
                onChanged: (v) => setState(() => agreeTerms = v),
                parts: [
                  const AgreementPart(text: 'I have read and agree to the '),
                  AgreementPart(
                    text: 'Terms of Service',
                    isLink: true,
                    onTap: () => showMessage('Terms of Service selected.'),
                  ),
                  const AgreementPart(text: ' and '),
                  AgreementPart(
                    text: 'Privacy Policy',
                    isLink: true,
                    onTap: () => showMessage('Privacy Policy selected.'),
                  ),
                  const AgreementPart(text: '.'),
                ],
              ),

              const SizedBox(height: 14),

              // 2. AUTHORIZED TO REGISTER
              AgreementRow(
                value: agreeAuthorized,
                onChanged: (v) => setState(() => agreeAuthorized = v),
                parts: [
                  const AgreementPart(
                    text: 'I confirm that I am authorized to register ',
                  ),
                  AgreementPart(text: displayName, isBold: true),
                  const AgreementPart(
                    text:
                        ' on One Enterprise, and I accept responsibility as its Super Administrator.',
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 3. DATA PROCESSING AGREEMENT
              AgreementRow(
                value: agreeDataProcessing,
                onChanged: (v) => setState(() => agreeDataProcessing = v),
                parts: [
                  const AgreementPart(text: 'I agree to the '),
                  AgreementPart(
                    text: 'Data Processing Agreement',
                    isLink: true,
                    onTap: () =>
                        showMessage('Data Processing Agreement selected.'),
                  ),
                  const AgreementPart(
                    text:
                        ' governing how organization data is stored and processed.',
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 4. PRODUCT UPDATES (OPTIONAL)
              AgreementRow(
                value: agreeUpdates,
                onChanged: (v) => setState(() => agreeUpdates = v),
                parts: const [
                  AgreementPart(
                    text:
                        'Send me product updates and security notices by email',
                  ),
                  AgreementPart(text: '', isOptionalBadge: true),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // CREATE ACCOUNT BUTTON → welcome screen
        PrimaryButton(
          label: submittingAccount ? 'Creating account…' : 'Create account',
          onPressed: submittingAccount ? null : createAccount,
        ),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 17),

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Already have an organization? ',
                style: TextStyle(fontSize: 11, color: AppColors.muted),
              ),
              GestureDetector(
                onTap: goToSignInFromCreateAccount,
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.link,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // WELCOME SCREEN (after the account is created)
  //   Green check, title, message, verification banner,
  //   [Go to sign in], "Resend verification".
  //   No Back button and no progress bar on this screen.
  // ==========================================================

  Widget _buildWelcomeView() {
    final orgName = organizationNameController.text.trim();
    final String displayName = orgName.isEmpty ? 'Your organization' : orgName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // GREEN CHECK
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.successBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 20, color: AppColors.success),
        ),

        const SizedBox(height: 18),

        // TITLE
        const Text(
          'Welcome to One Enterprise',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),

        const SizedBox(height: 10),

        // MESSAGE
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.muted,
            ),
            children: [
              TextSpan(
                text: displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const TextSpan(
                text:
                    ' is ready. Your Super Admin account has been created — verify your email to activate full access.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // VERIFICATION BANNER
        VerificationBanner(workspace: '$_workspaceSlug.oneenterprise.io'),

        const SizedBox(height: 18),

        // GO TO SIGN IN
        PrimaryButton(label: 'Go to sign in', onPressed: goToSignInFromWelcome),

        const SizedBox(height: 22),

        const Divider(color: AppColors.border),

        const SizedBox(height: 17),

        // RESEND VERIFICATION
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            const Text(
              "Didn't get the email? ",
              style: TextStyle(fontSize: 11, color: AppColors.muted),
            ),
            GestureDetector(
              onTap: resendVerification,
              child: const Text(
                'Resend verification',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.link,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// ERROR BANNER (wrong password)
//   Red box: "Incorrect email or password" + attempts left.
// ============================================================

class ErrorBanner extends StatelessWidget {
  final String title;
  final String message;

  const ErrorBanner({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.error_outline,
              size: 14,
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: AppColors.error,
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
// ACCOUNT CHIP (password step)
//   Avatar + email + "Not you? Use a different account" + Switch.
// ============================================================

class AccountChip extends StatelessWidget {
  final String email;
  final VoidCallback onSwitch;

  const AccountChip({super.key, required this.email, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7FD6C6), Color(0xFF2E7D8C)],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  'Not you? Use a different account',
                  style: TextStyle(fontSize: 10, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSwitch,
            child: const Text(
              'Switch',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SMALL CHECKBOX ROW ("Remember this device for 30 days")
// ============================================================

class SmallCheckboxRow extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  const SmallCheckboxRow({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 12,
            height: 12,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: value ? AppColors.navy : Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: value ? AppColors.navy : AppColors.hint,
                width: 1.2,
              ),
            ),
            child: value
                ? const Icon(Icons.check, size: 9, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STATUS ICON (big round icon: mail, lock, ...)
// ============================================================

class StatusIcon extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color color;

  const StatusIcon({
    super.key,
    required this.icon,
    required this.background,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: 20, color: color),
    );
  }
}

// ============================================================
// SECONDARY BUTTON (white with border)
// ============================================================

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ============================================================
// PROGRESS BAR (create account flow)
// ============================================================

class ProgressBar extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;

  const ProgressBar({
    super.key,
    required this.currentIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < totalSteps; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: i < currentIndex
                    ? AppColors.progressDone
                    : i == currentIndex
                        ? AppColors.navy
                        : AppColors.border,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================
// ADMIN ROLE BANNER
// ============================================================

class AdminRoleBanner extends StatelessWidget {
  const AdminRoleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.bannerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.bannerBorder),
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 14,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: AppColors.muted,
                ),
                children: [
                  TextSpan(
                    text: 'This account will automatically be assigned the ',
                  ),
                  TextSpan(
                    text: 'SUPER_ADMIN',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  TextSpan(
                    text:
                        " role, with full access to your organization's workspace.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// VERIFICATION BANNER (welcome screen)
//   Mail icon + "We've sent a verification link..." message
//   and the new workspace address.
// ============================================================

class VerificationBanner extends StatelessWidget {
  final String workspace;

  const VerificationBanner({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.bannerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.bannerBorder),
            ),
            child: const Icon(
              Icons.mail_outline,
              size: 14,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.5,
                  color: AppColors.muted,
                ),
                children: [
                  const TextSpan(
                    text:
                        "We've sent a verification link to your official email. Your workspace: ",
                  ),
                  TextSpan(
                    text: workspace,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
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
}

// ============================================================
// AGREEMENT ROW (checkbox + text with links)
//   Used on the "Review and confirm" step. The whole row can be
//   tapped to tick / untick, except the blue links which do
//   their own action.
// ============================================================

class AgreementPart {
  final String text;
  final bool isLink;
  final bool isBold;
  final bool isOptionalBadge;
  final VoidCallback? onTap;

  const AgreementPart({
    required this.text,
    this.isLink = false,
    this.isBold = false,
    this.isOptionalBadge = false,
    this.onTap,
  });
}

class AgreementRow extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final List<AgreementPart> parts;

  const AgreementRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.parts,
  });

  @override
  State<AgreementRow> createState() => _AgreementRowState();
}

class _AgreementRowState extends State<AgreementRow> {
  final List<TapGestureRecognizer> _recognizers = [];

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _disposeRecognizers();

    final List<InlineSpan> spans = [];

    for (final part in widget.parts) {
      if (part.isOptionalBadge) {
        spans.add(
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'OPTIONAL',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  letterSpacing: 0.6,
                  color: AppColors.hint,
                ),
              ),
            ),
          ),
        );
        continue;
      }

      if (part.isLink) {
        final recognizer = TapGestureRecognizer()..onTap = part.onTap;
        _recognizers.add(recognizer);
        spans.add(
          TextSpan(
            text: part.text,
            style: const TextStyle(
              color: AppColors.link,
              fontWeight: FontWeight.w700,
            ),
            recognizer: recognizer,
          ),
        );
      } else if (part.isBold) {
        spans.add(
          TextSpan(
            text: part.text,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: part.text));
      }
    }

    return InkWell(
      onTap: () => widget.onChanged(!widget.value),
      borderRadius: BorderRadius.circular(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CHECKBOX
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.value ? AppColors.navy : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: widget.value ? AppColors.navy : AppColors.hint,
                  width: 1.2,
                ),
              ),
              child: widget.value
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: AppColors.text,
                ),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// RESPONSIVE FIELD ROW
//   Two fields side by side on wider widths; stacks to a
//   single column when the available width is narrow
//   (compact / mobile layout).
// ============================================================

class ResponsiveFieldRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const ResponsiveFieldRow({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool stacked = constraints.maxWidth < 340;

        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              left,
              const SizedBox(height: 18),
              right,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 12),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

// ============================================================
// DROPDOWN FIELD
//   Styled to match the app's TextField borders / radius.
// ============================================================

class DropdownField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const DropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.muted,
      ),
      style: const TextStyle(fontSize: 13, color: AppColors.text),
      decoration: const InputDecoration(),
      items: [
        for (final item in items)
          DropdownMenuItem<T>(value: item, child: Text('$item')),
      ],
      onChanged: onChanged,
    );
  }
}

// ============================================================
// LOGO UPLOAD BOX
//   Tapping opens the real system file / gallery picker via
//   image_picker. Shows a thumbnail + file name once a logo is
//   selected, with a way to remove it and pick again.
// ============================================================

class LogoUploadBox extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final Uint8List? previewBytes;
  final String? fileName;

  const LogoUploadBox({
    super.key,
    required this.onTap,
    required this.onRemove,
    this.previewBytes,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasLogo = previewBytes != null;

    return DottedBorderBox(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: hasLogo
              ? Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        previewBytes!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            fileName ?? 'logo.png',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Tap to change logo',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.link,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const SizedBox(height: 6),
                    const Icon(
                      Icons.file_upload_outlined,
                      size: 22,
                      color: AppColors.hint,
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style:
                            TextStyle(fontSize: 12, color: AppColors.muted),
                        children: [
                          TextSpan(
                            text: 'Upload logo',
                            style: TextStyle(
                              color: AppColors.link,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ' or drag and drop — PNG, JPG up to 5MB',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
        ),
      ),
    );
  }
}

/// A simple dashed-look upload container (approximated with a
/// light fill + solid rounded border to avoid extra packages).
class DottedBorderBox extends StatelessWidget {
  final Widget child;

  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

// ============================================================
// PRIMARY BUTTON
// ============================================================

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.navy.withOpacity(0.6),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ============================================================
// OTP FIELD (6 boxes, one hidden text field underneath)
// ============================================================

class OtpField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  const OtpField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  static const int _length = 6;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
    widget.focusNode.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    widget.focusNode.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;
    final focused = widget.focusNode.hasFocus;
    final activeIndex = text.length < _length ? text.length : _length - 1;

    return SizedBox(
      height: 52,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < _length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: OtpBox(
                    char: i < text.length ? text[i] : '',
                    active: focused && i == activeIndex,
                  ),
                ),
              ],
            ],
          ),

          // Invisible field that actually receives typing / paste.
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                showCursor: false,
                maxLength: _length,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_length),
                ],
                onTap: () {
                  widget.controller.selection = TextSelection.collapsed(
                    offset: widget.controller.text.length,
                  );
                },
                onSubmitted: (_) => widget.onSubmitted(),
                decoration: const InputDecoration(
                  filled: false,
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OtpBox extends StatelessWidget {
  final String char;
  final bool active;

  const OtpBox({super.key, required this.char, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? AppColors.teal : AppColors.border,
          width: active ? 1.5 : 1,
        ),
        boxShadow: active
            ? const [
                BoxShadow(
                  color: Color(0x333CC8B4),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: Text(
        char,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
    );
  }
}

// ============================================================
// FIELD LABEL
// ============================================================

class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
    );
  }
}

/// Same as FieldLabel but with a small red required-asterisk,
/// matching the reference image's "Field *" styling.
class RequiredFieldLabel extends StatelessWidget {
  final String text;

  const RequiredFieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
          children: [
            TextSpan(text: text),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFE0524A)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WORKSPACE FIELD
// ============================================================

class WorkspaceField extends StatelessWidget {
  final TextEditingController controller;

  const WorkspaceField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // WORKSPACE INPUT
          Expanded(
            child: TextField(
              controller: controller,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_-]')),
              ],
              decoration: const InputDecoration(
                hintText: 'acmecorp',
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ),

          // DOMAIN
          Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
            ),
            child: const Text(
              '.oneenterprise.io',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// OR DIVIDER
// ============================================================

class OrDivider extends StatelessWidget {
  final String text;

  const OrDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(fontSize: 10, color: AppColors.hint),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

// ============================================================
// SOCIAL BUTTON
// ============================================================

class SocialButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 9),
            Text(
              text,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// GOOGLE ICON
// ============================================================

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4285F4),
      ),
    );
  }
}

// ============================================================
// MICROSOFT ICON
// ============================================================

class MicrosoftIcon extends StatelessWidget {
  const MicrosoftIcon({super.key});

  @override
  Widget build(BuildContext context) {
    Widget square(Color color) =>
        Container(width: 6, height: 6, color: color);

    return SizedBox(
      width: 15,
      height: 15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              square(const Color(0xFFF25022)),
              square(const Color(0xFF7FBA00)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              square(const Color(0xFF00A4EF)),
              square(const Color(0xFFFFB900)),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MOBILE BRAND HEADER
//   Full-bleed, edge-to-edge slice of the SAME image used for
//   the desktop left panel (assets/icons/image.png), cropped to
//   just the logo + eyebrow + headline — the diagram and footer
//   underneath are clipped off by the fixed height below.
// ============================================================

/// Crop height as a multiple of the screen width. Raise this if
/// your headline is getting cut off; lower it if too much of the
/// circular diagram / "People" / "Applications" cards are showing
/// beneath it. 0.36 stops right after "Infinite Potential.", before
/// the diagram and cards begin.
const double _kHeaderAspect = 0.30;

/// Minimum/maximum crop height in logical pixels, tuned for the
/// 400–600px mobile width range so phones at either end still get
/// a sensible header size without revealing the cards below.
const double _kHeaderMinHeight = 130;
const double _kHeaderMaxHeight = 190;

class MobileBrandHeader extends StatelessWidget {
  const MobileBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cropHeight = (screenWidth * _kHeaderAspect)
        .clamp(_kHeaderMinHeight, _kHeaderMaxHeight);

    return Container(
      width: double.infinity,
      height: topInset + cropHeight,
      color: AppColors.black,
      padding: EdgeInsets.only(top: topInset),
      child: ClipRect(
        child: OverflowBox(
          maxHeight: double.infinity,
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/icons/image.png',
            width: screenWidth,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: screenWidth,
                height: cropHeight,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'STACKLY',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'CLOUD PLATFORM · HRMS · CRM · ERP · FINANCE · AI',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          letterSpacing: 1,
                          color: Color(0xFFB8C2FF),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'One identity.\n',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Infinite ',
                              style: TextStyle(color: AppColors.link),
                            ),
                            TextSpan(
                              text: 'Potential.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}