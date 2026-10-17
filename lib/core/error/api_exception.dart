import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scannerapp/core/util/my_dialog.dart';

class ApiException implements Exception {
  static void handleException(DioException exception, BuildContext ctx) {
    switch (exception.type) {
      case DioException.badResponse:
        handleErrorStatus(exception, ctx);
      case DioExceptionType.cancel:
        MyDialog().showFailedToast(
          title: "Request Cancelled!",
          msg: "The request was cancelled before completion.",
          context: ctx,
        );
      case DioExceptionType.receiveTimeout:
        MyDialog().showFailedToast(
          title: "Receive Timeout",
          msg: "Unable to connect to the device.",
          context: ctx,
        );
      case DioExceptionType.connectionError:
        MyDialog().showFailedToast(
          title: "Connection Error!",
          msg: "Connection error. Please try again.",
          context: ctx,
        );
      case DioExceptionType.connectionTimeout:
        MyDialog().showFailedToast(
          title: "Connection Timeout!",
          msg: "Unable to connect to the server.",
          context: ctx,
        );
      default:
        handleErrorStatus(exception, ctx);
    }
  }

  static void handleErrorStatus(DioException e, BuildContext ctx) {
    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case (201):
        MyDialog().showInfoToast(
          msg: "201: The request was successful.",
          context: ctx,
        );
        return;
      case (202):
        MyDialog().showInfoToast(
          msg: "202: The request has been accepted for processing.",
          context: ctx,
        );
        return;
      case (204):
        MyDialog().showInfoToast(
          msg: "204: Sorry, No content is available!",
          context: ctx,
        );
        return;
    }

    // Prefer the server's own error message/code over a canned one, since
    // it carries the actual reason (e.g. "Not enough credits to complete
    // this request.") rather than a generic per-status-code blurb.
    final serverMessage = _extractServerMessage(e.response?.data);
    if (statusCode != null && statusCode >= 400 && serverMessage != null) {
      final serverCode = _extractServerCode(e.response?.data);
      MyDialog().showFailedToast(
        title: serverCode ?? _fallbackTitle(statusCode),
        msg: serverMessage,
        context: ctx,
      );
      return;
    }

    switch (statusCode) {
      case 400:
        MyDialog().showFailedToast(
          title: "Bad Request",
          msg: " The server could not process the request.",
          context: ctx,
        );
        break;
      case 401:
        MyDialog().showFailedToast(
          title: "Unauthorized",
          msg: " Access is denied due to invalid credentials.",
          context: ctx,
        );
        break;
      case 403:
        MyDialog().showFailedToast(
          title: "Forbidden",
          msg: " You don't have permission to access this resource.",
          context: ctx,
        );
        break;
      case 404:
        MyDialog().showFailedToast(
          title: "Not Found",
          msg: " The requested resource was not found on the server.",
          context: ctx,
        );
        break;
      case 422:
        MyDialog().showFailedToast(
          title: "Incorrect  request",
          msg: " The server could not process the request.",
          context: ctx,
        );
        break;
      case 500:
        MyDialog().showFailedToast(
          title: "Internal Server Error",
          msg: " The server encountered an error.",
          context: ctx,
        );
        break;
      default:
        MyDialog().showFailedToast(
          title: "$statusCode",
          msg: "Received unexpected status code",
          context: ctx,
        );
    }
  }

  static String _fallbackTitle(int statusCode) => "Error $statusCode";

  /// Pulls the human-readable message out of a server error body, trying the
  /// shapes this backend is known to use:
  /// `{error: {message: "..."}}`, `{message: "..."}`, `{detail: "..."}`.
  static String? _extractServerMessage(dynamic data) {
    if (data is Map) {
      final error = data['error'];
      if (error is Map) {
        final message = error['message'];
        if (message is String && message.trim().isNotEmpty) return message;
      }
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) return message;

      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) return detail;

      if (error is String && error.trim().isNotEmpty) return error;
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }

  /// Pulls the machine error code (e.g. `INSUFFICIENT_CREDITS`) out of a
  /// server error body and turns it into a readable toast title.
  static String? _extractServerCode(dynamic data) {
    if (data is! Map) return null;
    final error = data['error'];
    if (error is! Map) return null;

    final code = error['code'];
    if (code is! String || code.trim().isEmpty) return null;

    return code
        .split(RegExp(r'[_\s]+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
