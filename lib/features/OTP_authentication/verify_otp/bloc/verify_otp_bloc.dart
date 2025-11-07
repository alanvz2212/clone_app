import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/verify_otp_service.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/mobile_log_service.dart';
import '../../../../services/user_service.dart';
import '../../../../features/auth/models/user.dart';
import '../../../../features/auth/dealer/models/dealer.dart';
import '../../../../features/auth/dealer/services/dealer_auth_hive_service.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpService verifyOtpService;
  final AuthService authService;
  final MobileLogService mobileLogService;
  final UserService userService;

  VerifyOtpBloc({
    required this.verifyOtpService,
    required this.authService,
    required this.mobileLogService,
    required this.userService,
  }) : super(VerifyOtpState()) {
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
  }
  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await verifyOtpService.verifyOtp(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      );
      if (response.success && response.data != null) {
        final userData = response.data!.data;
        final token = response.data!.token;

        final user = User(
          userId: userData.mainId,
          mobileNumber: userData.mobile,
          name: userData.name,
          email: userData.email,
          userType: userData.type == 0 ? UserType.dealer : UserType.transporter,
          id: userData.id,
          isActive: !userData.isDeleted,
          createdAt: DateTime.parse(userData.createdDate),
          lastLoginAt: DateTime.now(),
          isSpecifier: userData.isSpecifier,
        );

        await authService.setToken(token);
        await authService.setUser(user);
        await authService.setStayLoggedIn(true);

        if (userData.type == 0) {
          final dealer = Dealer(
            name: userData.name,
            email: userData.email,
            mobile: userData.mobile,
            id: userData.id,
            contactPerson: userData.contactPerson,
            contactNumber: userData.contactNumber,
            stateId: userData.stateId,
            taxID: userData.taxID != null
                ? int.tryParse(userData.taxID!)
                : null,
            type: userData.type,
            countryId: userData.countryId,
            districtId: userData.districtId,
            notes: userData.notes,
            numberOfCreditDays: userData.numberOfCreditDays?.toString(),
            numberOfBlockDays: userData.numberOfBlockDays?.toString(),
            executiveId: userData.executiveId,
            pinCode: userData.pinCode,
            bankName: userData.bankName,
            bankBranch: userData.bankBranch,
            accountNumber: userData.accountNumber,
            ifscCode: userData.ifscCode,
            upiId: userData.upiId,
            iban: userData.iban,
            swiftCode: userData.swiftCode,
            status: userData.status as int?,
            allowEmail: userData.allowEmail == true ? 1 : 0,
            allowTCS: userData.allowTCS == true ? 1 : 0,
            allowSMS: userData.allowSMS == true ? 1 : 0,
            blockReason: userData.blockReason,
            creditLimit: userData.creditLimit?.toString(),
            useCostCentre: userData.useCostCentre,
            gstRegistrationType: userData.gstRegistrationType,
            gstNo: userData.gstNo,
            panNo: userData.panNo,
            typeofDuty: userData.typeofDuty,
            gstApplicablility: userData.gstApplicablility,
            taxType: userData.taxType,
            hsnCode: userData.hsnCode,
          );

          await DealerAuthHiveService.saveAuthData(
            token: token,
            dealer: dealer,
            mobileNumber: event.phoneNumber,
            password: '',
            stayLoggedIn: true,
          );
        }

        // final userType = userData.type == 0 ? 'Dealer' : 'Transporter'?'Specifier';
        final userType = userData.type == 0
            ? 'Dealer'
            : userData.type == 1
            ? 'Transporter'
            : 'Specifier';

        await mobileLogService.sendMobileLog(
          userId: userData.id,
          userType: userType,
          token: token,
        );

        // Store mobile user and phone number for order placement
        await userService.setMobileUserAndPhoneNumber(
          response.data!.mobileUser,
          response.data!.phoneNumber,
        );

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            message: response.message,
            userData: userData,
            token: token,
            refreshToken: response.data!.refresh,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
