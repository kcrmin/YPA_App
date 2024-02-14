import 'package:flutter/material.dart';

import '../component/goal_form.dart';

void showGoalDialog(context, selectedGoalId) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: GoalForm(selectedGoalId: selectedGoalId,),
      );
    },
  );
}
