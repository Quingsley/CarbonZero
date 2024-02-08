import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/presentation/view_models/community_view_model.dart';
import 'package:carbon_zero/services/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// uses the [Autocomplete] widget to search for communities
class CommunitySearch extends ConsumerStatefulWidget {
  /// uses the [Autocomplete] widget to search for communities
  const CommunitySearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunitySearchState();
}

class _CommunitySearchState extends ConsumerState<CommunitySearch> {
  @override
  Widget build(BuildContext context) {
    final searchTerm = ref.watch(searchTermProvider);
    // not good think should be in the data layer
    final debounce = ref.watch(debounceProvider);
    final communities = ref.watch(searchCommunitiesFutureProvider(searchTerm));
    const border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    );
    return Autocomplete<CommunityModel>(
      fieldViewBuilder: (
        context,
        fieldTextEditingController,
        fieldFocusNode,
        onFieldSubmitted,
      ) =>
          TextFormField(
        focusNode: fieldFocusNode,
        controller: fieldTextEditingController,
        decoration: InputDecoration(
          focusedBorder: border,
          enabledBorder: border,
          border: border,
          contentPadding: EdgeInsets.zero,
          hintText: 'Find a community',
          filled: true,
          fillColor: context.colors.primaryContainer.withOpacity(.62),
          prefixIcon: Icon(
            Icons.search,
            color: context.colors.primary,
          ),
        ),
        onChanged: (value) {
          debounce
            ..reset()
            ..call(() {
              ref.read(searchTermProvider.notifier).state = value;
              ref.read(searchCommunitiesFutureProvider(value));
            });
        },
      ),
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<CommunityModel>.empty();
        }
        return communities.when(
          data: (communities) => communities,
          loading: () => const [],
          error: (error, stackTrace) {
            return [];
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          elevation: 4,
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final community = options.elementAt(index);
                return ListTile(
                  title: Text(community.name),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // onSelected(community);
                    context.go('/community/details', extra: community);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// provider for the search term
final searchTermProvider = StateProvider<String>((ref) => '');
