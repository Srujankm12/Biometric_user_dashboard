import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMachineCard extends StatelessWidget {
  final String machineID;
  final bool status;
  final VoidCallback onPressed;
  const CustomMachineCard(
      {super.key,
      required this.machineID,
      required this.status,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                machineID,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.fingerprint,
                size: 80,
              ),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: status
                      ? const Color.fromARGB(69, 0, 255, 8)
                      : const Color.fromARGB(69, 255, 17, 0),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      20,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: status ? Colors.green : Colors.red,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      status ? "Online" : "Offline",
                      style: TextStyle(
                          color: status ? Colors.green : Colors.red,
                          fontSize: 10),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  "Manage",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
