import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/core/widgets/text_field.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/presentation/view_models/community_view_model.dart';
import 'package:carbon_zero/services/image_upload.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

/// screen used ot add a community
class AddCommunity extends ConsumerStatefulWidget {
  /// constructor call
  const AddCommunity({super.key, this.community});

  /// will be optional if present means editing
  final CommunityModel? community;

  @override
  ConsumerState<AddCommunity> createState() => _AddCommunityState();
}

class _AddCommunityState extends ConsumerState<AddCommunity> {
  final _formKey = GlobalKey<FormState>();
  final communityNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  List<String?> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    if (widget.community != null) {
      communityNameController.text = widget.community!.name;
      descriptionController.text = widget.community!.description;
      imageController.text = widget.community!.posterId;
      _selectedTags = widget.community!.tags;
    }
  }

  @override
  void dispose() {
    communityNameController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();

      final user = ref.read(userStreamProvider).value;
      final community = CommunityModel(
        name: communityNameController.text,
        description: descriptionController.text,
        posterId: imageController.text,
        tags: List.from(_selectedTags),
        adminId: user!.userId!,
      );

      if (widget.community == null) {
        await ref
            .read(communityViewModelProvider.notifier)
            .createCommunity(community);
      } else {
        final updatedCommunity = widget.community!.copyWith(
          name: communityNameController.text,
          description: descriptionController.text,
          posterId: imageController.text,
          tags: List.from(_selectedTags),
        );
        await ref
            .read(communityViewModelProvider.notifier)
            .updateCommunity(updatedCommunity);
      }

      communityNameController.clear();
      descriptionController.clear();
      imageController.clear();
      setState(() {
        _selectedTags = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageService = ref.watch(imageServiceProvider);
    final isLoading = imageService is AsyncLoading;
    final communityViewModel = ref.watch(communityViewModelProvider);
    final isDarkMode = ref.watch(isDarkModeStateProvider);
    final isAdding = communityViewModel is AsyncLoading;
    ref
      ..listen(communityViewModelProvider, (prev, next) {
        next.whenOrNull(
          data: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Community ${widget.community != null ? "edited" : "added"} successfully',
                ),
              ),
            );
            ref.invalidate(getCommunitiesStreamProvider);
            context.pop();
          },
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(error is Failure ? error.message : error.toString()),
              ),
            );
          },
        );
      })
      ..listen(imageServiceProvider, (previous, next) {
        next.whenOrNull(
          data: (data) {
            if (data != null) {
              setState(() {
                imageController.text = data;
              });
            }
          },
        );
      });
    return PopScope(
      onPopInvoked: (_) {
        ref
          ..invalidate(getCommunitiesStreamProvider)
          ..invalidate(adminCommunityFutureProvider);
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(' ${widget.community != null ? "Edit" : "Add a"} community'),
          centerTitle: true,
        ),
        body: FormLayout(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                KTextField(
                  controller: communityNameController,
                  label: 'Name',
                  hintText: 'Community Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please provide a valid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                KTextField(
                  label: 'Description',
                  controller: descriptionController,
                  hintText: 'Description of the community',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please provide a valid description';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    // color: context.colors.primary,
                    gradient: LinearGradient(
                      colors: [
                        context.colors.primary.withOpacity(0.62),
                        context.colors.primary.withOpacity(0.31),
                      ],
                    ),
                    image: imageController.text.isNotEmpty
                        ? DecorationImage(
                            image: FirebaseImageProvider(
                              FirebaseUrl(imageController.text),
                            ),
                            fit: BoxFit.cover,
                            opacity: .5,
                          )
                        : null,
                    border: Border.all(color: context.colors.primary),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else
                        IconButton(
                          color: context.colors.onPrimary,
                          onPressed: !isLoading
                              ? () async {
                                  await ref
                                      .read(imageServiceProvider.notifier)
                                      .uploadPhoto(ImageType.community);
                                }
                              : null,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      Text(
                        'Add a poster for your community',
                        style: TextStyle(
                          color: context.colors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MultiSelectChipField<String?>(
                  title: const Text('Tags'),
                  chipColor: isDarkMode
                      ? context.colors.secondary.withOpacity(.4)
                      : null,
                  items:
                      hashtags.map((tag) => MultiSelectItem(tag, tag)).toList(),
                  icon: const Icon(Icons.check),
                  onTap: (values) {
                    setState(() {
                      _selectedTags = [...values];
                    });
                  },
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return 'please select at least one tag';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                PrimaryButton(
                  text:
                      '${widget.community != null ? "Edit" : "Add"}  Community',
                  isLoading: isAdding,
                  onPressed: !isAdding ? submit : null,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// manages is loading state
final isLoadingStateProvider = StateProvider<bool>((ref) {
  return false;
});
