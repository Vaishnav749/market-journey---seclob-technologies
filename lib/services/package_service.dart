import 'dart:math';

import 'package:master_journey/networking/constant.dart';
import 'package:master_journey/support/dio_helper.dart';

class PackageService {
  static Future ViewPackage() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/admin/view-package' );
    print(response);
    return response.data;
  }
}