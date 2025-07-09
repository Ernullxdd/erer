import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/app_export.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = 'خطا در بارگذاری صفحه';
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow navigation within SnapFood domain
            if (request.url.contains('snappfood.ir')) {
              return NavigationDecision.navigate;
            }
            // Block external navigation
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://m.snappfood.ir'));
  }

  void _refreshPage() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _controller.reload();
  }

  void _goBack() {
    Navigator.pushReplacementNamed(context, '/token-authentication-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopNavigationBar(),
            _buildWebViewContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    return Container(
      width: double.infinity,
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _goBack,
            child: Container(
              width: 10.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'اسنپ‌فود',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _refreshPage,
            child: Container(
              width: 10.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebViewContent() {
    return Expanded(
      child: _hasError ? _buildErrorView() : _buildWebView(),
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'در حال بارگذاری...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 4.h),
          _buildSkeletonContent(),
        ],
      ),
    );
  }

  Widget _buildSkeletonContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          _buildSkeletonCard(),
          SizedBox(height: 2.h),
          _buildSkeletonCard(),
          SizedBox(height: 2.h),
          _buildSkeletonCard(),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      width: double.infinity,
      height: 12.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 40.w,
                    height: 1.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _errorMessage,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 1.h),
          Text(
            'لطفاً اتصال اینترنت خود را بررسی کنید',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: _refreshPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'refresh',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'تلاش مجدد',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: _goBack,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            ),
            child: Text(
              'بازگشت به صفحه احراز هویت',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}
