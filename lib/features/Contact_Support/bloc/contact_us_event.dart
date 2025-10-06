import 'package:equatable/equatable.dart';

abstract class ContactUsEvent extends Equatable {
  const ContactUsEvent();

  @override
  List<Object> get props => [];
}

class SubmitContactUsEvent extends ContactUsEvent {
  final String whatsappNumber;
  final String contactNumber;
  final String companyName;
  final String companyAddress;
  final String companyGST;
  final String gstCertificate;

  const SubmitContactUsEvent({
    required this.whatsappNumber,
    required this.contactNumber,
    required this.companyName,
    required this.companyAddress,
    required this.companyGST,
    required this.gstCertificate, 
  });

  @override
  List<Object> get props => [
    whatsappNumber,
    contactNumber,
    companyName,
    companyAddress,
    companyGST,
    gstCertificate,
  ];
}
