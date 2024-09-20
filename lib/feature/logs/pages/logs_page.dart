import 'package:application/core/custom_widgets/custom_text_field.dart';
import 'package:application/feature/details/bloc/details_bloc.dart';
import 'package:application/feature/logs/bloc/logs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LogsPage extends StatefulWidget {
  final String data;
  final String studentName;
  final String usn;
  const LogsPage({super.key, required this.data, required this.studentName, required this.usn});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<LogsBloc>(context).add(
      FetchStudentLogs(studentID: widget.data),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          "Student Logs",
          style: GoogleFonts.nunito(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade900,
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
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
        child: BlocBuilder<LogsBloc, LogsState>(
          builder: (context, state) {
            if (state is FetchStudentLogsSuccessState) {
              final students = state.data;
              final dateQuery = dateController.text.toLowerCase();

              // Filter logs based on search queries
              final filteredLogs = students.where((log) {
                final date = log["date"].toLowerCase();
                return date.contains(dateQuery);
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
                                widget.studentName,
                                style: GoogleFonts.nunito(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "The Student Logs of ${widget.usn}",
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
                            hintText: "Search by Date",
                            isObscure: false,
                            controller: dateController,
                            isPasswordField: false,
                            onChanged: (value) {
                              setState(() {}); // Trigger rebuild on text change
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
                              for (var log in filteredLogs) _buildDataRow(log),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is FetchStudentLogsFailedState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 100,
                    ),
                    Text(
                      state.error,
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

  Widget _buildTableHeaderRow() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FixedColumnWidth(150),
          2: FixedColumnWidth(150),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              _buildTableHeader('Date'),
              _buildTableHeader('Login'),
              _buildTableHeader('Logout'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> log) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FixedColumnWidth(150),
          2: FixedColumnWidth(150),
        },
        children: [
          TableRow(
            children: [
              _buildTableCell(log["date"]),
              _buildTableCell(log["login"]),
              _buildTableCell(log["logout"]),
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
}

