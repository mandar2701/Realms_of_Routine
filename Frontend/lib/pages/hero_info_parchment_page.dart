import 'package:flutter/material.dart';
import 'package:life_xp_project/pages/hero_needs_parchment.dart';

/// A screen that displays a parchment-style form for entering hero information.
///
/// This widget uses a Stack to layer a parchment form over a background image,
/// with interactive text fields placed on top.
class HeroInfoParchmentPage extends StatefulWidget {
  /// Creates a [HeroInfoParchmentPage].
  const HeroInfoParchmentPage(
      {super.key,
      required this.email,
      required this.password,
      required this.name});

  final String email;
  final String password;
  final String name;

  @override
  State<HeroInfoParchmentPage> createState() => _HeroInfoParchmentPageState();
}

class _HeroInfoParchmentPageState extends State<HeroInfoParchmentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // The main layout is a Stack to layer the background, parchment, and form.
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Layer 1: The main background image (forest).
            Image.asset(
              "assets/bg_signup.jpg",
              fit: BoxFit.cover,
            ),
            // Layer 2: The parchment image, which serves as the form's background.
            // It's centered to align with the absolutely positioned form fields.
            Center(
              child: Image.asset("assets/info_bg6.jpg"),
            ),
            // Layer 3: The form itself, containing the input fields and button.
            // This is also a Stack with Positioned children, which will be placed
            // relative to the screen, aligning over the centered parchment.
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  /// Builds the form by arranging input fields and buttons in a Stack.
  ///
  /// This method uses `Positioned` widgets to precisely place each form
  /// element according to the design specifications in the background image.
  Widget _buildForm(BuildContext context) {
    // To center the form elements, we get the screen width.
    final screenWidth = MediaQuery.of(context).size.width;
    // These values are estimates based on the image provided.
    // You may need to tweak them for perfect alignment.
    const double formWidth = 280;
    const double buttonWidth = 157;
    final double horizontalPadding = (screenWidth - formWidth) / 2;

    return Stack(
      children: [
        // Name input field - Positioned relative to the screen edges.
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 320,
          child: SizedBox(
            height: 25,
            child: _buildTextField(
                hintText: 'Enter your name', controller: _nameController),
          ),
        ),
        // Age input field - Positioned relative to the screen edges.
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 395,
          child: SizedBox(
            height: 25,
            child: _buildTextField(
                keyboardType: TextInputType.number,
                hintText: 'Enter your age',
                controller: _ageController),
          ),
        ),
        // Birth Date input field - Positioned relative to the screen edges.
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 470,
          child: SizedBox(
            height: 25,
            child: _buildTextField(
                hintText: 'MM/DD/YYYY', controller: _birthDateController),
          ),
        ),
        // Gender input field - Positioned relative to the screen edges.
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 545,
          child: SizedBox(
            height: 25,
            child: _buildTextField(
                hintText: 'Enter your gender', controller: _genderController),
          ),
        ),
        // Defines a tappable area over the "NEXT" button in the background image.
        Positioned(
          left: (screenWidth - buttonWidth) / 2,
          top: 625,
          child: GestureDetector(
            onTap: () {
              if (_nameController.text.isEmpty || _ageController.text.isEmpty || 
                  _birthDateController.text.isEmpty || _genderController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroNeedsParchmentPage(
                    email: widget.email,
                    password: widget.password,
                    name: _nameController.text,
                    age: _ageController.text,
                    birthDate: _birthDateController.text,
                    gender: _genderController.text,
                  ),
                ),
              );
            },
            child: Container(
              width: buttonWidth,
              height: 80,
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/next_button.jpg'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Creates a styled [TextField] for the form.
  ///
  /// [keyboardType] specifies the type of keyboard to display for the input.
  /// Defaults to [TextInputType.text].
  /// [hintText] provides the placeholder text for the field.
  Widget _buildTextField(
      {TextInputType keyboardType = TextInputType.text,
      String hintText = '',
      required TextEditingController controller}) {
    // Defines the text style for user input.
    const textStyle = TextStyle(
      fontFamily: 'Times New Roman',
      color: Color(0xFF6F4E37), // A deep brown, parchment-ink color
      fontSize: 16, // Slightly increased font size for better readability
    );

    // This Align widget ensures that the TextField and its underline are
    // positioned at the bottom of the parent SizedBox.
    return Align(
      alignment: Alignment.bottomCenter,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: textStyle,
        cursorColor: const Color(0xFF6F4E37),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              textStyle.copyWith(color: const Color(0xFF6F4E37).withOpacity(0.6)),
          // isDense and zero contentPadding help in removing extra vertical
          // space, allowing for more precise alignment.
          isDense: true,
          contentPadding: EdgeInsets.zero,
          // Defines the appearance of the underline border.
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8B4513), width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6F4E37), width: 1.5),
          ),
        ),
      ),
    );
  }
}

