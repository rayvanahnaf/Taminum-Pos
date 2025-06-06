import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_pos/data/datasource/auth_local_datasource.dart';
import 'package:flutter_pos/data/model/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';

class AuthRemoteDataSource {
  Future<Either<String, AuthResponseModel>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      } ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Right(AuthResponseModel.fromMap(json));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      AuthLocalDatasource().removeAuthData();
      return Right(response.body);
    } else {
      return Left(response.body);
    }
  }
}