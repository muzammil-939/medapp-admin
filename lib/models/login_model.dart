class UserModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

 UserModel({this.statusCode, this.success, this.messages, this.data});

  factory UserModel.initial() => UserModel(
        statusCode: 0,
        success: false,
        messages: [],
        data: [],
      );

 UserModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return UserModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

 UserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages'].cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? accessToken;
  String? refreshToken;
  Admin? admin;

  Data({this.accessToken, this.refreshToken, this.admin});

  factory Data.initial() => Data(
        accessToken: "",
        refreshToken: "",
        admin: Admin.initial(),
      );

  Data copyWith({
    String? accessToken,
    String? refreshToken,
    Admin? admin,
  }) {
    return Data(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      admin: admin ?? this.admin,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    admin = json['admin'] != null ? Admin.fromJson(json['admin']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    if (admin != null) {
      data['admin'] = admin!.toJson();
    }
    return data;
  }
}

class Admin {
  String? id;
  String? role;

  Admin({this.id, this.role});

  factory Admin.initial() => Admin(
        id: "",
        role: "",
      );

  Admin copyWith({
    String? id,
    String? role,
  }) {
    return Admin(
      id: id ?? this.id,
      role: role ?? this.role,
    );
  }

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['role'] = role;
    return data;
  }
}
