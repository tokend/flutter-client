class IdentityResourceModel {
  String email;
  String address;
  String phone;
  String passport;
  String telegramUsername;

  IdentityResourceModel(this.email, this.address, this.phone, this.passport,
      this.telegramUsername);

  IdentityResourceModel.fromJson(Map<String, dynamic> json)
      : email = json['attributes']['email'],
        address = json['attributes']['address'],
        phone = json['attributes']['phone_number'],
        passport = json['attributes']['passport'],
        telegramUsername = json['attributes']['telegram_username'];
}
