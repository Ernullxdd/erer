import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UrlInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isValidUrl;
  final bool isLoading;
  final VoidCallback onPaste;

  const UrlInputWidget({
    Key? key,
    required this.controller,
    required this.isValidUrl,
    required this.isLoading,
    required this.onPaste,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Input Label
        Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            'لینک توکن',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
        ),

        // URL Input Field with Paste Button
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: isValidUrl
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: isValidUrl ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Paste Button
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: TextButton.icon(
                  onPressed: isLoading ? null : onPaste,
                  icon: CustomIconWidget(
                    iconName: 'content_paste',
                    color: isLoading
                        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        : AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  label: Text(
                    'چسباندن',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isLoading
                          ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          : AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),

              // Vertical Divider
              Container(
                height: 4.h,
                width: 1,
                color: AppTheme.lightTheme.colorScheme.outline,
              ),

              // Text Input Field
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isLoading,
                  keyboardType: TextInputType.url,
                  textDirection: TextDirection.ltr,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'لینک حاوی توکن را اینجا وارد کنید',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                    ),
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    suffixIcon: isValidUrl
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Validation Indicator
        if (controller.text.isNotEmpty && !isValidUrl)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomIconWidget(
                  iconName: 'error_outline',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'فرمت لینک نامعتبر است',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
