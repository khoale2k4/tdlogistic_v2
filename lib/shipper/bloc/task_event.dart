// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class CalculateFee extends TaskEvent {
  final String? provinceSource;
  final String? districtSource;
  final String? detailSource;
  final String? provinceDestination;
  final String? districtDestination;
  final String? detailDestination;
  final String? deliveryMethod;
  final num? height;
  final num? width;
  final num? length;
  final num? mass;
  
  const CalculateFee(this.provinceSource, this.districtSource, this.detailSource, this.provinceDestination, this.districtDestination, this.detailDestination, this.deliveryMethod, this.height, this.length, this.mass, this.width);
}

class GetTasks extends TaskEvent {
  final String? id;
  final int? status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int page;
  final int pageSize;

  const GetTasks({
    this.id,
    this.status,
    this.fromDate,
    this.toDate,
    this.page = 1,
    this.pageSize = 10,
  });

  @override
  List<Object?> get props => [id, status, fromDate, toDate, page, pageSize];
}

class StartTask extends TaskEvent{
  final String id = "";
  final int status = 1;
  final DateTime fromDate = DateTime(0);
  final DateTime toDate = DateTime.now();
  final int page = 0;
  final int pageSize = 5;

  @override
  List<Object?> get props => [id];
}

class GetOrderImages extends TaskEvent{
  final String orderId;

  GetOrderImages(this.orderId);
}

class AddTask extends TaskEvent{}

class AddImageEvent extends TaskEvent {
  final String category;
  final String orderId;
  final Uint8List newImage;
  final List<Uint8List> curImages;

  AddImageEvent({required this.category, required this.orderId,required this.newImage, required this.curImages});
}

class GetInfo extends TaskEvent{}

class AcceptTaskEvent extends TaskEvent{
  final String orderId;

  AcceptTaskEvent(this.orderId);
}

class GetPendingTask extends TaskEvent{}
