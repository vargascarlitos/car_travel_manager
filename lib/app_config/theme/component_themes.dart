import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_styles.dart';

/// Temas específicos para componentes Material Design 3
/// 
/// Define el styling detallado para botones, cards, inputs y otros
/// componentes siguiendo las especificaciones del diseño dark theme.
class ComponentThemes {
  ComponentThemes._();

  // ========================================
  // APP BAR THEME
  // ========================================

  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.onSurface,
    elevation: 4,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.onSurface,
    ),
    iconTheme: IconThemeData(
      color: AppColors.onSurface,
      size: 24,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.onSurface,
      size: 24,
    ),
  );

  // ========================================
  // BUTTON THEMES
  // ========================================

  /// Botones principales (FilledButton) - Verde Bolt
  static final FilledButtonThemeData filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 6,
      shadowColor: AppColors.shadow,
      textStyle: AppTextStyles.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      minimumSize: const Size(64, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ).copyWith(
      // Estados interactivos
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.onPrimary.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.onPrimary.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return AppColors.onPrimary.withValues(alpha: 0.12);
        }
        return null;
      }),
      // Estado deshabilitado
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }
        return AppColors.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.onDisabled;
        }
        return AppColors.onPrimary;
      }),
    ),
  );

  /// Botones de contorno (OutlinedButton)
  static final OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      backgroundColor: AppColors.surfaceVariant,
      textStyle: AppTextStyles.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      minimumSize: const Size(64, 56),
      side: const BorderSide(
        color: AppColors.primary,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.primary.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return AppColors.primary.withValues(alpha: 0.08);
        }
        return null;
      }),
    ),
  );

  /// Botones de texto (TextButton)
  static final TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.onSurfaceVariant,
      textStyle: AppTextStyles.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      minimumSize: const Size(64, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  /// Floating Action Button
  static final FloatingActionButtonThemeData floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 8,
    focusElevation: 10,
    hoverElevation: 10,
    highlightElevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  // ========================================
  // CARD THEME
  // ========================================

  static final CardTheme cardTheme = CardTheme(
    color: AppColors.surfaceVariant,
    shadowColor: AppColors.shadow,
    elevation: 4,
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  // ========================================
  // INPUT THEMES
  // ========================================

  static final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceVariant,
    
    // Bordes
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.outline,
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.outline,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: 2,
      ),
    ),
    
    // Estilos de texto
    labelStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.onSurfaceVariant,
    ),
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
    ),
    errorStyle: AppTextStyles.error,
    
    // Contenido
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    
    // Iconos
    iconColor: AppColors.onSurfaceVariant,
    prefixIconColor: AppColors.primary,
    suffixIconColor: AppColors.onSurfaceVariant,
  );

  // ========================================
  // CHIP THEME
  // ========================================

  static final ChipThemeData chipTheme = ChipThemeData(
    backgroundColor: AppColors.surfaceVariant,
    selectedColor: AppColors.primaryContainer,
    disabledColor: AppColors.disabled,
    deleteIconColor: AppColors.onSurfaceVariant,
    labelStyle: AppTextStyles.labelMedium,
    secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(
      color: AppColors.onPrimaryContainer,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    side: const BorderSide(
      color: AppColors.outline,
      width: 1,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 0,
    pressElevation: 2,
  );

  // ========================================
  // LIST TILE THEME
  // ========================================

  static final ListTileThemeData listTileTheme = ListTileThemeData(
    tileColor: AppColors.surfaceVariant,
    selectedTileColor: AppColors.primaryContainer,
    iconColor: AppColors.primary,
    textColor: AppColors.onSurface,
    titleTextStyle: AppTextStyles.bodyLarge,
    subtitleTextStyle: AppTextStyles.bodyMedium,
    leadingAndTrailingTextStyle: AppTextStyles.labelMedium,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    minVerticalPadding: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // ========================================
  // DIALOG THEME
  // ========================================

  static final DialogTheme dialogTheme = DialogTheme(
    backgroundColor: AppColors.surfaceVariant,
    elevation: 8,
    shadowColor: AppColors.shadow,
    titleTextStyle: AppTextStyles.headlineSmall,
    contentTextStyle: AppTextStyles.bodyMedium,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  // ========================================
  // BOTTOM SHEET THEME
  // ========================================

  static final BottomSheetThemeData bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColors.surfaceVariant,
    elevation: 8,
    modalElevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
  );

  // ========================================
  // PROGRESS INDICATOR THEME
  // ========================================

  static final ProgressIndicatorThemeData progressIndicatorTheme = ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.outline,
    circularTrackColor: AppColors.outline,
  );

  // ========================================
  // SWITCH THEME
  // ========================================

  static final SwitchThemeData switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.onPrimary;
      }
      return AppColors.outline;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.surfaceVariant;
    }),
  );

  // ========================================
  // CHECKBOX THEME
  // ========================================

  static final CheckboxThemeData checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(AppColors.onPrimary),
    side: const BorderSide(
      color: AppColors.outline,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );

  // ========================================
  // RADIO THEME
  // ========================================

  static final RadioThemeData radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.outline;
    }),
  );

  // ========================================
  // SLIDER THEME
  // ========================================

  static final SliderThemeData sliderTheme = SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.outline,
    thumbColor: AppColors.primary,
    overlayColor: AppColors.primaryTransparent,
    valueIndicatorColor: AppColors.primaryContainer,
    valueIndicatorTextStyle: AppTextStyles.labelMedium,
  );

  // ========================================
  // DIVIDER THEME
  // ========================================

  static final DividerThemeData dividerTheme = DividerThemeData(
    color: AppColors.outline,
    thickness: 1,
    space: 1,
  );
}
