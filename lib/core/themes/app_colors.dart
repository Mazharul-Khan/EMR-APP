import 'package:flutter/widgets.dart';

/// Centralized color palette for the entire EMR application.
/// All UI widgets must reference colors from this class to ensure visual consistency.
abstract class AppColors {
  // ==========================================
  // 1. Primary & Brand Colors
  // ==========================================
  static const Color primaryBlue = Color(0xFF0062FF);
  static const Color brightBlue = Color(0xFF0062FF); // backward compatibility alias
  static const Color primaryBlueDark = Color(0xFF1E40AF);
  static const Color primaryBlueLight = Color(0xFF60A5FA);
  static const Color primaryBlueSoft = Color(0xFFEFF6FF);
  static const Color primaryBlueIce = Color(0xFFEEF4FF);

  // ==========================================
  // 2. Dark Navy Theme (Sidebar & TopBar)
  // ==========================================
  static const Color deepNavyBlue = Color(0xFF0A192F);
  static const Color darkBlue = Color(0xFF0F172A);
  static const Color navyCardBackground = Color(0xFF13233A);
  static const Color navyBorderDivider = Color(0xFF1E293B);
  static const Color navyBorderSubtle = Color(0xFF1E3A8A);
  static const Color syncButtonBg = Color(0xFF13233A);
  static const Color syncButtonBorder = Color(0xFF1E3A8A);
  static const Color syncButtonActiveBg = Color(0xFF1E293B);

  // ==========================================
  // 3. Backgrounds & Canvas
  // ==========================================
  static const Color backgroundGradientIceBlue = Color(0xFFEBF3FC);
  static const Color backgroundGradientCloudBlue = Color(0xFFE2EDF8);
  static const Color backgroundGradientColoudBlue = Color(0xFFE2EDF8); // backward compatibility alias
  static const Color dashboardCanvasBackground = Color(0xFFF4F8FC);
  static const Color cardSurfaceLight = Color(0xFFF8FAFC);
  static const Color lightGray = Color(0xFFF8FAFC); // backward compatibility alias
  static const Color lightGray2 = Color(0xFFF1F5F9); // backward compatibility alias
  static const Color dividerLight = Color(0xFFF1F5F9);
  static const Color footerBackground = Color(0xFFE0E0E0);

  // ==========================================
  // 4. Text & Neutral Grays
  // ==========================================
  static const Color textDark = Color(0xFF0F172A);
  static const Color darkStaleBlue = Color(0xFF334155);
  static const Color textBody = Color(0xFF475569);
  static const Color blueGrayShade = Color(0xFF475569); // backward compatibility alias
  static const Color gray = Color(0xFF64748B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // ==========================================
  // 5. Borders & Outlines
  // ==========================================
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);

  // ==========================================
  // 6. Role Colors & Badges
  // ==========================================
  // Doctor
  static const Color roleDoctorText = Color(0xFF2563EB);
  static const Color roleDoctorBg = Color(0xFFEFF6FF);
  static const Color roleDoctorCardBg = Color(0xFFE0F2FE);
  static const Color roleDoctorIcon = Color(0xFF0284C7);
  static const Color roleDoctorIndigo = Color(0xFF4338CA);
  static const Color roleDoctorIndigoBg = Color(0xFFE0E7FF);

  // Patient
  static const Color rolePatientText = Color(0xFF16A34A);
  static const Color rolePatientBg = Color(0xFFF0FDF4);
  static const Color rolePatientCardBg = Color(0xFFECFDF5);
  static const Color rolePatientBorder = Color(0xFFBBF7D0);
  static const Color rolePatientDarkText = Color(0xFF15803D);
  static const Color rolePatientMintBg = Color(0xFFD1FAE5);
  static const Color rolePatientMintDark = Color(0xFF065F46);

  // Admin
  static const Color roleAdminText = Color(0xFF9333EA);
  static const Color roleAdminBg = Color(0xFFFAF5FF);

  // Role Hierarchy Styling (Admin Dark, Doctor Medium, Patient Light)
  static const Color roleAdminDarkBg = Color(0xFF0F172A);
  static const Color roleAdminDarkText = Color(0xFFFFFFFF);
  static const Color roleAdminDarkBorder = Color(0xFF334155);

