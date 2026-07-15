import 'package:flutter/material.dart';

import '../../data/schedule_data.dart';
import '../../models/schedule_model.dart';
import '../theme/app_constants.dart';
import '../widgets/schedule/add_schedule_sheet.dart';
import '../widgets/schedule/schedule_header.dart';
import '../widgets/schedule/schedule_list.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String selectedCategory = 'All';

  bool _showAddScheduleSheet = false;

  late List<ScheduleModel> todaySchedules;
  late List<ScheduleModel> tomorrowSchedules;

  @override
  void initState() {
    super.initState();

    todaySchedules = List<ScheduleModel>.from(
      ScheduleData.todaySchedules,
    );

    tomorrowSchedules = List<ScheduleModel>.from(
      ScheduleData.tomorrowSchedules,
    );
  }

  List<ScheduleModel> get filteredTodaySchedules {
    if (selectedCategory == 'All') {
      return todaySchedules;
    }

    return todaySchedules
        .where(
          (schedule) => schedule.category == selectedCategory,
        )
        .toList();
  }

  List<ScheduleModel> get filteredTomorrowSchedules {
    if (selectedCategory == 'All') {
      return tomorrowSchedules;
    }

    return tomorrowSchedules
        .where(
          (schedule) => schedule.category == selectedCategory,
        )
        .toList();
  }

  void _openAddScheduleSheet() {
    FocusScope.of(context).unfocus();

    setState(() {
      _showAddScheduleSheet = true;
    });
  }

  void _closeAddScheduleSheet() {
    FocusScope.of(context).unfocus();

    setState(() {
      _showAddScheduleSheet = false;
    });
  }

  void _saveNewSchedule(ScheduleModel newSchedule) {
    setState(() {
      todaySchedules.add(newSchedule);
      _showAddScheduleSheet = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${newSchedule.title} added successfully',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: newSchedule.categoryColor,
      ),
    );
  }

  void _deleteTodaySchedule(ScheduleModel schedule) {
    setState(() {
      todaySchedules.remove(schedule);
    });

    _showDeletedMessage(schedule);
  }

  void _deleteTomorrowSchedule(ScheduleModel schedule) {
    setState(() {
      tomorrowSchedules.remove(schedule);
    });

    _showDeletedMessage(schedule);
  }

  void _showDeletedMessage(ScheduleModel schedule) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${schedule.title} deleted',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleScheduleTap(ScheduleModel schedule) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${schedule.title} selected',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            // Main schedule content
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.pagePadding,
                16,
                AppConstants.pagePadding,
                110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  ScheduleHeader(
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  ScheduleList(
                    title: 'Today',
                    tasks: filteredTodaySchedules,
                    onScheduleTap: _handleScheduleTap,
                    onScheduleDelete: _deleteTodaySchedule,
                  ),

                  const SizedBox(height: 24),

                  ScheduleList(
                    title: 'Tomorrow',
                    tasks: filteredTomorrowSchedules,
                    onScheduleTap: _handleScheduleTap,
                    onScheduleDelete: _deleteTomorrowSchedule,
                  ),
                ],
              ),
            ),

            // Add button
            if (!_showAddScheduleSheet)
              Positioned(
                right: AppConstants.pagePadding,
                bottom: 24,
                child: FloatingActionButton(
                  onPressed: _openAddScheduleSheet,
                  child: const Icon(
                    Icons.add_rounded,
                    size: 28,
                  ),
                ),
              ),

            // Dark overlay behind the Add Schedule panel
            if (_showAddScheduleSheet)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _closeAddScheduleSheet,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.70),
                  ),
                ),
              ),

            // Add Schedule panel
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              left: 0,
              right: 0,
              bottom: _showAddScheduleSheet ? 0 : -1000,
              child: AddScheduleSheet(
                onClose: _closeAddScheduleSheet,
                onScheduleSaved: _saveNewSchedule,
              ),
            ),
          ],
        ),
      ),
    );
  }
}