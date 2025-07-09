import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuthenticationButtonWidget extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const AuthenticationButtonWidget({
    Key? key,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          elevation: isEnabled ? 2.0 : 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'در حال پردازش...',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'login',
                    color: Colors.white,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'تنظیم کوکی‌ها و ورود',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
      ),
    );
  }
}
