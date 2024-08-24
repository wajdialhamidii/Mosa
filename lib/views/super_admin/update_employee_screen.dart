import 'package:consultation_app/utils/sizes.dart';
import 'package:consultation_app/view_models/employee_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../../models/employee.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_util.dart';
import '../../view_models/category_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/drop_down_list.dart';
import '../../widgets/loading_progress_indicator.dart';
import '../../widgets/text_input.dart';

class UpdateEmployeeScreen extends StatefulWidget {
  const UpdateEmployeeScreen({super.key, required this.employee});
  final Employee employee;
  @override
  State<UpdateEmployeeScreen> createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends State<UpdateEmployeeScreen> {
  String? selectedCategoryId;
  bool? isActive;

  final TextEditingController _employeeName = TextEditingController();
  final TextEditingController _employeeEmail = TextEditingController();
  final TextEditingController _employeePassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _employeeName.text = widget.employee.name;
    _employeeEmail.text = widget.employee.email;
    _employeePassword.text = widget.employee.password;
    selectedCategoryId = widget.employee.categoryId.toString();
    isActive = widget.employee.isActive ?? false;
    super.initState();
  }

  @override
  void dispose() {
    _employeeName.dispose();
    _employeeEmail.dispose();
    _employeePassword.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final employeeViewModel = Provider.of<EmployeeViewModel>(context);
    if (categoryViewModel.getCategories.isEmpty &&
        !categoryViewModel.isLoading) {
      categoryViewModel.fetchCategories();
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'Update Employee',
          style: kScreenTitleTextStyle,
        ),
        iconTheme: const IconThemeData(color: kWhiteColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            kSizedBoxHeight_50,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextInput(
                    controller: _employeeName,
                    textCapitalization: TextCapitalization.words,
                    hint: 'Employee name',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  kSizedBoxHeight_15,
                  TextInput(
                    controller: _employeeEmail,
                    hint: 'Employee email',
                    isEmail: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Email address is required';
                      }
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(val)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  kSizedBoxHeight_15,
                  TextInput(
                    controller: _employeePassword,
                    hint: 'Employee password',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Password is required';
                      }
                      if (val.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  kSizedBoxHeight_15,
                  DropDownList(
                      hint: 'Employee status',
                      items: const [
                        DropdownMenuItem(
                          value: 'true',
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: 'false',
                          child: Text('Inactive'),
                        ),
                      ],
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Employee status is required';
                        }
                        return null;
                      },
                      onChange: (val) {
                        isActive = val == 'true';
                      }),
                  kSizedBoxHeight_15,
                  categoryViewModel.isLoading
                      ? const Center(child: LoadingProgressIndicator())
                      : categoryViewModel.getCategories.isEmpty
                          ? const Text('No categories available')
                          : DropDownList(
                              onChange: (val) {
                                selectedCategoryId = val;
                              },
                              hint: 'Category',
                              items: categoryViewModel.getCategories
                                  .map<DropdownMenuItem<String>>(
                                      (Category category) {
                                return DropdownMenuItem<String>(
                                  value: category.id.toString(),
                                  child: Text(category.name),
                                );
                              }).toList(),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Category is required';
                                }
                                return null;
                              },
                            ),
                ],
              ),
            ),
            kSizedBoxHeight_25,
            CustomButton(
              title: 'Save',
              onPressed: () async =>
                  await _editEmployee(context, employeeViewModel),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editEmployee(
      BuildContext context, EmployeeViewModel employeeViewModel) async {
    if (_formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);
      try {
        int categoryId = int.parse(selectedCategoryId!);

        final employee = Employee.updateEmployee(
          id: widget.employee.id!,
          name: _employeeName.text.trim(),
          email: _employeeEmail.text.trim(),
          password: _employeePassword.text.trim(),
          isActive: isActive!,
          categoryId: categoryId,
        );

        await employeeViewModel.updateEmployee(employee, categoryId);

        SnackbarUtil.showSnackbar(
          context,
          'Employee successfully updated',
          kMainColor,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        SnackbarUtil.showSnackbar(
          context,
          'Error occurred while updating employee.',
          kRedColor,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
}
