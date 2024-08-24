import 'package:consultation_app/models/consultation.dart';
import 'package:consultation_app/view_models/consultation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/sizes.dart';
import '../../utils/snackbar_util.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_progress_indicator.dart';
import '../../widgets/text_input.dart';

class AddConsultationScreen extends StatefulWidget {
  final int employeeId;

  const AddConsultationScreen({super.key, required this.employeeId});

  @override
  State<AddConsultationScreen> createState() => _AddConsultationScreenState();
}

class _AddConsultationScreenState extends State<AddConsultationScreen> {
  final TextEditingController _consultationNameController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _consultationNameController.dispose();
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
          'New Consultation',
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
              controller: _consultationNameController,
              hint: 'Consultation title',
              textCapitalization: TextCapitalization.words,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Consultation title is required';
                }
                return null;
              },
            ),
          ),
          kSizedBoxHeight_15,
          Consumer<ConsultationViewModel>(
            builder: (context, consultationViewModel, child) {
              return CustomButton(
                title: 'Start',
                onPressed: () =>
                    _addConsultation(context, consultationViewModel),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addConsultation(
      BuildContext context, ConsultationViewModel consultationViewModel) async {
    if (_formKey.currentState!.validate()) {
      LoadingProgressIndicator.showProgressIndicator(context);
      try {
        int? clientId = await AuthService().getUserId();

        if (clientId == null) {
          throw Exception('Client ID not found');
        }

        Consultation consultation = Consultation.create(
          startTime: DateTime.now(),
          title: _consultationNameController.text.trim(),
          clientId: clientId,
          employeeId: widget.employeeId,
        );

        await consultationViewModel.addConsultation(consultation);

        SnackbarUtil.showSnackbar(
          context,
          'New consultation started',
          kMainColor,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        Navigator.pop(context);
        SnackbarUtil.showSnackbar(
          context,
          'Error occurred while starting consultation.',
          kRedColor,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
}
