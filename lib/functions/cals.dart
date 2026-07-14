import 'dart:io';

import 'package:expressions/expressions.dart';

String calFnum(String input){
  final expression = Expression.parse(input);
  final evaluator = const ExpressionEvaluator();

  return "F${evaluator.eval(expression, {})}";
}

String calDatatime(String input){
  input=input.replaceFirst(":", "-");
  input=input.replaceFirst(":", "-");
  return input;
}

bool isDesktop(){
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}