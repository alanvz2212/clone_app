import 'package:equatable/equatable.dart';

abstract class SpecifierCreateEvent extends Equatable {
  const SpecifierCreateEvent();

  @override
  List<Object> get props => [];
}

class SubmitSpecifierCreateEvent extends SpecifierCreateEvent {
  final String projectName;
  final String contactPerson;
  final String contactNumber;
  final String remarks;
  final String sheet;

  const SubmitSpecifierCreateEvent({
    required this.projectName,
    required this.contactPerson,
    required this.contactNumber,
    required this.remarks,
    required this.sheet,
  });

  @override
  List<Object> get props => [
    projectName,
    contactPerson,
    contactNumber,
    remarks,
    sheet,
  ];
}
