import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Кастомная кнопка для веб-интерфейса с поддержкой hover-эффектов
class WebButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final bool showArrow;
  final IconData? icon;
  final bool isLoading;

  const WebButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.isFullWidth = false,
    this.showArrow = false,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<WebButton> createState() => _WebButtonState();
}

class _WebButtonState extends State<WebButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: _getBackgroundColor(isDisabled),
          borderRadius: BorderRadius.circular(28),
          border: !widget.isPrimary
              ? Border.all(
                  color: isDisabled
                      ? AppColors.inputBorder
                      : AppColors.primary.withOpacity(_isHovered ? 1.0 : 0.5),
                  width: 2,
                )
              : null,
          boxShadow: widget.isPrimary && !isDisabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(
                      _isHovered ? 0.4 : 0.2,
                    ),
                    blurRadius: _isHovered ? 16 : 12,
                    offset: Offset(0, _isHovered ? 6 : 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: widget.isFullWidth
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  if (widget.icon != null && !widget.isLoading) ...[
                    Icon(
                      widget.icon,
                      color: _getTextColor(isDisabled),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (widget.isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(isDisabled),
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        widget.text,
                        style: widget.isPrimary
                            ? AppTextStyles.button.copyWith(
                                color: _getTextColor(isDisabled),
                              )
                            : AppTextStyles.buttonSecondary.copyWith(
                                color: _getTextColor(isDisabled),
                              ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (widget.showArrow && !widget.isLoading) ...[
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward,
                      color: _getTextColor(isDisabled),
                      size: 20,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDisabled) {
    if (isDisabled) {
      return widget.isPrimary
          ? AppColors.inputBorder.withOpacity(0.3)
          : Colors.transparent;
    }

    if (!widget.isPrimary) {
      return _isHovered
          ? AppColors.primary.withOpacity(0.05)
          : Colors.transparent;
    }

    return _isHovered ? AppColors.primary.withOpacity(0.9) : AppColors.primary;
  }

  Color _getTextColor(bool isDisabled) {
    if (isDisabled) {
      return AppColors.textSecondary.withOpacity(0.5);
    }

    if (!widget.isPrimary) {
      return AppColors.primary;
    }

    return Colors.white;
  }
}
