
import 'package:api_request/api_request.dart';

class FilterDataAction extends ApiRequestAction<FilterDataResponse> {
  @override
  bool get authRequired => false;

  @override
  RequestMethod get method => RequestMethod.GET;

  @override
  String get path => 'https://derman.code-link.com/api/filter/data';

  @override
  Map<String, dynamic> get toMap => null;

  @override
  ContentDataType? get contentDataType => null;

  @override
  ResponseBuilder<FilterDataResponse> get responseBuilder =>
      (json) => FilterDataResponse.fromJson(json);
}

  

class FilterDataResponse {
  String? message;
  Data? data;

  FilterDataResponse({this.message, this.data});

  FilterDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (data != null) {
      data['data'] = data!.toJson();
    }
    return data;
  }
}

class Data {
  List<MainCategories>? mainCategories;
  List<Cities>? cities;

  Data({this.mainCategories, this.cities});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['main_categories'] != null) {
      mainCategories = <MainCategories>[];
      json['main_categories'].forEach((v) {
        mainCategories!.add(MainCategories.fromJson(v));
      });
    }
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainCategories != null) {
      data['main_categories'] = mainCategories!.map((v) => v.toJson()).toList();
    }
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainCategories {
  int? id;
  String? name;
  Null? parentId;
  String? image;
  List<Children>? children;

  MainCategories(
      {this.id, this.name, this.parentId, this.image, this.children});

  MainCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    image = json['image'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['image'] = image;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  int? id;
  String? name;
  int? parentId;
  String? image;

  Children({this.id, this.name, this.parentId, this.image});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_id'] = parentId;
    data['image'] = image;
    return data;
  }
}

class Cities {
  int? id;
  String? name;

  Cities({this.id, this.name});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

