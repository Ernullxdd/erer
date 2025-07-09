import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/authentication_button_widget.dart';
import './widgets/status_message_widget.dart';
import './widgets/url_input_widget.dart';

class TokenAuthenticationScreen extends StatefulWidget {
  const TokenAuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<TokenAuthenticationScreen> createState() =>
      _TokenAuthenticationScreenState();
}

class _TokenAuthenticationScreenState extends State<TokenAuthenticationScreen> {
  final TextEditingController _urlController = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  String _statusMessage = '';
  bool _isValidUrl = false;

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_validateUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _validateUrl() {
    final url = _urlController.text.trim();
    final isValid =
        Uri.tryParse(url)?.hasAbsolutePath == true && url.startsWith('http');

    if (_isValidUrl != isValid) {
      setState(() {
        _isValidUrl = isValid;
        _statusMessage = '';
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        _urlController.text = clipboardData!.text!;
        _validateUrl();
      }
    } catch (e) {
      _showToast('خطا در دسترسی به کلیپ‌بورد');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      textColor: AppTheme.lightTheme.colorScheme.onSurface,
      fontSize: 14.0,
    );
  }

  Future<void> _authenticateWithToken() async {
    if (!_isValidUrl || _isLoading) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'در حال پردازش...';
    });

    try {
      final response = await _dio.get(_urlController.text.trim());

      if (response.statusCode == 200) {
        final jsonData = response.data;

        // Parse nested JSON structure
        if (jsonData is Map<String, dynamic>) {
          final tokenData = _extractTokenData(jsonData);

          if (tokenData != null) {
            await _setCookies(tokenData);
            _showSuccessAndNavigate();
          } else {
            _showError('ساختار JSON نامعتبر است');
          }
        } else {
          _showError('پاسخ سرور نامعتبر است');
        }
      } else {
        _showError('خطا در دریافت اطلاعات از سرور');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        _showError('زمان اتصال به پایان رسید');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        _showError('زمان دریافت پاسخ به پایان رسید');
      } else {
        _showError('خطا در اتصال به اینترنت');
      }
    } catch (e) {
      _showError('خطای غیرمنتظره رخ داد');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic>? _extractTokenData(Map<String, dynamic> jsonData) {
    try {
      // Look for nested JSON structure
      for (final key in jsonData.keys) {
        final value = jsonData[key];
        if (value is Map<String, dynamic>) {
          if (value.containsKey('access_token') &&
              value.containsKey('refresh_token') &&
              value.containsKey('expires_in')) {
            return {
              'access_token': value['access_token'] as String,
              'refresh_token': value['refresh_token'] as String,
              'expires_in': value['expires_in'].toString(),
            };
          }
        }
      }

      // Check if tokens are at root level
      if (jsonData.containsKey('access_token') &&
          jsonData.containsKey('refresh_token') &&
          jsonData.containsKey('expires_in')) {
        return {
          'access_token': jsonData['access_token'] as String,
          'refresh_token': jsonData['refresh_token'] as String,
          'expires_in': jsonData['expires_in'].toString(),
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _setCookies(Map<String, dynamic> tokenData) async {
    try {
      // In a real implementation, you would use a cookie manager
      // For now, we'll simulate cookie setting
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock cookie setting for m.snappfood.ir domain
      final cookies = {
        'jwt-access_token': tokenData['access_token'],
        'jwt-refresh_token': tokenData['refresh_token'],
        'jwt-expires_in': tokenData['expires_in'],
      };

      // Simulate successful cookie setting
      print('Cookies set for m.snappfood.ir: $cookies');
    } catch (e) {
      throw Exception('خطا در تنظیم کوکی‌ها');
    }
  }

  void _showSuccessAndNavigate() {
    setState(() {
      _statusMessage = 'احراز هویت با موفقیت انجام شد';
    });

    _showToast('کوکی‌ها با موفقیت تنظیم شدند');

    // Navigate to WebView screen after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamed(context, '/web-view-screen');
    });
  }

  void _showError(String message) {
    setState(() {
      _statusMessage = message;
    });
    _showToast(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 4.h),

              // App Branding Section
              _buildBrandingSection(),

              SizedBox(height: 6.h),

              // URL Input Section
              UrlInputWidget(
                controller: _urlController,
                isValidUrl: _isValidUrl,
                isLoading: _isLoading,
                onPaste: _pasteFromClipboard,
              ),

              SizedBox(height: 4.h),

              // Authentication Button
              AuthenticationButtonWidget(
                isEnabled: _isValidUrl && !_isLoading,
                isLoading: _isLoading,
                onPressed: _authenticateWithToken,
              ),

              SizedBox(height: 3.h),

              // Status Message Section
              StatusMessageWidget(
                message: _statusMessage,
                isLoading: _isLoading,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingSection() {
    return Column(
      children: [
        // App Logo/Icon
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: CustomIconWidget(
            iconName: 'restaurant',
            color: Colors.white,
            size: 10.w,
          ),
        ),

        SizedBox(height: 3.h),

        // App Title
        Text(
          'SnapFood Auth',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 1.h),

        // Instruction Text
        Text(
          'برای ورود به حساب کاربری خود، لینک حاوی توکن را وارد کنید',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
