import 'package:consultation_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/sizes.dart';
import '../../utils/snackbar_util.dart';
import '../../view_models/category_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_progress_indicator.dart';
import '../../widgets/text_input.dart';

class UpdateCategoryScreen extends StatefulWidget {
  const UpdateCategoryScreen({super.key, required this.category});
  final Category category;
  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  final TextEditingController _categoryName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _categoryName.text = widget.category.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'Update Category',
          style: kScreenTitleTextStyle,
        ),
        iconTheme: const IconThemeData(color: kWhiteColor),
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
                title: 'Save',
                onPressed: () async =>
                    await _editCategory(context, categoryViewModel),
              );
            },
          )
        ],
      ),
    );
  }

  Future<void> _editCategory(
      BuildContext context, CategoryViewModel categoryViewModel) async {
    if (_formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);
      try {
        Category category = Category(
          id: widget.category.id,
          name: _categoryName.text.trim(),
        );

        await categoryViewModel.updateCategory(category);

        SnackbarUtil.showSnackbar(
          context,
          'Category successfully updated',
          kMainColor,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        SnackbarUtil.showSnackbar(
          context,
          'Error occurred while updating category.',
          kRedColor,
        );
      }
    }
  }
}
