import 'package:flutter/material.dart';

/// The four shift states a schedule cell can hold.
enum ShiftType { morning, middle, afternoon, off }

extension ShiftTypeX on ShiftType {
  /// Short label shown in the schedule grid (M / Md / A / Off).
  String get label {
    switch (this) {
      case ShiftType.morning:
        return 'M';
      case ShiftType.middle:
        return 'Md';
      case ShiftType.afternoon:
        return 'A';
      case ShiftType.off:
        return 'Off';
    }
  }

  String get fullName {
    switch (this) {
      case ShiftType.morning:
        return 'Morning';
      case ShiftType.middle:
        return 'Middle';
      case ShiftType.afternoon:
        return 'Afternoon';
      case ShiftType.off:
        return 'Off';
    }
  }

  Color get color {
    switch (this) {
      case ShiftType.morning:
        return const Color(0xFFFFB74D);
      case ShiftType.middle:
        return const Color(0xFF64B5F6);
      case ShiftType.afternoon:
        return const Color(0xFFBA68C8);
      case ShiftType.off:
        return const Color(0xFFBDBDBD);
    }
  }
}
