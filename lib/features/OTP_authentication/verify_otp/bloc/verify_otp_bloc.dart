import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/verify_otp_service.dart';
import '../models/verify_otp_response.dart';
import '../../../../services/auth_service.dart';
import '../../../../features/auth/models/user.dart';
import '../../../../features/auth/dealer/models/dealer.dart';
import '../../../../features/auth/dealer/bloc/dealer_auth_bloc.dart';
import '../../../../features/auth/dealer/bloc/dealer_auth_event.dart';
import '../../../../features/auth/dealer/services/dealer_auth_hive_service.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';
class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpService verifyOtpService;
  final AuthService authService;
  
  VerifyOtpBloc({
    required this.verifyOtpService,
    required this.authService,
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
        
        // Create User object from UserData
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
        );
        
        // Store user data and token in auth service
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
            taxID: userData.taxID != null ? int.tryParse(userData.taxID!) : null,
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
        
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: response.message,
          userData: userData,
          token: token,
          refreshToken: response.data!.refresh,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: response.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}

