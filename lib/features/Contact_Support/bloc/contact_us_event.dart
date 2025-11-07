import 'dart:io';
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
  final File gstCertificateFile;

  const SubmitContactUsEvent({
    required this.whatsappNumber,
    required this.contactNumber,
    required this.companyName,
    required this.companyAddress,
    required this.companyGST,
    required this.gstCertificateFile, 
  });

  @override
  List<Object> get props => [
    whatsappNumber,
    contactNumber,
    companyName,
    companyAddress,
    companyGST,
    gstCertificateFile,
  ];
}
