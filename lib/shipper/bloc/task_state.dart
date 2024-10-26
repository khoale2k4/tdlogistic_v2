import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:tdlogistic_v2/core/models/order_model.dart';
import 'package:tdlogistic_v2/shipper/data/models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskFeeCalculating extends TaskState {}

class TaskFeeCalculated extends TaskState {
  final num fee;

  const TaskFeeCalculated(this.fee);
}

class TaskFeeCalculationFailed extends TaskState {
  final String error;

  const TaskFeeCalculationFailed(this. error);
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final int totalTasks;
  int page = 1;

  TaskLoaded(this.tasks, this.totalTasks, {this.page = 1});
}

class TaskDetailLoaded extends TaskState {
  final Task task;

  const TaskDetailLoaded(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TaskState {}

class TaskError extends TaskState {
  final String error;

  const TaskError(this.error);

  @override
  List<Object?> get props => [error];
}

class GettingImages extends TaskState{}

class GotImages extends TaskState{
  late List<Uint8List> sendImages;
  late List<Uint8List> receiveImages;
  late Uint8List? sendSignature;
  late Uint8List? receiveSignature;

  GotImages(this.receiveImages, this.receiveSignature, this.sendImages, this.sendSignature);
}

class AddingImage extends TaskState{}

class AddedImage extends TaskState{}

class FailedImage extends TaskState{
  final String error;

  FailedImage(this.error);
}

class GettingOrderDetail extends TaskState{}

class GotOrderDetail extends TaskState{
  final Order order;

  GotOrderDetail(this.order);
}

class FaildGettingOrderDetail extends TaskState{
  final String error;

  FaildGettingOrderDetail(this.error);
}

class WaitingTask extends TaskState{}

class AcceptingTask extends TaskState{}

class AcceptedTask extends TaskState{}

class FailedAcceptingTask extends TaskState{
  final String error;

  FailedAcceptingTask(this.error);
}