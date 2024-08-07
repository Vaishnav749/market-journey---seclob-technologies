import '../networking/constant.dart';
import '../support/dio_helper.dart';

class WalletService {
  static Future Walletrequest(reqData) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/user/withdraw-wallet', data: reqData);
    return response.data;
  }
  static Future wallet() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/wallet-withdraw-report');
    return response.data;
  }
}