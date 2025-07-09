import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusMessageWidget extends StatelessWidget {
  final String message;
  final bool isLoading;

  const StatusMessageWidget({
    Key? key,
    required this.message,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Status Icon
          CustomIconWidget(
            iconName: _getIconName(),
            color: _getIconColor(),
            size: 5.w,
          ),

          SizedBox(width: 3.w),

          // Status Message
          Expanded(
            child: Text(
              message.isNotEmpty ? message : 'در حال پردازش درخواست...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),

          // Loading Indicator
          if (isLoading) ...[
            SizedBox(width: 3.w),
            SizedBox(
              width: 4.w,
              height: 4.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isLoading) {
      return AppTheme.lightTheme.colorScheme.primaryContainer;
    } else if (message.contains('موفقیت') || message.contains('تنظیم شد')) {
      return AppTheme.lightTheme.colorScheme.primaryContainer;
    } else if (message.contains('خطا') || message.contains('نامعتبر')) {
      return AppTheme.lightTheme.colorScheme.errorContainer;
    } else {
      return AppTheme.lightTheme.colorScheme.surfaceContainerHighest;
    }
  }

  Color _getBorderColor() {
    if (isLoading) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (message.contains('موفقیت') || message.contains('تنظیم شد')) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (message.contains('خطا') || message.contains('نامعتبر')) {
      return AppTheme.lightTheme.colorScheme.error;
    } else {
      return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getIconName() {
    if (isLoading) {
      return 'hourglass_empty';
    } else if (message.contains('موفقیت') || message.contains('تنظیم شد')) {
      return 'check_circle';
    } else if (message.contains('خطا') || message.contains('نامعتبر')) {
      return 'error';
    } else {
      return 'info';
    }
  }

  Color _getIconColor() {
    if (isLoading) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (message.contains('موفقیت') || message.contains('تنظیم شد')) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (message.contains('خطا') || message.contains('نامعتبر')) {
      return AppTheme.lightTheme.colorScheme.error;
    } else {
      return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getTextColor() {
    if (isLoading) {
      return AppTheme.lightTheme.colorScheme.onPrimaryContainer;
    } else if (message.contains('موفقیت') || message.contains('تنظیم شد')) {
      return AppTheme.lightTheme.colorScheme.onPrimaryContainer;
    } else if (message.contains('خطا') || message.contains('نامعتبر')) {
      return AppTheme.lightTheme.colorScheme.onErrorContainer;
    } else {
      return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
