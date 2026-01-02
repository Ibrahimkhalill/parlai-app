import 'package:dio/dio.dart';

String getErrorMessage(dynamic e) {
  if (e is DioException) {
    return e.message ?? "Something went wrong";
  }

  final msg = e.toString();
  return msg.replaceFirst('Exception: ', '');
}
