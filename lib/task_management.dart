
import 'package:flutter/material.dart';
import 'task_model.dart';
import 'task_card.dart';
// 콰작! 디자인 색상
const Color taskBg = Color(0xFFFFF8F5);
const Color taskCard = Color(0xFFFFFEFD);
const Color taskBrown = Color(0xFF9B6848);
const Color taskText = Color(0xFF49352D);
const Color taskMuted = Color(0xFFAA9690);
const Color taskLine = Color(0xFFF0E5E0);
const Color taskCoral = Color(0xFFE9857D);
const Color taskOrange = Color(0xFFF2B36F);
const Color taskGreen = Color(0xFFB9C99B);

class TaskManagement extends StatelessWidget {
  const TaskManagement({
    super.key,
    required this.tasks,
    required this.filter,
    required this.onFilterChanged,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onCompletionChanged,
  });

  final List<Assignment> tasks;
  final String filter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onAdd;
  final ValueChanged<Assignment> onEdit;
  final ValueChanged<Assignment> onDelete;
  final void Function(Assignment, bool) onCompletionChanged;

  int get _completedCount =>
      tasks.where((task) => task.completed).length;

  double get _progress =>
      tasks.isEmpty ? 0 : _completedCount / tasks.length;

  List<Assignment> get _filteredTasks {
    final now = DateTime.now();

    final result = tasks.where((task) {
      switch (filter) {
        case '중요':
          return task.priority == '높음';

        case '오늘':
          return task.deadline.year == now.year &&
              task.deadline.month == now.month &&
              task.deadline.day == now.day;

        case '이번 주':
          final today = DateTime(now.year, now.month, now.day);
          final lastDay = today.add(
            Duration(days: 7 - now.weekday),
          );

          final deadline = DateTime(
            task.deadline.year,
            task.deadline.month,
            task.deadline.day,
          );

          return !deadline.isBefore(today) &&
              !deadline.isAfter(lastDay);

        default:
          return true;
      }
    }).toList();

    int priorityOrder(String priority) {
      switch (priority) {
        case '높음':
          return 0;
        case '보통':
          return 1;
        default:
          return 2;
      }
    }

    result.sort((a, b) {
      if (a.completed != b.completed) {
        return a.completed ? 1 : -1;
      }

      final compare = priorityOrder(a.priority)
          .compareTo(priorityOrder(b.priority));

      if (compare != 0) return compare;

      return a.deadline.compareTo(b.deadline);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final visibleTasks = _filteredTasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGreeting(),
        _buildProgressCard(),
        _buildFilter(),

        Padding(
          padding: const EdgeInsets.fromLTRB(22, 15, 22, 9),
          child: Row(
            children: [
              const Text(
                '나의 과제',
                style: TextStyle(
                  color: taskText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${visibleTasks.length}개',
                style: const TextStyle(
                  color: taskMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: visibleTasks.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  itemCount: visibleTasks.length,
                  itemBuilder: (context, index) {
                    final task = visibleTasks[index];

                    return TaskCard(
                      task: task,
                      onEdit: () => onEdit(task),
                      onDelete: () =>
                          _confirmDelete(context, task),
                      onCompletionChanged: (value) =>
                          onCompletionChanged(task, value),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 23, 22, 15),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안녕하세요! ✨',
                  style: TextStyle(
                    color: taskMuted,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '오늘도\n콰작! 해봐요 ',
                  style: TextStyle(
                    color: taskText,
                    fontSize: 25,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE9D8),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.sports_martial_arts_rounded,
              color: taskBrown,
              size: 43,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 3, 18, 14),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: taskCard,
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: taskBrown.withOpacity(.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 과제',
            style: TextStyle(
              color: taskMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_completedCount / ${tasks.length}',
                style: const TextStyle(
                  color: taskText,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${(_progress * 100).round()}%',
                style: const TextStyle(
                  color: taskBrown,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 9,
              backgroundColor: taskLine,
              color: const Color(0xFFC99465),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    const filters = ['전체', '중요', '오늘', '이번 주'];

    return SizedBox(
      height: 43,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        children: filters.map((value) {
          final selected = filter == value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(value),
              selected: selected,
              onSelected: (_) => onFilterChanged(value),
              selectedColor: taskBrown,
              backgroundColor: taskCard,
              side: BorderSide.none,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: selected ? Colors.white : taskMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.assignment_turned_in_outlined,
            color: taskMuted,
            size: 46,
          ),
          const SizedBox(height: 12),
          const Text(
            '표시할 과제가 없어요.',
            style: TextStyle(
              color: taskText,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '새 과제를 추가하고 하나씩 완료해 보세요!',
            style: TextStyle(
              color: taskMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 17),
            label: const Text('과제 추가'),
            style: OutlinedButton.styleFrom(
              foregroundColor: taskBrown,
              side: const BorderSide(color: taskBrown),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Assignment task,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: taskCard,
        title: const Text('과제를 삭제할까요?'),
        content: Text('"${task.title}" 과제가 목록에서 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text(
              '삭제',
              style: TextStyle(color: taskCoral),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) onDelete(task);
  }
}
