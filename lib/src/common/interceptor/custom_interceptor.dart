import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Naver-Client-Id'] = 'K2XcEd1MLxUkjypnWcdC';
    options.headers['X-Naver-Client-Secret'] = '7QuPTfdgC_';
    super.onRequest(options, handler);
  }
}