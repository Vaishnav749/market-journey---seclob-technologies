import '../networking/constant.dart';
import '../support/dio_helper.dart';

class NewsService {
  static Future viewNews() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/admin/view-news-details');
    print(response);
    return response.data;
  }
}
