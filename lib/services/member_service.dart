import '../networking/constant.dart';
import '../support/dio_helper.dart';

class MemberService {
  static Future AddMember(Map<String, dynamic> reqData) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/user/add-user', data: reqData);
    return response.data;
  }

  static Future<bool> checkFieldUnique({String? email, String? phone}) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get(
        '$baseURL/api/user/view-level1-user?page=1&pageSize=10&searchText=');
    var data = response.data['child1'] as List;

    // Check if email or phone exists in the response data
    bool emailExists =
        email != null && data.any((user) => user['email'] == email);
    bool phoneExists =
        phone != null && data.any((user) => user['phone'] == phone);

    return emailExists || phoneExists;
  }

  static Future<Map<String, dynamic>> addMember(
      Map<String, dynamic> reqData) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post(
      '$baseURL/api/user/add-member',
      data: reqData,
    );
    return response.data;
  }

  static Future GetPackageTypes() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/add-user');
    return response.data;
  }

    static Future Memberview() async {
    var dio = await DioHelper.getInstance();
    var response = await dio
        .post('$baseURL/api/user/view-district-Users');
    print(response);
    return response.data;
  }

  static Future Memberviewtree(id) async {
    var dio = await DioHelper.getInstance();
    var response = await dio
        .post('$baseURL/api/user/view-level1-user?id=$id');
    print(response);
    return response.data;
  }
  static Future Memberstate() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/admin/view-states');
    print(response);
    return response.data;
  }


    static Future leveloneview() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/user/view-level1-user');
    print(response);
    return response.data;
  }

  static Future leveltwoview() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/user/view-level2-user');
    print(response);
    return response.data;
  }

  static Future Memberdistrict(id) async {
    var dio = await DioHelper.getInstance();
    var response =
        await dio.get('$baseURL/api/admin/view-dropdown-districts/$id');
    print(response);
    return response.data;
  }

  static Future leveloneuser() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/user/view-level1-user');
    print(response);
    return response.data;
  }
  static Future Memberzonal(districtId) async {
    var dio = await DioHelper.getInstance();
    var response =
        await dio.get('$baseURL/api/admin/view-dropdown-zonals/$districtId');
    print(response);
    return response.data;
  }

  static Future Memberpanchayath(zonalId) async {
    var dio = await DioHelper.getInstance();
    var response =
        await dio.get('$baseURL/api/admin/view-dropdown-panchayaths/$zonalId');
    print(response);
    return response.data;
  }

  static Future Membernotdistrict(districtId) async {
    var dio = await DioHelper.getInstance();
    var response =
        await dio.get('$baseURL/api/admin/view-nottaken-districts/$districtId');
    print(response);
    return response.data;
  }

  static Future Membernotzonal(districtId) async {
    var dio = await DioHelper.getInstance();
    var response =
        await dio.get('$baseURL/api/admin/view-nottaken-zonals/$districtId');
    print(response);
    return response.data;
  }
}



// import '../networking/constant.dart';
// import '../support/dio_helper.dart';
//
// class MemberService {
//   static Future AddMember(Map<String, dynamic> reqData) async {
//     var dio = await DioHelper.getInstance();
//     var response = await dio.post('$baseURL/api/user/add-user', data: reqData);
//     return response.data;
//   }
//
//   static Future<bool> checkFieldUnique({String? email, String? phone}) async {
//     var dio = await DioHelper.getInstance();
//     var response = await dio.get(
//         '$baseURL/api/user/view-level1-user?page=1&pageSize=10&searchText=');
//     var data = response.data['child1'] as List;
//
//     // Check if email or phone exists in the response data
//     bool emailExists =
//         email != null && data.any((user) => user['email'] == email);
//     bool phoneExists =
//         phone != null && data.any((user) => user['phone'] == phone);
//
//     return emailExists || phoneExists;
//   }
//
//   // static Future<Map<String, dynamic>> addMember(
//   //     Map<String, dynamic> reqData) async {
//   //   var dio = await DioHelper.getInstance();
//   //   var response = await dio.post(
//   //     '$baseURL/api/user/add-member',
//   //     data: reqData,
//   //   );
//   //   return response.data;
//   // }
//
//   static Future GetPackageTypes() async {
//     var dio = await DioHelper.getInstance();
//     var response = await dio.get('$baseURL/api/user/add-user');
//     return response.data;
//   }
//
//   static Future Memberview() async {
//     var dio = await DioHelper.getInstance();
//     var response = await dio
//         .post('$baseURL/api/user/view-district-Users');
//     print(response);
//     return response.data;
//   }
//
//   static Future leveloneview() async {
//     var dio = await DioHelper.getInstance();
//     var response = await dio.post('$baseURL/api/user/view-level1-user');
//     print(response);
//     return response.data;
//   }
//
//   static Future leveltwoview() async {
//     var dio = await DioHelper.getInstance();
//     var response = await dio.get('$baseURL/api/user/view-level2-user');
//     print(response);
//     return response.data;
//   }
//
//   static Future Memberstate() async {
//     var dio = await DioHelper.getInstance();
//     var response = await dio.get('$baseURL/api/admin/view-states');
//     print(response);
//     return response.data;
//   }
//
//   static Future Memberdistrict(id) async {
//     var dio = await DioHelper.getInstance();
//     var response =
//     await dio.get('$baseURL/api/admin/view-dropdown-districts/$id');
//     print(response);
//     return response.data;
//   }
//
//   static Future Memberzonal(districtId) async {
//     var dio = await DioHelper.getInstance();
//     var response =
//     await dio.get('$baseURL/api/admin/view-dropdown-zonals/$districtId');
//     print(response);
//     return response.data;
//   }
//
//   static Future Memberpanchayath(zonalId) async {
//     var dio = await DioHelper.getInstance();
//     var response =
//     await dio.get('$baseURL/api/admin/view-dropdown-panchayaths/$zonalId');
//     print(response);
//     return response.data;
//   }
//
//   static Future Membernotdistrict(districtId) async {
//     var dio = await DioHelper.getInstance();
//     var response =
//     await dio.get('$baseURL/api/admin/view-nottaken-districts/$districtId');
//     print(response);
//     return response.data;
//   }
//
//   static Future Membernotzonal(districtId) async {
//     var dio = await DioHelper.getInstance();
//     var response =
//     await dio.get('$baseURL/api/admin/view-nottaken-zonals/$districtId');
//     print(response);
//     return response.data;
//   }
// }