  static const Color roleDoctorMediumBg = Color(0xFF2563EB);
  static const Color roleDoctorMediumText = Color(0xFFFFFFFF);
  static const Color roleDoctorMediumBorder = Color(0xFF60A5FA);

  static const Color rolePatientLightBg = Color(0xFFDCFCE7);
  static const Color rolePatientLightText = Color(0xFF166534);
  static const Color rolePatientLightBorder = Color(0xFF86EFAC);

  // Current User List Highlight
  static const Color currentUserRowBg = Color(0xFFF0F7FF);
  static const Color currentUserRowBorder = Color(0xFFBFDBFE);
  static const Color currentUserBadgeBg = Color(0xFFDBEAFE);
  static const Color currentUserBadgeText = Color(0xFF1D4ED8);
  static const Color currentUserBadgeBorder = Color(0xFF93C5FD);

  // Warnings & Dialogs
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color warningAmberDark = Color(0xFFB45309);
  static const Color warningAmberBg = Color(0xFFFEF3C7);
  static const Color warningAmberBorder = Color(0xFFFDE68A);

  // General Avatar Colors
  static const Color avatarIndigoText = Color(0xFF4F46E5);
  static const Color avatarIndigoBg = Color(0xFFEEF2FF);

  // ==========================================
  // 7. Status, Feedback & Alerts
  // ==========================================
  // Success / Active
  static const Color successGreen = Color(0xFF10B981);
  static const Color lightTeal = Color(0xFF10B981); // backward compatibility alias
  static const Color successGreenDark = Color(0xFF059669);
  static const Color successGreenSoftBg = Color(0xFFECFDF5);

  // Danger / Error / Inactive / Logout
  static const Color errorRed = Color(0xFFEF4444);
  static const Color errorRedDark = Color(0xFFDC2626);
  static const Color errorRedSoftBg = Color(0xFFFEF2F2);
  static const Color errorRedBadgeBg = Color(0xFFFEE2E2);

  // ==========================================
  // 8. Shimmer & Skeleton Loaders
  // ==========================================
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // ==========================================
  // 9. Shadows & Transparencies
  // ==========================================
  static const Color shadowSubtle = Color(0x0A000000);
  static const Color shadowMedium = Color(0x0F000000);
  static const Color shadowCardDark = Color(0x0A0F172A);
  static const Color veryLightBlack = Color(0x0A000000); // backward compatibility alias
  static const Color primaryBlueShadow = Color(0x290062FF);
  static const Color primaryBlueShadowSubtle = Color(0x260062FF);
  static const Color splashGlow1 = Color(0x1F0062FF);
  static const Color splashGlow2 = Color(0x150062FF);
  static const Color whiteTranslucent20 = Color(0x33FFFFFF);
  static const Color whiteTranslucent25 = Color(0x40FFFFFF);
  static const Color whiteTranslucent90 = Color(0xE6FFFFFF);

  // ==========================================
  // 10. KPI Stat Card Gradients & Borders (Vibrant & Bright)
  // ==========================================
  // Card 1: Total Accounts (Blue Gradient)
  static const Color statCardBlueGradientStart = Color(0xFFEBF3FE);
  static const Color statCardBlueGradientEnd = Color(0xFFC7DEFE);
  static const Color statCardBlueBorder = Color(0xFF93C5FD);

  // Card 2: Medical Staff / Doctors (Sky/Cyan Gradient)
  static const Color statCardDoctorGradientStart = Color(0xFFE0F7FE);
  static const Color statCardDoctorGradientEnd = Color(0xFFBAE6FD);
  static const Color statCardDoctorBorder = Color(0xFF67E8F9);

  // Card 3: Patients Registered (Mint/Emerald Gradient)
  static const Color statCardPatientGradientStart = Color(0xFFE2F9E8);
  static const Color statCardPatientGradientEnd = Color(0xFFB4F4CB);
  static const Color statCardPatientBorder = Color(0xFF6EE7B7);

  // Card 4: Disabled Accounts (Rose/Coral Gradient)
  static const Color statCardDisabledGradientStart = Color(0xFFFFECEF);
  static const Color statCardDisabledGradientEnd = Color(0xFFFECDD3);
  static const Color statCardDisabledBorder = Color(0xFFFDA4AF);
}
