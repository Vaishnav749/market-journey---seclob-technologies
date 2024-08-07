import '../networking/constant.dart';
import '../support/dio_helper.dart';

class ProfileService {
  static Future profile() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/view-user-profile');
    return response.data;
  }

  static Future viewzonal(id) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/view-user-profile/$id');
    return response.data;
  }

  static Future viewpanchayath(id) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/view-user-profile/$id');
    return response.data;
  }


}