import 'package:consultation_app/models/category.dart';
import 'package:consultation_app/utils/sizes.dart';
import 'package:consultation_app/utils/snackbar_util.dart';
import 'package:consultation_app/view_models/category_view_model.dart';
import 'package:consultation_app/widgets/custom_button.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:consultation_app/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _categoryName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _categoryName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'New Category',
          style: kScreenTitleTextStyle,
        ),
        iconTheme: const IconThemeData(
          color: kWhiteColor,
        ),
      ),
      body: Column(
        children: [
          kSizedBoxHeight_60,
          Form(
            key: _formKey,
            child: TextInput(
              controller: _categoryName,
              textCapitalization: TextCapitalization.words,
              hint: 'Category name ',
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Category name is required';
                }
                return null;
              },
            ),
          ),
          kSizedBoxHeight_15,
          Consumer<CategoryViewModel>(
            builder: (context, categoryViewModel, child) {
              return CustomButton(
                title: 'Add',
                onPressed: () async =>
                    await _addCategory(context, categoryViewModel),
              );
            },
          )
        ],
      ),
    );
  }

  Future<void> _addCategory(
      BuildContext context, CategoryViewModel categoryViewModel) async {
    if (_formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);
      try {
        Category category = Category(name: _categoryName.text.trim());
        await categoryViewModel.addCategory(category);

        SnackbarUtil.showSnackbar(
          context,
          'New category successfully added',
          kMainColor,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        SnackbarUtil.showSnackbar(
          context,
          'Error occurred while adding category.',
          kRedColor,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
}
