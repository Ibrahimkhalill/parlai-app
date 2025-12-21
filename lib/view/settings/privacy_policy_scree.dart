import 'package:flutter/material.dart';
import 'package:parlai/wdiget/glass_back_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 0,
                ),
                child: Row(
                  children: [
                    GlassBackButton(),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Privacy & Policy',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1
                    PolicySection(
                      number: '1',
                      title: 'How They Use and Share Your Data',
                      content: [
                        'odio vel orci odio dui tincidunt venenatis non. at ex dui diam odio eu risus est. elit odio Nunc gravida eget in faucibus varius ipssum malesuada Ut Sed non.',
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Section 2
                    PolicySection(
                      number: '2',
                      title: 'How They Use and Share Your Data',
                      content: [
                        'massa sodales. Praesent vehicula, lacus vitae sodales. non id vel tempor sed elementum sit adipiscing vehicula, adipiscing eu vitae amet, odio lobortis, nec',
                        'dui elit. luctus ex maximus nec non gravida fringilla lacus eu sodales. eget orci turpis ex dui. dolor placerat faucibus lorem. nisl placerat sed amet, odio',
                      ],
                    ),
                    const SizedBox(height: 28),
                    // Section 3
                    PolicySection(
                      number: '3',
                      title: 'Data Retention & Security',
                      content: [
                        'massa sodales. Praesent vehicula, lacus vitae sodales. non id vel tempor sed elementum sit adipiscing vehicula, adipiscing eu vitae amet, odio lobortis, nec',
                        'dui elit. luctus ex maximus nec non gravida fringilla lacus eu sodales. eget orci turpis ex dui. dolor placerat faucibus lorem. nisl placerat sed amet, odio',
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PolicySection extends StatelessWidget {
  final String number;
  final String title;
  final List<String> content;

  const PolicySection({
    Key? key,
    required this.number,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with number
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$number. ',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Content bullets
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            content.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 12),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      content[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
