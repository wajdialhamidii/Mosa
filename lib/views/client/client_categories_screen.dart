import 'package:consultation_app/utils/sizes.dart';
import 'package:consultation_app/views/client/client_employees_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../view_models/category_view_model.dart';
import '../../widgets/loading_progress_indicator.dart';

class ClientCategoriesScreen extends StatelessWidget {
  const ClientCategoriesScreen({super.key});

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
      ),
      body: Column(
        children: [
          kSizedBoxHeight_10,
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('What Type of specialist are you looking for?',
                style: kRegularTextStyle),
          ),
          kSizedBoxHeight_5,
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
                                                  ClientEmployeesScreen(
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
