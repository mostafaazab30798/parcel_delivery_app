import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SaudiLicensePlate extends StatefulWidget {
  final Function(String numbers, String letters) onChanged;
  final String? initialNumbers;
  final String? initialLetters;
  final bool isEditable;

  const SaudiLicensePlate({
    super.key,
    required this.onChanged,
    this.initialNumbers,
    this.initialLetters,
    this.isEditable = true,
  });

  @override
  State<SaudiLicensePlate> createState() => _SaudiLicensePlateState();
}

class _SaudiLicensePlateState extends State<SaudiLicensePlate> {
  late TextEditingController _numbersController;
  late List<TextEditingController> _letterControllers;
  final FocusNode _numbersFocus = FocusNode();
  final List<FocusNode> _letterFocusNodes =
      List.generate(3, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _numbersController =
        TextEditingController(text: widget.initialNumbers ?? '');

    // Initialize three controllers for letters
    _letterControllers = List.generate(3, (index) {
      String initialLetter = '';
      if (widget.initialLetters != null &&
          widget.initialLetters!.length > index) {
        initialLetter = widget.initialLetters![index];
      }
      return TextEditingController(text: initialLetter);
    });
  }

  @override
  void dispose() {
    _numbersController.dispose();
    for (var controller in _letterControllers) {
      controller.dispose();
    }
    _numbersFocus.dispose();
    for (var node in _letterFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _updateParent() {
    final letters = _letterControllers.map((c) => c.text).join();
    widget.onChanged(_numbersController.text, letters);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    // Calculate responsive sizes
    final plateWidth = screenSize.width * (isSmallScreen ? 0.5 : 0.4);
    final plateHeight = plateWidth * 0.25;
    final fontSize = plateHeight * 0.4;
    final logoSize = plateHeight * 0.5;
    final ksaFontSize = plateHeight * 0.25;
    final borderWidth = plateHeight * 0.04;
    final padding = plateHeight * 0.1;

    return Container(
      width: plateWidth,
      height: plateHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(plateHeight * 0.16),
        border: Border.all(color: Colors.black, width: borderWidth),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Numbers section
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.black, width: borderWidth),
                ),
              ),
              child: Center(
                child: TextFormField(
                  controller: _numbersController,
                  focusNode: _numbersFocus,
                  enabled: widget.isEditable,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: padding),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    _updateParent();
                    if (value.length == 4) {
                      _letterFocusNodes[0].requestFocus();
                    }
                  },
                ),
              ),
            ),
          ),
          // KSA Logo section
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.black, width: borderWidth),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ksa_logo.png',
                      height: logoSize * 0.8,
                    ),
                    Text(
                      'KSA',
                      style: TextStyle(
                        fontSize: ksaFontSize * 0.8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Letters section
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: index < 2
                          ? Border(
                              right: BorderSide(
                                  color: Colors.black,
                                  width: borderWidth * 0.5),
                            )
                          : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: padding * 0.15),
                      child: Center(
                        child: TextFormField(
                          controller: _letterControllers[index],
                          focusNode: _letterFocusNodes[index],
                          enabled: widget.isEditable,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: fontSize * 0.8,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: padding * 0.8),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[أ-يa-zA-Z]')),
                          ],
                          onChanged: (value) {
                            _updateParent();
                            if (value.isNotEmpty && index < 2) {
                              _letterFocusNodes[index + 1].requestFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
