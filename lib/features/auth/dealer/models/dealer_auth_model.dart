import 'package:equatable/equatable.dart';
import 'dealer.dart';
class DealerLoginRequest extends Equatable {
  final String mobileNumberOrId;
  final String password;
  const DealerLoginRequest({
    required this.mobileNumberOrId,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {'mobileNumber': mobileNumberOrId, 'password': password};
  }
  @override
  List<Object?> get props => [mobileNumberOrId, password];
}
class DealerLoginResponse extends Equatable {
  final bool success;
  final String? token;
  final Dealer? dealer;
  final String? message;
  final String? error;
  const DealerLoginResponse({
    required this.success,
    this.token,
    this.dealer,
    this.message,
    this.error,
  });
  factory DealerLoginResponse.fromJson(Map<String, dynamic> json) {
    print('=== DealerLoginResponse.fromJson Debug ===');
    print('Full JSON: $json');
    print('Success: ${json['success']}');
    print('Data exists: ${json['data'] != null}');
    if (json['data'] != null) {
      print('Data content: ${json['data']}');
      print('Token: ${json['data']['token']}');
      print('Data.data exists: ${json['data']['data'] != null}');
      if (json['data']['data'] != null) {
        print('Dealer data: ${json['data']['data']}');
        print('Dealer name in response: ${json['data']['data']['name']}');
      }
    }
    print('=== End Debug ===');
    Dealer? dealer;
    String? token;
    if (json['data'] != null) {
      final data = json['data'];
      token = data['token'] as String?;
      if (data['data'] != null) {
        dealer = Dealer.fromJson(data['data']);
      } else if (data['dealer'] != null) {
        dealer = Dealer.fromJson(data['dealer']);
      } else if (data['user'] != null) {
        dealer = Dealer.fromJson(data['user']);
      } else {
        try {
          dealer = Dealer.fromJson(data);
        } catch (e) {
          print('Could not parse dealer from data directly: $e');
        }
      }
    }
    return DealerLoginResponse(
      success: json['success'] as bool? ?? false,
      token: token,
      dealer: dealer,
      message: json['message'] as String?,
      error: json['success'] == false
          ? json['message'] as String?
          : json['error'] as String?,
    );
  }
  factory DealerLoginResponse.success({
    required String token,
    required Dealer dealer,
    String? message,
  }) {
    return DealerLoginResponse(
      success: true,
      token: token,
      dealer: dealer,
      message: message,
    );
  }
  factory DealerLoginResponse.failure({required String error}) {
    return DealerLoginResponse(success: false, error: error);
  }
  @override
  List<Object?> get props => [success, token, dealer, message, error];
}
class DealerForgotPasswordRequest extends Equatable {
  final String mobileNumberOrId;
  const DealerForgotPasswordRequest({required this.mobileNumberOrId});
  Map<String, dynamic> toJson() {
    return {'mobile_number_or_id': mobileNumberOrId, 'user_type': 'dealer'};
  }
  @override
  List<Object?> get props => [mobileNumberOrId];
}

