import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // For Form validation
  final AutovalidateMode autovalidateMode; // Optional: control when to validate

  const CustomInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.autovalidateMode =
        AutovalidateMode.onUserInteraction, // Real-time validation
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // TextFormField with validation and error display
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          autovalidateMode: widget.autovalidateMode,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color(0xFF666666)),
            filled: true,
            fillColor: Colors.transparent,
            isDense: true,

            // 🔥 Real horizontal padding 0 → error text o flush (no indent)
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 18,
            ),

            // 🔥 Fake padding for input text + hint only (tmr old design)
            prefix: const SizedBox(width: 10), // left gap
            suffix: const SizedBox(width: 17), // right gap (optional)
            // Password icon ke right-e perfect rakhar jonno
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF888888),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : const SizedBox(width: 17), // no icon holeo right gap thakbe
            // Borders (tmr existing)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromRGBO(145, 145, 145, 1),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF333333), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF555555),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),

            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 13,
              height: 1.2,
            ),
            counterText: "",
          ),
        ),

        // This SizedBox ensures consistent spacing even when no error
        const SizedBox(height: 6),
      ],
    );
  }
}
