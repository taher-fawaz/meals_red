import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/themes/app_color.dart';
import '../../../../core/themes/app_font.dart';
import '../../../../routes/app_route_path.dart';
import '../../../../widgets/button_widget.dart';
import '../../../../widgets/info_input_field.dart';
import '../../../../widgets/leading_back_button_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../bloc/user_info/user_info_bloc.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'male';
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load previously saved user info if available
    BlocProvider.of<UserInfoBloc>(context).add(LoadUserInfoEvent());
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your details', style: AppFont.subtitle),
        leading: const LeadingBackButtonWidget(),
        elevation: 0,
      ),
      body: BlocConsumer<UserInfoBloc, UserInfoState>(
        listener: (context, state) {
          if (state is UserInfoLoaded) {
            // Navigate to order page when calculation is done
            context.pushNamed(
              AppRoute.placeOrder.name,
              extra: {
                'tdee': state.userInfo.dailyCaloriesNeeded,
                'name': 'User',
              },
            );
          } else if (state is UserInfoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          // Pre-fill form if data is available
          if (state is UserInfoLoaded) {
            _selectedGender = state.userInfo.gender;
            _weightController.text = state.userInfo.weight.toString();
            _heightController.text = state.userInfo.height.toString();
            _ageController.text = state.userInfo.age.toString();
          }

          if (state is UserInfoLoading) {
            return const LoadingWidget(
                message: 'Calculating your calorie needs...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gender Selection
                  Text(
                    'Gender',
                    style: AppFont.subtitle,
                  ),
                  const SizedBox(height: 12),
                  _buildGenderSelector(),
                  const SizedBox(height: 24),

                  // Weight Input
                  InfoInputField(
                    label: 'Weight',
                    hint: 'Enter your weight',
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    suffix: 'Kg',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Height Input
                  InfoInputField(
                    label: 'Height',
                    hint: 'Enter your height',
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    suffix: 'Cm',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your height';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Age Input
                  InfoInputField(
                    label: 'Age',
                    hint: 'Enter your age in years',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Next Button
                  AppButtonWidget(
                    label: 'Next',
                    callback: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<UserInfoBloc>(context).add(
                          CalculateCaloriesEvent(
                            gender: _selectedGender,
                            weight: double.parse(_weightController.text),
                            height: double.parse(_heightController.text),
                            age: int.parse(_ageController.text),
                          ),
                        );
                      }
                    },
                    paddingVertical: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Male Option
          _buildGenderOption(
            'Male',
            isSelected: _selectedGender == 'male',
            onTap: () {
              setState(() {
                _selectedGender = 'male';
              });
            },
          ),

          // Divider
          Container(
            height: 1,
            color: AppColor.divider,
          ),

          // Female Option
          _buildGenderOption(
            'Female',
            isSelected: _selectedGender == 'female',
            onTap: () {
              setState(() {
                _selectedGender = 'female';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String label,
      {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppFont.body,
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppColor.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
