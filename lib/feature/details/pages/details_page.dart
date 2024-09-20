import 'package:application/core/custom_widgets/custom_text_field.dart';
import 'package:application/feature/details/bloc/details_bloc.dart';
import 'package:application/feature/details/widgets/delete_dialog.dart';
import 'package:application/feature/details/widgets/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDetails extends StatefulWidget {
  final String data;
  const StudentDetails({super.key, required this.data});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController usnController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<DetailsBloc>(context).add(
      FetchAllStudentDetailsEvent(unitId: widget.data),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailsBloc, DetailsState>(
      listener: (context, state) {
        if (state is DeleteStudentFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
          BlocProvider.of<DetailsBloc>(context).add(
            FetchAllStudentDetailsEvent(unitId: widget.data),
          );
        }
        if (state is DeleteStudentSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          BlocProvider.of<DetailsBloc>(context).add(
            FetchAllStudentDetailsEvent(unitId: widget.data),
          );
        }
        if (state is DeleteLoadingState) {
          Navigator.pop(context);
        }
        if (state is UpdateStudentFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
          BlocProvider.of<DetailsBloc>(context).add(
            FetchAllStudentDetailsEvent(unitId: widget.data),
          );
        }
        if (state is UpdateStudentSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          BlocProvider.of<DetailsBloc>(context).add(
            FetchAllStudentDetailsEvent(unitId: widget.data),
          );
        }
        if (state is UpdateLoadingState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text(
            "Student Details",
            style: GoogleFonts.nunito(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
          child: BlocBuilder<DetailsBloc, DetailsState>(
            builder: (context, state) {
              if (state is FetchAllStudentSuccessState) {
                final students = state.data;
                final query = searchController.text.toLowerCase();

                // Filter students based on the search query
                final filteredStudents = students.where((student) {
                  final name = student["student_name"].toLowerCase();
                  return name.contains(query);
                }).toList();

                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.data,
                                  style: GoogleFonts.nunito(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "The Student details present in ${widget.data}",
                                  style: GoogleFonts.nunito(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            child: CustomTextField(
                              prefixIcon: Icons.search,
                              hintText: "Search by Name",
                              isObscure: false,
                              controller: searchController,
                              isPasswordField: false,
                              onChanged: (value) {
                                setState(
                                    () {}); // Trigger rebuild on text change
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTableHeaderRow(),
                            Column(
                              children: [
                                for (var student in filteredStudents)
                                  _buildDataRow(student),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (state is FetchAllStudentFailureState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 100,
                      ),
                      Text(
                        state.message,
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<DetailsBloc>(context).add(
                            FetchAllStudentDetailsEvent(unitId: widget.data),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: Text(
                          "Retry",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeaderRow() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FixedColumnWidth(100),
          2: FixedColumnWidth(100),
          3: FixedColumnWidth(150),
          4: FixedColumnWidth(150),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              _buildTableHeader('Name'),
              _buildTableHeader('USN'),
              _buildTableHeader('Branch'),
              _buildTableHeader('Operations'),
              _buildTableHeader('Logs'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> student) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 5), // Even gap between rows
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FixedColumnWidth(100),
          2: FixedColumnWidth(100),
          3: FixedColumnWidth(150),
          4: FixedColumnWidth(150),
        },
        children: [
          TableRow(
            children: [
              _buildTableCell(student["student_name"]),
              _buildTableCell(student["student_usn"]),
              _buildTableCell(student["department"]),
              _buildOperationsCell(
                student["student_id"],
                student["student_unit_id"],
                student["student_name"],
                student["student_usn"],
                student["department"],
              ),
              _buildLogsCell(student["student_id"] , student['student_name'] , student['student_usn']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Center(
      child: SizedBox(
        height: 40,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Center(
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOperationsCell(String studentId, String studentUnitId,
      String name, String usn, String branch) {
    return Center(
      child: SizedBox(
        height: 50,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  usernameController.text = name;
                  usnController.text = usn;
                  branchController.text = branch;
                  CustomUpdateDialog.showCustomDialog(
                    context,
                    () {
                      BlocProvider.of<DetailsBloc>(context).add(
                        UpdateStudentEvent(
                          branch: branchController.text,
                          name: usernameController.text,
                          usn: usnController.text,
                          unit: widget.data,
                          studentID: studentId,
                        ),
                      );
                    },
                    usernameController,
                    usnController,
                    branchController,
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              const SizedBox(width: 5),
              IconButton(
                onPressed: () {
                  CustomDeleteDialog.showCustomDialog(context, () {
                    BlocProvider.of<DetailsBloc>(context).add(
                      DeleteStudentEvent(
                        studentId: studentId,
                        studentUnitId: studentUnitId,
                        unitId: widget.data,
                      ),
                    );
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogsCell(
      String studentId, String studentName, String studentUsn) {
    return Center(
      child: SizedBox(
        height: 42,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/logs",
                arguments: LogsArguments(
                  studentId: studentId,
                  studentName: studentName,
                  studentUsn: studentUsn,
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
              "View Logs",
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogsArguments {
  final String studentId;
  final String studentName;
  final String studentUsn;
  LogsArguments(
      {required this.studentId,
      required this.studentName,
      required this.studentUsn});
}
