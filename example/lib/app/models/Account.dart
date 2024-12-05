class Account {
  int? id;
  String? name;
  Customer? customer;
  Status? status;

  Account({this.id, this.name, this.customer, this.status});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? avatar;
  String? fullName;
  String? fullPhone;

  Customer({this.id, this.avatar, this.fullName, this.fullPhone});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    fullName = json['fullName'];
    fullPhone = json['fullPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['fullName'] = fullName;
    data['fullPhone'] = fullPhone;
    return data;
  }
}

class Status {
  String? id;
  String? text;

  Status({this.id, this.text});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    return data;
  }
}
