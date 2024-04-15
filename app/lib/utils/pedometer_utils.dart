import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';

void initPedometer(
  void Function(StepCount event) onStep,
  void Function(PedestrianStatus event) statusChange,
) {
  late Stream<StepCount> stepCountStream;
  late Stream<PedestrianStatus> pedestrianStatusStream;

  pedestrianStatusStream = Pedometer.pedestrianStatusStream;
  pedestrianStatusStream.listen(statusChange).onError((error) {
    if (kDebugMode) {
      print('onPedestrianStatusError: $error');
    }
  });

  stepCountStream = Pedometer.stepCountStream;
  stepCountStream.listen(onStep).onError((error) {
    if (kDebugMode) {
      print('onStepCountError: $error');
    }
  });
}
