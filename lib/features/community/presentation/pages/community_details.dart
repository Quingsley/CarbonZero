import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// will show the details of a community
class CommunityDetails extends StatelessWidget {
  /// constructor call
  const CommunityDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 350,
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/solar_energy.png'),
                  ),
                ),
              ),
              // Image.asset(
              //   'assets/images/solar_energy.png',
              //   height: 300,
              //   width: MediaQuery.sizeOf(context).width,
              // ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton.filled(
                  color: context.colors.secondary,
                  iconSize: 12,
                  style: ButtonStyle(
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.zero,
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      context.colors.secondary.withOpacity(.62),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Renewable Energy',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // probable use read more text
                    Text(
                      sampleText,
                      style: context.textTheme.labelSmall,
                    ),
                    // TODO: fix
                    Row(
                      children: List.generate(
                        4,
                        (index) => CircleAvatar(
                          child: index == 3
                              ? const Text('+150')
                              : const Icon(Icons.person),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Chip(
                          avatar: SvgPicture.asset(
                            'assets/images/community-icon.svg',
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              context.colors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          label: const Text('150 members'),
                          side: BorderSide.none,
                        ),
                        const Text('Tags: #solar, #energy'),
                      ],
                    ),
                    PrimaryButton(text: 'Join Community', onPressed: () {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
