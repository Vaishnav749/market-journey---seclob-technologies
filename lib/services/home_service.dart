import '../networking/constant.dart';
import '../support/dio_helper.dart';



class homeservice {
  static Future viewpackageaddon() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/view-addon-signals');
    return response.data;
  }
  static Future viewRewards() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/admin/view-award-details');
    print(response);
    return response.data;
  }

  static Future viewleaders() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/get-pool-amount');
    return response.data;
  }
  static Future viewSubscription() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/user-subscription-report');
    return response.data;
  }
  static Future viewRenewalpackage() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/view-renewal-packages');
    return response.data;
  }

  static Future viewConvertpackage() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/view-convert-packages');
    return response.data;
  }
  static Future distributedleaders()  async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/get-pool-count-amount');
    return response.data;
  }

  static Future viewNews() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/admin/view-news-details');
    print(response);
    return response.data;
  }

  static Future viewImageFeeds() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/admin/view-home-images');
    return response.data;
  }

  static Future viewVideoFeeds() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/admin/view-home-videos');
    return response.data;
  }

  static Future uploadScreenshot(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/user/user-verification', data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  static Future ChangePass(Map<String, String> reqData) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/user/change-password');
    print(response);
    return response.data;
  }
}





