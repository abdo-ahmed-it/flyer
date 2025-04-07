
import 'package:api_request/api_request.dart';

class HomeAction extends ApiRequestAction<HomeResponse> {
  @override
  bool get authRequired => false;

  @override
  RequestMethod get method => RequestMethod.GET;

  @override
  String get path => 'https://derman.code-link.com/api/home';

  @override
  Map<String, dynamic> get toMap => null;

  @override
  ContentDataType? get contentDataType => null;

  @override
  ResponseBuilder<HomeResponse> get responseBuilder =>
      (json) => HomeResponse.fromJson(json);
}

  

class HomeResponse {
  String? message;
  Data? data;

  HomeResponse({this.message, this.data});

  HomeResponse.fromJson(Map<String, dynamic> json) {
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
  Banner? banner;
  List<Providers>? providers;

  Data({this.banner, this.providers});

  Data.fromJson(Map<String, dynamic> json) {
    banner = json['banner'] != null ? Banner.fromJson(json['banner']) : null;
    if (json['providers'] != null) {
      providers = <Providers>[];
      json['providers'].forEach((v) {
        providers!.add(Providers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banner != null) {
      data['banner'] = banner!.toJson();
    }
    if (providers != null) {
      data['providers'] = providers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  int? id;
  String? imageUrl;
  String? description;

  Banner({this.id, this.imageUrl, this.description});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    data['description'] = description;
    return data;
  }
}

class Providers {
  int? id;
  String? name;
  String? avatar;
  Null? phone;
  String? email;
  String? city;
  String? description;
  String? createdAt;
  String? updatedAt;
  List<Services>? services;
  List<Categories>? categories;

  Providers(
      {this.id,
      this.name,
      this.avatar,
      this.phone,
      this.email,
      this.city,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.services,
      this.categories});

  Providers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    phone = json['phone'];
    email = json['email'];
    city = json['city'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['phone'] = phone;
    data['email'] = email;
    data['city'] = city;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  String? image;
  String? name;
  String? description;
  int? categoryId;
  String? priceType;
  String? priceTypeText;
  int? price;
  int? duration;
  int? providerId;
  Null? count;
  String? providerName;
  Category? category;

  Services(
      {this.id,
      this.image,
      this.name,
      this.description,
      this.categoryId,
      this.priceType,
      this.priceTypeText,
      this.price,
      this.duration,
      this.providerId,
      this.count,
      this.providerName,
      this.category});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    priceType = json['price_type'];
    priceTypeText = json['price_type_text'];
    price = json['price'];
    duration = json['duration'];
    providerId = json['provider_id'];
    count = json['count'];
    providerName = json['provider_name'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['price_type'] = priceType;
    data['price_type_text'] = priceTypeText;
    data['price'] = price;
    data['duration'] = duration;
    data['provider_id'] = providerId;
    data['count'] = count;
    data['provider_name'] = providerName;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  int? parentId;
  String? image;

  Category({this.id, this.name, this.parentId, this.image});

  Category.fromJson(Map<String, dynamic> json) {
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

class Categories {
  int? id;
  String? name;
  int? parentId;
  String? image;

  Categories({this.id, this.name, this.parentId, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
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

