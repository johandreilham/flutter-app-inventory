import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/data/source/source_user.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  add() async {
    if (formKey.currentState!.validate()) {
      bool? yes = await DInfo.dialogConfirmation(
          context, 'Add Employee', 'Yes yo confirm');
      if (yes!) {
        bool success = await SourceUser.add(
          controllerName.text,
          controllerEmail.text,
          controllerPassword.text,
        );
        if (success) {
          DInfo.dialogSuccess(context, 'Success Add Employee');
          DInfo.closeDialog(context,
              actionAfterClose: () => Get.back(result: true));
        } else {
          DInfo.dialogError(context, 'Failed Add Employee');
          DInfo.closeDialog(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
        titleSpacing: 0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DInput(
              title: 'Name',
              controller: controllerName,
              validator: (value) => value == '' ? "Don't Empty" : null,
            ),
            DView.spaceHeight(),
            DInput(
              title: 'Email',
              controller: controllerEmail,
              validator: (value) => value == '' ? "Don't Empty" : null,
            ),
            DView.spaceHeight(),
            DInput(
              title: 'Password',
              controller: controllerPassword,
              validator: (value) => value == '' ? "Don't Empty" : null,
            ),
            DView.spaceHeight(32),
            ElevatedButton(
              onPressed: () => add(),
              child: const Text('Add'),
            )
          ],
        ),
      ),
    );
  }
}
