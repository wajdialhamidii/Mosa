import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/views/super_admin/add_category_screen.dart';
import 'package:consultation_app/views/super_admin/admin_employees_screen.dart';
import 'package:consultation_app/views/super_admin/update_admin_screen.dart';
import 'package:consultation_app/widgets/loading_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/sizes.dart';
import '../../view_models/category_view_model.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        centerTitle: true,
        title: const Text(
          'Categories',
          style: kScreenTitleTextStyle,
        ),
        iconTheme: const IconThemeData(
          color: kWhiteColor,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateAdminScreen()));
            },
            tooltip: 'Settings',
            icon: CircleAvatar(
              backgroundColor: kGreyShade400Color,
              child: Image.asset(
                'assets/images/avatar.png',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddCategoryScreen()));
        },
        tooltip: 'New Category',
        backgroundColor: kMainColor,
        child: const Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),
      body: Column(
        children: [
          kSizedBoxHeight_15,
          Expanded(
            child: Consumer<CategoryViewModel>(
              builder: (context, categoryViewModel, child) {
                if (categoryViewModel.getCategories.isEmpty &&
                    !categoryViewModel.isLoading) {
                  categoryViewModel.fetchCategories();
                }

                return RefreshIndicator(
                  color: kMainColor,
                  backgroundColor: kBackgroundColor,
                  onRefresh: () async {
                    await categoryViewModel.fetchCategories();
                  },
                  child: categoryViewModel.isLoading
                      ? const Center(child: LoadingProgressIndicator())
                      : categoryViewModel.getCategories.isEmpty
                          ? const Center(
                              child: Text(
                                'No categories yet',
                                style: kGreyedOutTextStyle,
                              ),
                            )
                          : ListView.builder(
                              itemCount: categoryViewModel.getCategories.length,
                              itemBuilder: (context, index) {
                                final category =
                                    categoryViewModel.getCategories[index];

                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminEmployeesScreen(
                                                    category: category,
                                                  )));
                                    },
                                    title: Text(category.name),
                                  ),
                                );
                              },
                            ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
