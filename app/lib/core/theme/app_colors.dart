import 'package:flutter/material.dart';

/// CORTEX color palette — dark-first, technical, professional.
class AppColors {
  AppColors._();

  // Primary
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFF9D97FF);
  static const primaryDark = Color(0xFF4A42E0);

  // Background
  static const backgroundDark = Color(0xFF0D1117);
  static const surfaceDark = Color(0xFF161B22);
  static const cardDark = Color(0xFF1C2128);
  static const borderDark = Color(0xFF30363D);

  // Text
  static const textPrimary = Color(0xFFE6EDF3);
  static const textSecondary = Color(0xFF8B949E);
  static const textMuted = Color(0xFF484F58);

  // Domain colors (for mastery bars, tags)
  static const domainRL = Color(0xFF58A6FF);
  static const domainRobot = Color(0xFF3FB950);
  static const domainPerception = Color(0xFFD2A8FF);
  static const domainFoundation = Color(0xFFF0883E);
  static const domainGenerative = Color(0xFFF778BA);
  static const domainSystems = Color(0xFF79C0FF);
  static const domainML = Color(0xFFE3B341);

  // Semantic
  static const success = Color(0xFF3FB950);
  static const error = Color(0xFFF85149);
  static const warning = Color(0xFFD29922);
  static const info = Color(0xFF58A6FF);

  // Quality rating colors (0-5)
  static const quality0 = Color(0xFFF85149);
  static const quality1 = Color(0xFFF85149);
  static const quality2 = Color(0xFFD29922);
  static const quality3 = Color(0xFFD29922);
  static const quality4 = Color(0xFF3FB950);
  static const quality5 = Color(0xFF3FB950);

  static Color qualityColor(int quality) {
    switch (quality) {
      case 0:
      case 1:
        return quality1;
      case 2:
      case 3:
        return quality3;
      case 4:
      case 5:
        return quality5;
      default:
        return textMuted;
    }
  }

  static Color domainColor(String domain) {
    switch (domain) {
      case 'rl':
        return domainRL;
      case 'robot_learning':
        return domainRobot;
      case 'perception':
        return domainPerception;
      case 'foundation_models':
        return domainFoundation;
      case 'generative_control':
        return domainGenerative;
      case 'systems':
        return domainSystems;
      case 'ml_fundamentals':
        return domainML;
      default:
        return textSecondary;
    }
  }
}
