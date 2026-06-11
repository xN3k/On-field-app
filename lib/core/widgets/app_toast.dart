import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Visual variants for [AppToast].
enum ToastVariant { success, warning, error, info }

/// Reusable toast / snackbar-style notification, rendered as a top overlay.
///
/// Usage anywhere with a [BuildContext]:
/// ```dart
/// AppToast.success(context, 'Report Synced Successfully',
///     message: 'All field data is now live.');
/// AppToast.error(context, 'Sync Failed',
///     message: 'Please check your connection.');
/// ```
class AppToast {
  AppToast._();

  static OverlayEntry? _current;

  static void success(BuildContext context, String title, {String? message}) =>
      show(context, title: title, message: message, variant: ToastVariant.success);

  static void warning(BuildContext context, String title, {String? message}) =>
      show(context, title: title, message: message, variant: ToastVariant.warning);

  static void error(BuildContext context, String title, {String? message}) =>
      show(context, title: title, message: message, variant: ToastVariant.error);

  static void info(BuildContext context, String title, {String? message}) =>
      show(context, title: title, message: message, variant: ToastVariant.info);

  /// Shows a toast. Dismisses any currently-visible toast first.
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    ToastVariant variant = ToastVariant.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _current?.remove();
    _current = null;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _ToastWidget(
        title: title,
        message: message,
        variant: variant,
        duration: duration,
        onDismissed: () {
          if (_current == entry) _current = null;
          entry.remove();
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }
}

class _ToastStyle {
  const _ToastStyle({
    required this.icon,
    required this.accent,
    required this.filled,
  });

  final IconData icon;
  final Color accent;
  final bool filled;

  factory _ToastStyle.of(ToastVariant variant) {
    switch (variant) {
      case ToastVariant.success:
        return const _ToastStyle(
            icon: Icons.check, accent: AppColors.success, filled: false);
      case ToastVariant.warning:
        return const _ToastStyle(
            icon: Icons.location_on, accent: AppColors.warning, filled: false);
      case ToastVariant.error:
        return const _ToastStyle(
            icon: Icons.priority_high, accent: AppColors.error, filled: true);
      case ToastVariant.info:
        return const _ToastStyle(
            icon: Icons.info_outline, accent: AppColors.primary, filled: false);
    }
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.title,
    required this.message,
    required this.variant,
    required this.duration,
    required this.onDismissed,
  });

  final String title;
  final String? message;
  final ToastVariant variant;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  late final Animation<Offset> _offset = Tween<Offset>(
    begin: const Offset(0, -1.2),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissing || !mounted) return;
    _dismissing = true;
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _ToastStyle.of(widget.variant);
    final media = MediaQuery.of(context);

    final titleColor = style.filled ? Colors.white : AppColors.onSurface;
    final messageColor =
        style.filled ? Colors.white.withValues(alpha: 0.85) : AppColors.onSurfaceVariant;
    final closeColor =
        style.filled ? Colors.white.withValues(alpha: 0.85) : AppColors.onSurfaceVariant;

    return Positioned(
      top: media.padding.top + 12,
      left: 12,
      right: 12,
      child: SlideTransition(
        position: _offset,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: style.filled ? style.accent : AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: AppShadows.elevated,
              border: style.filled
                  ? null
                  : Border(left: BorderSide(color: style.accent, width: 5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _Icon(style: style),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                        if (widget.message != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.message!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: messageColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkResponse(
                    onTap: _dismiss,
                    radius: 20,
                    child: Icon(Icons.close, size: 22, color: closeColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.style});

  final _ToastStyle style;

  @override
  Widget build(BuildContext context) {
    if (style.filled) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(style.icon, color: Colors.white, size: 24),
      );
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: style.accent.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(style.icon, color: style.accent, size: 24),
    );
  }
}
