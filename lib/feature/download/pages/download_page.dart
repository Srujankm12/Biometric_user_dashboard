import 'package:application/core/custom_widgets/custom_date_text_field.dart';
import 'package:application/core/custom_widgets/custom_dropdown.dart';
import 'package:application/core/themes/colors.dart';
import 'package:application/feature/download/bloc/download_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _unitIdController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<DownloadBloc>(context).add(
      FetchBiometricUnitsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          "Download Attendance",
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.only(top: 2),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 400,
            height: 400,
            child: Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: BlocBuilder<DownloadBloc, DownloadState>(
                  builder: (context, state) {
                    if (state is FetchBiometricUnitsSuccessState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 80,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomDatePicker(
                            controller: _startDateController,
                            hintText: "Start Date",
                            prefixIcon: Icons.date_range,
                            onTap: () {
                              _selectDate(_startDateController);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomDatePicker(
                            controller: _endDateController,
                            hintText: "End Date",
                            prefixIcon: Icons.date_range,
                            onTap: () {
                              _selectDate(_endDateController);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomDropDownMenu(
                            data: state.data,
                            onChanged: (p0) {
                              _unitIdController.text = p0!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<DownloadBloc>(context).add(
                                  DownloadExcelEvent(
                                    startDate: _startDateController.text,
                                    endDate: _endDateController.text,
                                    unitId: _unitIdController.text,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Download",
                                style: GoogleFonts.nunito(
                                  color: AppColors.whiteColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is FetchBiometricUnitsFailedState) {
                      return Column(
                        children: [
                          const Icon(Icons.file_download_off_outlined),
                          Text(
                            state.message,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeCap: StrokeCap.round,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    setState(() {
      controller.text = picked.toString().split(" ")[0];
    });
  }
}
