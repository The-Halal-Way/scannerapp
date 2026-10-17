// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/core/app_routes.dart';
import 'package:scannerapp/core/base/auth_session_store.dart';
import 'package:scannerapp/core/constants/my_api_url.dart';
import 'package:scannerapp/core/constants/my_string.dart';
import 'package:scannerapp/core/error/api_exception.dart';
import 'package:scannerapp/core/global_service.dart';
import 'package:scannerapp/core/navigation_service.dart';
import 'package:scannerapp/core/util/app_access_dialog.dart';
import 'package:scannerapp/core/util/internet_check.dart';
import 'package:scannerapp/core/util/my_dialog.dart';

class BaseClient {
  static final dio = Dio(BaseOptions(connectTimeout: Duration(seconds: 3)));
  static Future<void>? _activeInsufficientCreditsPrompt;

  static Future<bool> ensureInternetConnection(BuildContext context) {
    return InternetCheck.instance.ensureConnected(context);
  }

  static bool _isSuccessfulStatusCode(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  static void _logDioError(String scope, DioException e) {
    developer.log(
      '[BaseClient][$scope] ${e.message}',
      name: 'BaseClient',
      stackTrace: e.stackTrace,
    );
    developer.log(
      '[BaseClient][$scope] method=${e.requestOptions.method} path=${e.requestOptions.path}',
      name: 'BaseClient',
    );
    developer.log(
      '[BaseClient][$scope] query=${redactSensitiveDataForLogging(e.requestOptions.queryParameters)} '
      'body=${redactSensitiveDataForLogging(e.requestOptions.data)}',
      name: 'BaseClient',
    );
    developer.log(
      '[BaseClient][$scope] statusCode=${e.response?.statusCode} '
      'response=${redactSensitiveDataForLogging(e.response?.data)}',
      name: 'BaseClient',
    );
  }

  static void _logResponse(int? statusCode, Object? data) {
    Logger().t(
      'Status Code $statusCode: ${redactSensitiveDataForLogging(data)}',
    );
  }

  @visibleForTesting
  static Object? redactSensitiveDataForLogging(Object? value) {
    if (value is FormData) return '[form data redacted]';
    if (value is Map) {
      return value.map<Object?, Object?>((key, nestedValue) {
        final normalizedKey = key.toString().toLowerCase().replaceAll(
          RegExp('[^a-z0-9]'),
          '',
        );
        final isSensitive =
            normalizedKey.contains('password') ||
            normalizedKey.contains('secret') ||
            normalizedKey.contains('token') ||
            normalizedKey.contains('authorization') ||
            normalizedKey.contains('verificationdata') ||
            normalizedKey.contains('transactionjws') ||
            normalizedKey.contains('signedtransaction') ||
            normalizedKey.contains('signedpayload') ||
            normalizedKey.contains('receipt') ||
            normalizedKey.contains('clientsecret');
        return MapEntry<Object?, Object?>(
          key,
          isSensitive
              ? '[redacted]'
              : redactSensitiveDataForLogging(nestedValue),
        );
      });
    }
    if (value is Iterable) {
      return value.map<Object?>(redactSensitiveDataForLogging).toList();
    }
    if (value is String && value.length > 2048) {
      return '[large string redacted]';
    }
    return value;
  }

  static Map<String, String> get header {
    final String? accessToken = GlobalService.instance.accessToken;

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (accessToken != null && accessToken.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  static bool _isSessionExpired(DioException e) {
    return e.response?.statusCode == 401;
  }

  static Future<bool> _refreshAccessToken(BuildContext context) async {
    final String? refreshToken = GlobalService.instance.refreshToken;
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      return false;
    }
    if (!await ensureInternetConnection(context)) return false;

    try {
      final String url =
          "${MyApiUrl.baseUrl}/${MyApiUrl.version}/${MyApiUrl.authRefresh}";
      final response = await dio.post(
        url,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      final data = response.data;
      if (_isSuccessfulStatusCode(response.statusCode) &&
          data is Map<String, dynamic>) {
        GlobalService.instance.saveSessionFromServer(data);
        await AuthSessionStore.instance.saveSession(data);
        return true;
      }
    } catch (e) {
      developer.log(
        '[BaseClient][_refreshAccessToken] Refresh request failed: $e',
        name: 'BaseClient',
        error: e,
      );
      Logger().e('Refresh token request failed: $e');
    }

    return false;
  }

  static Future<dynamic> getData({
    required String endPoint,
    Object? body,
    Map<String, dynamic>? parameters,
    Options? options,
    required BuildContext ctx,
    bool retryOnAuthError = true,
  }) async {
    if (!await ensureInternetConnection(ctx)) return null;

    try {
      final url = "${MyApiUrl.baseUrl}/${MyApiUrl.version}/$endPoint";
      Logger().i(parameters == null ? url : '$url query=$parameters');
      final response = await dio.get(
        url,
        queryParameters: parameters,
        data: body ?? jsonEncode({}),
        options: options ?? Options(headers: header),
      );
      log(
        'Status Code ${response.statusCode}: '
        '${redactSensitiveDataForLogging(response.data)}',
      );
      //  Logger().t("Status Code ${response.statusCode}: ${response.data}");
      if (_isSuccessfulStatusCode(response.statusCode)) return response.data;
      MyDialog().showFailedToast(msg: MyString.errorMsg, context: ctx);
    } on DioException catch (e) {
      _logDioError('getData', e);
      if (retryOnAuthError && _isSessionExpired(e)) {
        final didRefresh = await _refreshAccessToken(ctx);
        if (didRefresh) {
          return getData(
            endPoint: endPoint,
            body: body,
            parameters: parameters,
            options: options,
            ctx: ctx,
            retryOnAuthError: false,
          );
        }
      }
      ApiException.handleException(e, ctx);
    } catch (e) {
      Logger().e(e);
      MyDialog().showFailedToast(
        title: "Unexpected Error!",
        msg: e.toString(),
        context: ctx,
      );
    }
  }

  static Future<dynamic> postData({
    required String endPoint,
    Object? body,
    Map<String, dynamic>? parameters,
    Options? options,
    required BuildContext ctx,
    bool retryOnAuthError = true,
  }) async {
    if (!await ensureInternetConnection(ctx)) return null;

    try {
      final url = "${MyApiUrl.baseUrl}/${MyApiUrl.version}/$endPoint";
      Logger().i("$url/$parameters");
      final response = await dio.post(
        url,
        queryParameters: parameters,
        data: body ?? jsonEncode({}),
        options: options ?? Options(headers: header),
      );
      _logResponse(response.statusCode, response.data);
      if (_isSuccessfulStatusCode(response.statusCode)) return response.data;
      //MyDialog().showFailedToast(msg: MyString.errorMsg, context: ctx);
    } on DioException catch (e) {
      _logDioError('postData', e);
      if (retryOnAuthError && _isSessionExpired(e)) {
        final didRefresh = await _refreshAccessToken(ctx);
        if (didRefresh) {
          return postData(
            endPoint: endPoint,
            body: body,
            parameters: parameters,
            options: options,
            ctx: ctx,
            retryOnAuthError: false,
          );
        }
      }
      ApiException.handleException(e, ctx);
    } catch (e) {
      Logger().e(e);
      MyDialog().showFailedToast(
        title: "Unexpected Error!",
        msg: e.toString(),
        context: ctx,
      );
    }
  }

  static Future<dynamic> postFormData({
    required String endPoint,
    required Future<FormData> Function() formDataBuilder,
    Map<String, dynamic>? parameters,
    Options? options,
    required BuildContext ctx,
    bool retryOnAuthError = true,
  }) async {
    if (!await ensureInternetConnection(ctx)) return null;

    try {
      final url = "${MyApiUrl.baseUrl}/${MyApiUrl.version}/$endPoint";
      Logger().i("$url/$parameters");
      final formData = await formDataBuilder();

      final Map<String, String> formHeaders = Map<String, String>.from(header)
        ..remove('Content-Type');

      final response = await dio.post(
        url,
        queryParameters: parameters,
        data: formData,
        options: options ?? Options(headers: formHeaders),
      );
      _logResponse(response.statusCode, response.data);
      if (_isSuccessfulStatusCode(response.statusCode)) return response.data;
      if (_isInsufficientCreditsResponse(response.statusCode, response.data)) {
        await _showInsufficientCreditsPrompt(
          requestContext: ctx,
          data: response.data,
        );
        return null;
      }
      MyDialog().showFailedToast(msg: MyString.errorMsg, context: ctx);
    } on DioException catch (e) {
      _logDioError('postFormData', e);
      if (retryOnAuthError && _isSessionExpired(e)) {
        final didRefresh = await _refreshAccessToken(ctx);
        if (didRefresh) {
          return postFormData(
            endPoint: endPoint,
            formDataBuilder: formDataBuilder,
            parameters: parameters,
            options: options,
            ctx: ctx,
            retryOnAuthError: false,
          );
        }
      }
      if (_isInsufficientCreditsResponse(
        e.response?.statusCode,
        e.response?.data,
      )) {
        await _showInsufficientCreditsPrompt(
          requestContext: ctx,
          data: e.response?.data,
        );
        return null;
      }
      ApiException.handleException(e, ctx);
    } catch (e) {
      Logger().e(e);
      MyDialog().showFailedToast(
        title: "Unexpected Error!",
        msg: e.toString(),
        context: ctx,
      );
    }
  }

  static Future<dynamic> patchData({
    required String endPoint,
    Object? body,
    Map<String, dynamic>? parameters,
    Options? options,
    required BuildContext ctx,
    bool retryOnAuthError = true,
  }) async {
    if (!await ensureInternetConnection(ctx)) return null;

    try {
      final url = "${MyApiUrl.baseUrl}/${MyApiUrl.version}/$endPoint";
      Logger().i("$url/$parameters");
      final response = await dio.patch(
        url,
        queryParameters: parameters,
        data: body ?? jsonEncode({}),
        options: options ?? Options(headers: header),
      );
      _logResponse(response.statusCode, response.data);
      if (_isSuccessfulStatusCode(response.statusCode)) return response.data;
      MyDialog().showFailedToast(msg: MyString.errorMsg, context: ctx);
    } on DioException catch (e) {
      _logDioError('patchData', e);
      if (retryOnAuthError && _isSessionExpired(e)) {
        final didRefresh = await _refreshAccessToken(ctx);
        if (didRefresh) {
          return patchData(
            endPoint: endPoint,
            body: body,
            parameters: parameters,
            options: options,
            ctx: ctx,
            retryOnAuthError: false,
          );
        }
      }
      Logger().e(e);
      ApiException.handleException(e, ctx);
    } catch (e) {
      Logger().e(e);
      MyDialog().showFailedToast(
        title: "Unexpected Error!",
        msg: e.toString(),
        context: ctx,
      );
    }
  }

  static Future<dynamic> putData({
    required String endPoint,
    Object? body,
    Map<String, dynamic>? parameters,
    Options? options,
    required BuildContext ctx,
    bool retryOnAuthError = true,
  }) async {
    if (!await ensureInternetConnection(ctx)) return null;

    try {
      final url = "${MyApiUrl.baseUrl}/${MyApiUrl.version}/$endPoint";
      Logger().i("$url/$parameters");
      final response = await dio.put(
        url,
        queryParameters: parameters,
        data: body ?? jsonEncode({}),
        options: options ?? Options(headers: header),
      );
      _logResponse(response.statusCode, response.data);
      if (_isSuccessfulStatusCode(response.statusCode)) return response.data;
      MyDialog().showFailedToast(msg: MyString.errorMsg, context: ctx);
    } on DioException catch (e) {
      _logDioError('putData', e);
      if (retryOnAuthError && _isSessionExpired(e)) {
        final didRefresh = await _refreshAccessToken(ctx);
        if (didRefresh) {
          return putData(
            endPoint: endPoint,
            body: body,
            parameters: parameters,
            options: options,
            ctx: ctx,
            retryOnAuthError: false,
          );
        }
      }
      ApiException.handleException(e, ctx);
    } catch (e) {
      Logger().e(e);
      MyDialog().showFailedToast(
        title: "Unexpected Error!",
        msg: e.toString(),
        context: ctx,
      );
    }
  }

  static Future<dynamic> deleteData({
    required String endPoint,
    Object? body,
    Map<String, dynamic>? parameters,
    Options? options,
    required BuildContext ctx,
    bool retryOnAuthError = true,
  }) async {
    if (!await ensureInternetConnection(ctx)) return null;

    try {
      final url = "${MyApiUrl.baseUrl}/${MyApiUrl.version}/$endPoint";
      Logger().i("$url/$parameters");
      final response = await dio.delete(
        url,
        queryParameters: parameters,
        data: body,
        options: options ?? Options(headers: header),
      );
      _logResponse(response.statusCode, response.data);
      if (_isSuccessfulStatusCode(response.statusCode)) {
        // DELETE endpoints commonly return 204 No Content. Preserve a
        // successful result even when Dio exposes the response body as null.
        return response.data ?? true;
      }
      MyDialog().showFailedToast(msg: MyString.errorMsg, context: ctx);
    } on DioException catch (e) {
      _logDioError('deleteData', e);
      if (retryOnAuthError && _isSessionExpired(e)) {
        final didRefresh = await _refreshAccessToken(ctx);
        if (didRefresh) {
          return deleteData(
            endPoint: endPoint,
            body: body,
            parameters: parameters,
            options: options,
            ctx: ctx,
            retryOnAuthError: false,
          );
        }
      }
      ApiException.handleException(e, ctx);
    } catch (e) {
      Logger().e(e);
      MyDialog().showFailedToast(
        title: "Unexpected Error!",
        msg: e.toString(),
        context: ctx,
      );
    }
  }

  static bool _isInsufficientCreditsResponse(int? statusCode, dynamic data) {
    if (statusCode != 402 || data is! Map) return false;
    final error = data['error'];
    return error is Map && error['code'] == 'INSUFFICIENT_CREDITS';
  }

  static int? _creditDetail(dynamic data, String key) {
    if (data is! Map) return null;
    final error = data['error'];
    if (error is! Map) return null;
    final details = error['details'];
    if (details is! Map) return null;

    final value = details[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return value is String ? int.tryParse(value) : null;
  }

  static String _formatCredits(int credits) {
    return credits.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  static String _insufficientCreditsMessage(dynamic data) {
    if (data is Map) {
      final error = data['error'];
      if (error is Map) {
        final message = error['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }
      }
    }
    return 'You need more credits to complete this request.';
  }

  static Future<void> _showInsufficientCreditsPrompt({
    required BuildContext requestContext,
    required dynamic data,
  }) {
    final activePrompt = _activeInsufficientCreditsPrompt;
    if (activePrompt != null) return activePrompt;

    final prompt = _presentInsufficientCreditsPrompt(
      requestContext: requestContext,
      data: data,
    );
    _activeInsufficientCreditsPrompt = prompt;
    return prompt.whenComplete(() {
      if (identical(_activeInsufficientCreditsPrompt, prompt)) {
        _activeInsufficientCreditsPrompt = null;
      }
    });
  }

  static Future<void> _presentInsufficientCreditsPrompt({
    required BuildContext requestContext,
    required dynamic data,
  }) async {
    final presentationContext = requestContext.mounted
        ? requestContext
        : NavigationService.instance.maybeContext;
    if (presentationContext == null || !presentationContext.mounted) return;

    final requiredCredits = _creditDetail(data, 'required');
    final availableCredits = _creditDetail(data, 'available');
    final shortfall = requiredCredits != null && availableCredits != null
        ? requiredCredits - availableCredits
        : null;
    final metrics = <AppAccessDialogMetric>[
      if (availableCredits != null)
        AppAccessDialogMetric(
          label: 'Available',
          value: _formatCredits(availableCredits),
          icon: Icons.account_balance_wallet_rounded,
        ),
      if (requiredCredits != null)
        AppAccessDialogMetric(
          label: 'Required',
          value: _formatCredits(requiredCredits),
          icon: Icons.auto_awesome_rounded,
        ),
    ];
    final points = <String>[
      if (shortfall != null && shortfall > 0)
        'Add ${_formatCredits(shortfall)} more credits to continue',
      'Review flexible plans and credit packs in Billing',
    ];

    final action = await AppAccessDialog.show(
      context: presentationContext,
      data: AppAccessDialogData(
        eyebrow: 'Credit boost',
        title: 'Your next idea needs more power',
        message: _insufficientCreditsMessage(data),
        icon: Icons.bolt_rounded,
        primaryLabel: 'Buy credits',
        secondaryLabel: 'Maybe later',
        metrics: metrics,
        points: points,
        accent: presentationContext.appColors.coral,
      ),
    );

    if (action != AppAccessDialogAction.primary) return;
    final navigator = NavigationService.instance.navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushNamed<void>(AppRoutes.settingsBilling);
      return;
    }
    if (presentationContext.mounted) {
      Navigator.of(
        presentationContext,
        rootNavigator: true,
      ).pushNamed<void>(AppRoutes.settingsBilling);
    }
  }
}
