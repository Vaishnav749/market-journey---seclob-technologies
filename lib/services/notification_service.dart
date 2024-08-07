import '../networking/constant.dart';
import '../support/dio_helper.dart';

class NotificationService {
  static Future ViewNotification() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/view-user-alerts' );
    print(response);
    return response.data;
  }
}