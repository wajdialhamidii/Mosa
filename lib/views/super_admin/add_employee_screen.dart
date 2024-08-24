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

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _employeeName = TextEditingController();
  final TextEditingController _employeeEmail = TextEditingController();
  final TextEditingController _employeePassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _employeeName.dispose();
    _employeeEmail.dispose();
    _employeePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? selectedCategoryId;
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
          'New Employee',
          style: kScreenTitleTextStyle,
        ),
        iconTheme: const IconThemeData(
          color: kWhiteColor,
        ),
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
              title: 'Add',
              onPressed: () async => await _addEmployee(
                  context, selectedCategoryId, employeeViewModel),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addEmployee(BuildContext context, String? selectedCategoryId,
      EmployeeViewModel employeeViewModel) async {
    if (_formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);
      try {
        int categoryId = int.parse(selectedCategoryId!);

        final employee = Employee.createEmployee(
          name: _employeeName.text.trim(),
          email: _employeeEmail.text.trim(),
          password: _employeePassword.text.trim(),
          categoryId: categoryId,
        );

        await employeeViewModel.addEmployee(employee, categoryId);

        SnackbarUtil.showSnackbar(
          context,
          'New employee successfully added',
          kMainColor,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        SnackbarUtil.showSnackbar(
          context,
          'Error occurred while adding employee',
          kRedColor,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
}
