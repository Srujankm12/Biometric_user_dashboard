import 'package:application/core/custom_widgets/custom_text_field.dart';
import 'package:application/feature/details/bloc/details_bloc.dart';
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

  @override
  void initState() {
    BlocProvider.of<DetailsBloc>(context).add(
      FetchAllStudentDetailsEvent(unitId: widget.data),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Assume state.students is a list of student objects
              final students = state.data;

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(100),
                            1: FixedColumnWidth(100),
                            2: FixedColumnWidth(100),
                            3: FixedColumnWidth(150),
                            4: FixedColumnWidth(150),
                          },
                          children: [
                            // Header Row
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
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
                            // Data Rows
                            ...students.map((student) {
                              return TableRow(
                                children: [
                                  _buildTableCell(student["student_name"]),
                                  _buildTableCell(student["student_usn"]),
                                  _buildTableCell(student["department"]),
                                  _buildOperationsCell(student),
                                  _buildLogsCell(),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
  }

  Widget _buildTableHeader(String title) {
    return Center(
      child: SizedBox(
        height: 40,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Center(
      child: SizedBox(
        height: 50,
        child: Text(
          text,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildOperationsCell(List<String> student) {
    return Center(
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                // Edit operation
              },
              icon: const Icon(Icons.edit),
            ),
            const SizedBox(width: 5),
            IconButton(
              onPressed: () {
                // Delete operation
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogsCell() {
    return Center(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // View logs operation
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
    );
  }
}
