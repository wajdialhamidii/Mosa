import 'package:consultation_app/models/category.dart';
import 'package:consultation_app/views/super_admin/add_employee_screen.dart';
import 'package:consultation_app/views/super_admin/admin_employee_consultations_screen.dart';
import 'package:consultation_app/views/super_admin/update_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../view_models/employee_view_model.dart';
import '../../widgets/user_card.dart';
import '../../widgets/loading_progress_indicator.dart';

class AdminEmployeesScreen extends StatefulWidget {
  const AdminEmployeesScreen({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  State<AdminEmployeesScreen> createState() => _AdminEmployeesScreenState();
}

class _AdminEmployeesScreenState extends State<AdminEmployeesScreen> {
  late final EmployeeViewModel _employeeViewModel;

  @override
  void initState() {
    super.initState();
    _employeeViewModel = Provider.of<EmployeeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _employeeViewModel.fetchEmployees(widget.category.id!);
    });
  }

  Future<List<double>> _fetchRatings() async {
    final employees = _employeeViewModel.getEmployees;
    return Future.wait(employees
        .map((e) => _employeeViewModel.getEmployeeRating(e.id!))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        centerTitle: true,
        title: Text(
          widget.category.name,
          style: kScreenTitleTextStyle,
        ),
        iconTheme: const IconThemeData(color: kWhiteColor),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UpdateCategoryScreen(category: widget.category)));
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 25.0,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddEmployeeScreen()));
        },
        tooltip: 'New Employee',
        backgroundColor: kMainColor,
        child: const Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),
      body: Consumer<EmployeeViewModel>(
        builder: (context, employeeViewModel, child) {
          return RefreshIndicator(
            color: kMainColor,
            backgroundColor: kBackgroundColor,
            onRefresh: () async {
              await employeeViewModel.fetchEmployees(widget.category.id!);
            },
            child: employeeViewModel.isLoading
                ? const Center(child: LoadingProgressIndicator())
                : employeeViewModel.getEmployees.isEmpty
                    ? const Center(
                        child: Text(
                          'No employees yet',
                          style: kGreyedOutTextStyle,
                        ),
                      )
                    : FutureBuilder<List<double>>(
                        future: _fetchRatings(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: LoadingProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text(
                              'Error fetching ratings',
                              style: kGreyedOutTextStyle,
                            ));
                          } else {
                            final ratings = snapshot.data ?? [];
                            return ListView.builder(
                              itemCount: employeeViewModel.getEmployees.length,
                              itemBuilder: (context, index) {
                                final employee =
                                    employeeViewModel.getEmployees[index];
                                final rating = ratings[index];
                                return UserCard(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdminEmployeeConsultationsScreen(
                                                    employee: employee)));
                                  },
                                  title: employee.name,
                                  imageUrl: 'assets/images/avatar.png',
                                  tagColor: employee.isActive!
                                      ? kLightBlueColor
                                      : kLightRedColor,
                                  tagText: employee.isActive!
                                      ? 'Active'
                                      : 'Inactive',
                                  subtitle: RatingBarIndicator(
                                    rating: rating == 0
                                        ? 1
                                        : rating.roundToDouble(),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star_rate_rounded,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
          );
        },
      ),
    );
  }
}
