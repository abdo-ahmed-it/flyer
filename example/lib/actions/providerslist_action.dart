
import 'package:api_request/api_request.dart';

class ProvidersListAction extends ApiRequestAction<ProvidersListResponse> {
  @override
  bool get authRequired => false;

  @override
  RequestMethod get method => RequestMethod.GET;

  @override
  String get path => 'https://derman.code-link.com/api/providers';

  @override
  Map<String, dynamic> get toMap => null;

  @override
  ContentDataType? get contentDataType => null;

  @override
  ResponseBuilder<ProvidersListResponse> get responseBuilder =>
      (json) => ProvidersListResponse.fromJson(json);
}

  

class ProvidersListResponse {
  String? message;
  Data? data;

  ProvidersListResponse({this.message, this.data});

  ProvidersListResponse.fromJson(Map<String, dynamic> json) {
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
  Providers? providers;

  Data({this.providers});

  Data.fromJson(Map<String, dynamic> json) {
    providers = json['providers'] != null
        ? Providers.fromJson(json['providers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (providers != null) {
      data['providers'] = providers!.toJson();
    }
    return data;
  }
}

class Providers {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  Providers(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Providers.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (data != null) {
      data['data'] = data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}

