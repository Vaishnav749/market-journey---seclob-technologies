import '../networking/constant.dart';
import '../support/dio_helper.dart';
import '../support/logger.dart';

class BankService{
   static Future Addbank(Map<String, dynamic> reqData) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/user/add-bank-account', data: reqData);
    return response.data;
  }
   static Future Dematedetail() async {
     var dio = await DioHelper.getInstance();
     var response =
     await dio.get('$baseURL/api/user/view-demate-accounts?page=1&pageSize=10');
     return response.data;
   }

static Future Nominee(Map<String, dynamic> reqData) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/user/add-nominee', data: reqData);
    return response.data;
  }

   static Future Demate(Map<String, dynamic> reqData) async {
     var dio = await DioHelper.getInstance();
     var response =
     await dio.post('$baseURL/api/user/add-demate-account', data: reqData);
     return response.data;
   }
   static Future<bool> checkFieldUnique(
       String fieldName, String fieldValue) async {
     try {
       var dio = await DioHelper.getInstance();
       var response = await dio
           .get('$baseURL/api/user/view-demate-accounts?page=1&pageSize=10');
       List<dynamic> accounts = response.data[
       'demateAccounts']; // Adjust if needed based on actual response structure

       for (var account in accounts) {
         if (account[fieldName] == fieldValue) {
           return false; // Field value already exists
         }
       }
       return true; // Field value is unique
     } catch (error) {
       log.e('Error checking $fieldName uniqueness: $error');
       return false; // Assume not unique if there is an error
     }
   }

}