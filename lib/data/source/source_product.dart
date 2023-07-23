import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:inventory_app/config/api.dart';
import 'package:inventory_app/config/app_request.dart';
import 'package:inventory_app/data/model/product.dart';

class SourceProduct {
  static Future<int> count() async {
    String url = '${Api.product}/${Api.count}';
    String? responseBody = await AppRequest.gets(url);
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      return result['data'];
    }

    return 0;
  }

  static Future<List<Product>> gets() async {
    String url = '${Api.product}/${Api.gets}';
    String? responseBody = await AppRequest.gets(url);
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      if (result['success']) {
        List list = result['data'];
        return list.map((e) => Product.fromJson(e)).toList();
      }
      return [];
    }
    return [];
  }

  static Future<bool> add(Product product) async {
    String url = '${Api.product}/${Api.add}';
    String? responseBody = await AppRequest.post(url, {
      'code': product.code,
      'name': product.name,
      'stock': product.stock.toString(),
      'unit': product.unit,
      'price': product.price,
    });
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      //if false
      String message = result['message'] ?? '';
      if (message == 'code') {
        DInfo.toastError('Code already used');
      }
      return result['success'];
    }

    return false;
  }

  static Future<bool> update(String oldCode, Product product) async {
    String url = '${Api.product}/${Api.update}';
    String? responseBody = await AppRequest.post(url, {
      'old_code': oldCode,
      'code': product.code,
      'name': product.name,
      'stock': product.stock.toString(),
      'unit': product.unit,
      'price': product.price,
    });
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      // if false
      String message = result['message'] ?? '';
      if (message == 'code') {
        DInfo.toastError('Code already used');
      }
      // return follow success Api
      return result['success'];
    }
    return false;
  }

  static Future<bool> delete(String code) async {
    String url = '${Api.product}/${Api.delete}';
    String? responseBody = await AppRequest.post(url, {
      'code': code,
    });
    if (responseBody != null) {
      Map result = jsonDecode(responseBody);
      return result['success'];
    }
    return false;
  }
}
