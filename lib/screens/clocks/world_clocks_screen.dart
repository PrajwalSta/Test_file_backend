import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/timezone_database.dart';
import '../../l10n/app_localizations.dart';
import '../../models/world_clock.dart';
import '../../services/world_clock_service.dart';
import '../widgets/clocks/world_clock_card.dart';

class WorldClocksScreen extends StatefulWidget {
  final bool showBottomNavigationBar;

  const WorldClocksScreen({
    super.key,
    this.showBottomNavigationBar = true,
  });

  @override
  State<WorldClocksScreen> createState() =>
      _WorldClocksScreenState();
}

class _WorldClocksScreenState
    extends State<WorldClocksScreen> {
  final WorldClockService _worldClockService =
      WorldClockService();

  final TextEditingController _searchController =
      TextEditingController();

  List<WorldClock> savedClocks = [];

  bool isLoading = true;
  bool isAddingClock = false;

  String? deletingClockId;

  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();

    _loadWorldClocks();

    _clockTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  Future<void> _loadWorldClocks() async {
    try {
      final List<WorldClock> result =
          await _worldClockService
              .getWorldClocks();

      if (!mounted) {
        return;
      }

      setState(() {
        savedClocks = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${localizations.unableToLoadWorldClocks}: '
              '$error',
            ),
          ),
        );
    }
  }

  Future<void> _openAddClockSheet() async {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    _searchController.clear();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (
        BuildContext sheetContext,
      ) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter setSheetState,
          ) {
            final String searchText =
                _searchController.text
                    .trim()
                    .toLowerCase();

            final List<WorldClock>
                filteredClocks =
                timezoneDatabase.where(
              (WorldClock clock) {
                if (searchText.isEmpty) {
                  return true;
                }

                final String city =
                    clock.city.toLowerCase();

                final String country =
                    clock.country.toLowerCase();

                final String timezone =
                    clock.timezoneName
                        .toLowerCase();

                return city.contains(
                      searchText,
                    ) ||
                    country.contains(
                      searchText,
                    ) ||
                    timezone.contains(
                      searchText,
                    );
              },
            ).toList();

            return SafeArea(
              child: SizedBox(
                height:
                    MediaQuery.sizeOf(
                          context,
                        ).height *
                        0.78,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),

                    Container(
                      width: 44,
                      height: 5,
                      decoration:
                          BoxDecoration(
                        color:
                            theme.dividerColor,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets
                              .fromLTRB(
                        20,
                        18,
                        12,
                        10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .add_location_alt_outlined,
                            color:
                                colorScheme
                                    .primary,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Text(
                              localizations
                                  .addWorldClock,
                              style: TextStyle(
                                color:
                                    colorScheme
                                        .onSurface,
                                fontSize: 21,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),

                          IconButton(
                            tooltip:
                                localizations
                                    .close,
                            onPressed: () {
                              Navigator.pop(
                                sheetContext,
                              );
                            },
                            icon:
                                const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 16,
                      ),
                      child: TextField(
                        controller:
                            _searchController,
                        autofocus: true,
                        textInputAction:
                            TextInputAction
                                .search,
                        onChanged: (
                          String value,
                        ) {
                          setSheetState(
                            () {},
                          );
                        },
                        decoration:
                            InputDecoration(
                          hintText:
                              localizations
                                  .searchCityCountryTimezone,
                          prefixIcon:
                              const Icon(
                            Icons.search,
                          ),
                          suffixIcon:
                              searchText.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip:
                                          localizations
                                              .clearSearch,
                                      onPressed:
                                          () {
                                        _searchController
                                            .clear();

                                        setSheetState(
                                          () {},
                                        );
                                      },
                                      icon:
                                          const Icon(
                                        Icons
                                            .clear,
                                      ),
                                    ),
                          filled: true,
                          fillColor: theme
                              .scaffoldBackgroundColor,
                          contentPadding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 16,
                            vertical: 15,
                          ),
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            borderSide:
                                BorderSide.none,
                          ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            borderSide:
                                BorderSide(
                              color: theme
                                  .dividerColor
                                  .withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            borderSide:
                                BorderSide(
                              color:
                                  colorScheme
                                      .primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Expanded(
                      child:
                          filteredClocks
                                  .isEmpty
                              ? _buildNoSearchResult(
                                  colorScheme,
                                  localizations,
                                )
                              : ListView
                                  .separated(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior
                                          .onDrag,
                                  padding:
                                      const EdgeInsets
                                          .only(
                                    left: 16,
                                    right: 16,
                                    bottom:
                                        20,
                                  ),
                                  itemCount:
                                      filteredClocks
                                          .length,
                                  separatorBuilder:
                                      (
                                    BuildContext
                                        context,
                                    int index,
                                  ) {
                                    return Divider(
                                      color: theme
                                          .dividerColor
                                          .withValues(
                                        alpha:
                                            0.35,
                                      ),
                                    );
                                  },
                                  itemBuilder:
                                      (
                                    BuildContext
                                        context,
                                    int index,
                                  ) {
                                    final WorldClock
                                        clock =
                                        filteredClocks[
                                            index];

                                    final bool
                                        alreadyAdded =
                                        savedClocks
                                            .any(
                                      (
                                        WorldClock
                                            saved,
                                      ) =>
                                          saved.city
                                                  .toLowerCase() ==
                                              clock
                                                  .city
                                                  .toLowerCase() &&
                                          saved.timezoneName ==
                                              clock
                                                  .timezoneName,
                                    );

                                    return ListTile(
                                      leading:
                                          Text(
                                        clock.flag,
                                        style:
                                            const TextStyle(
                                          fontSize:
                                              28,
                                        ),
                                      ),
                                      title:
                                          Text(
                                        clock.city,
                                        style:
                                            TextStyle(
                                          color:
                                              colorScheme
                                                  .onSurface,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                      subtitle:
                                          Text(
                                        '${clock.country}\n'
                                        '${clock.timezoneName}',
                                        style:
                                            TextStyle(
                                          color:
                                              colorScheme
                                                  .onSurfaceVariant,
                                          fontSize:
                                              12,
                                        ),
                                      ),
                                      isThreeLine:
                                          true,
                                      trailing:
                                          alreadyAdded
                                              ? Icon(
                                                  Icons
                                                      .check_circle,
                                                  color:
                                                      colorScheme
                                                          .primary,
                                                )
                                              : Icon(
                                                  Icons
                                                      .add_circle_outline,
                                                  color:
                                                      colorScheme
                                                          .primary,
                                                ),
                                      enabled:
                                          !alreadyAdded &&
                                              !isAddingClock,
                                      onTap:
                                          alreadyAdded
                                              ? null
                                              : () async {
                                                  Navigator
                                                      .pop(
                                                    sheetContext,
                                                  );

                                                  await _addWorldClock(
                                                    clock,
                                                  );
                                                },
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNoSearchResult(
    ColorScheme colorScheme,
    AppLocalizations localizations,
  ) {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 52,
            color: colorScheme
                .onSurfaceVariant,
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            localizations.noCityFound,
            style: TextStyle(
              color:
                  colorScheme.onSurface,
              fontSize: 17,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            localizations
                .tryAnotherCityCountryTimezone,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addWorldClock(
    WorldClock clock,
  ) async {
    if (isAddingClock) {
      return;
    }

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final bool alreadyAdded =
        savedClocks.any(
      (WorldClock saved) =>
          saved.city.toLowerCase() ==
              clock.city
                  .toLowerCase() &&
          saved.timezoneName ==
              clock.timezoneName,
    );

    if (alreadyAdded) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${clock.city} '
              '${localizations.isAlreadyAdded}',
            ),
            behavior:
                SnackBarBehavior.floating,
          ),
        );

      return;
    }

    setState(() {
      isAddingClock = true;
    });

    try {
      final WorldClock newClock =
          await _worldClockService
              .addWorldClock(
        city: clock.city,
        country: clock.country,
        flag: clock.flag,
        timezoneName:
            clock.timezoneName,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        savedClocks.add(
          newClock,
        );
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${clock.city} '
              '${localizations.added}',
            ),
            behavior:
                SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${localizations.unableToAddClock}: '
              '$error',
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          isAddingClock = false;
        });
      }
    }
  }

  Future<void> _deleteWorldClock(
    WorldClock clock,
  ) async {
    final String? clockId =
        clock.id;

    if (clockId == null ||
        deletingClockId != null) {
      return;
    }

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    setState(() {
      deletingClockId =
          clockId;
    });

    try {
      await _worldClockService
          .deleteWorldClock(
        clockId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        savedClocks.removeWhere(
          (WorldClock item) =>
              item.id == clockId,
        );
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${clock.city} '
              '${localizations.removed}',
            ),
            behavior:
                SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${localizations.unableToRemoveClock}: '
              '$error',
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          deletingClockId = null;
        });
      }
    }
  }

  Future<void> _showDeleteDialog(
    WorldClock clock,
  ) async {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    if (clock.id == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              localizations
                  .thisClockCannotBeDeleted,
            ),
          ),
        );

      return;
    }

    final bool? shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (
        BuildContext dialogContext,
      ) {
        final ThemeData theme =
            Theme.of(
          dialogContext,
        );

        final ColorScheme colorScheme =
            theme.colorScheme;

        return AlertDialog(
          backgroundColor:
              theme.cardColor,
          title: Text(
            localizations.deleteClock,
            style: TextStyle(
              color:
                  colorScheme.onSurface,
            ),
          ),
          content: Text(
            '${localizations.delete} '
            '${clock.city} '
            '${localizations.fromYourWorldClocks}',
            style: TextStyle(
              color: colorScheme
                  .onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: Text(
                localizations.cancel,
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    colorScheme.error,
                foregroundColor:
                    colorScheme.onError,
              ),
              child: Text(
                localizations.delete,
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete ==
        true) {
      await _deleteWorldClock(
        clock,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.public,
                    color:
                        colorScheme.primary,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: Text(
                      localizations
                          .worldClocks,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme
                            .onSurface,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Material(
                    color:
                        Colors.transparent,
                    child: InkWell(
                      onTap: isAddingClock
                          ? null
                          : _openAddClockSheet,
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration:
                            BoxDecoration(
                          color:
                              theme.cardColor,
                          shape:
                              BoxShape.circle,
                          border:
                              Border.all(
                            color: theme
                                .dividerColor
                                .withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: isAddingClock
                            ? Padding(
                                padding:
                                    const EdgeInsets
                                        .all(
                                  10,
                                ),
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                  color:
                                      colorScheme
                                          .primary,
                                ),
                              )
                            : Icon(
                                Icons.add,
                                color:
                                    colorScheme
                                        .primary,
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Expanded(
                child:
                    _buildClockContent(
                  theme,
                  colorScheme,
                  localizations,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClockContent(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations localizations,
  ) {
    if (isLoading) {
      return Center(
        child:
            CircularProgressIndicator(
          color:
              colorScheme.primary,
        ),
      );
    }

    if (savedClocks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .public_off_outlined,
              size: 58,
              color: colorScheme
                  .onSurfaceVariant,
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              localizations
                  .noWorldClocksAdded,
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    colorScheme.onSurface,
                fontSize: 18,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              localizations
                  .tapPlusToAddCity,
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            ElevatedButton.icon(
              onPressed: isAddingClock
                  ? null
                  : _openAddClockSheet,
              icon: const Icon(
                Icons.search,
              ),
              label: Text(
                localizations.searchCity,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh:
          _loadWorldClocks,
      child: ListView.builder(
        physics:
            const AlwaysScrollableScrollPhysics(),
        itemCount:
            savedClocks.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final WorldClock clock =
              savedClocks[index];

          final bool isDeleting =
              deletingClockId ==
                  clock.id;

          return Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(
                  right: 46,
                ),
                child:
                    GestureDetector(
                  onLongPress:
                      isDeleting
                          ? null
                          : () {
                              _showDeleteDialog(
                                clock,
                              );
                            },
                  child:
                      WorldClockCard(
                    clock: clock,
                  ),
                ),
              ),

              Positioned(
                top: 0,
                bottom: 12,
                right: 0,
                child: Center(
                  child: IconButton(
                    tooltip:
                        localizations
                            .deleteClock,
                    onPressed:
                        isDeleting
                            ? null
                            : () {
                                _showDeleteDialog(
                                  clock,
                                );
                              },
                    icon: isDeleting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2,
                              color:
                                  colorScheme
                                      .error,
                            ),
                          )
                        : Icon(
                            Icons
                                .delete_outline,
                            color:
                                colorScheme
                                    .error,
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}