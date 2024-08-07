import '../networking/constant.dart';
import '../support/dio_helper.dart';

class LoginService {
  static Future login(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/user/user-login', data: data);
    print(response);
    return response.data;
  }
}
