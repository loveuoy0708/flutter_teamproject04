import 'package:flutter/material.dart';
import 'task_management.dart';
import 'task_model.dart';
import 'task_form.dart';


void main() => runApp(const KwajakApp());

const Color appBg = Color(0xFFFFF8F5);
const Color appBrown = Color(0xFF9B6848);
const Color appDark = Color(0xFF49352D);
const Color appMuted = Color(0xFFAA9690);
const Color appCard = Color(0xFFFFFEFD);

class KwajakApp extends StatelessWidget {
  const KwajakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '콰작!',
      theme: ThemeData(
        scaffoldBackgroundColor: appBg,
        colorScheme: ColorScheme.fromSeed(seedColor: appBrown),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedTab = 0;
  String _filter = '전체';
  final List<Assignment> _tasks = [];

  Future<void> _openTaskForm({Assignment? task}) async {
    final result = await showModalBottomSheet<Assignment>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskForm(task: task),
    );
    if (result == null) return;
    setState(() {
      if (task == null) {
        _tasks.add(result);
      } else {
        final index = _tasks.indexOf(task);
        if (index >= 0) _tasks[index] = result;
      }
    });
  }

  void _deleteTask(Assignment task) {
    setState(() => _tasks.remove(task));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('과제를 삭제했습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeTab(),
      const TeamPlaceholder(
          title: '캘린더',
          message: '캘린더 담당 팀원이 이 화면을 구현합니다.',
          icon: Icons.calendar_month_outlined),
      const TeamPlaceholder(
          title: '쿠키함',
          message: '포춘쿠키 담당 팀원이 이 화면을 구현합니다.',
          icon: Icons.cookie_outlined),
      const TeamPlaceholder(
          title: '설정',
          message: '설정 담당 팀원이 이 화면을 구현합니다.',
          icon: Icons.settings_outlined),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_selectedTab]),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton(
              backgroundColor: appBrown,
              foregroundColor: Colors.white,
              onPressed: () => _openTaskForm(),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _homeTab() {
    return TaskManagement(
      tasks: _tasks,
      filter: _filter,
      onFilterChanged: (value) => setState(() => _filter = value),
      onAdd: () => _openTaskForm(),
      onEdit: (task) => _openTaskForm(task: task),
      onDelete: _deleteTask,
      onCompletionChanged: (task, completed) {
        setState(() => task.completed = completed);
      },
    );
  }

  Widget _bottomNavigation() {
    const labels = ['홈', '캘린더', '쿠키함', '설정'];
    const icons = [
      Icons.home_rounded,
      Icons.calendar_month_outlined,
      Icons.cookie_outlined,
      Icons.person_outline_rounded,
    ];

    return Container(
      decoration: BoxDecoration(
        color: appCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: appBrown.withOpacity(.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(4, (index) {
            final selected = _selectedTab == index;
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedTab = index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icons[index],
                          color: selected ? appBrown : appMuted, size: 23),
                      const SizedBox(height: 3),
                      Text(labels[index],
                          style: TextStyle(
                            color: selected ? appBrown : appMuted,
                            fontSize: 10,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          )),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// 다른 팀원이 맡은 화면을 연결하기 전까지 보여주는 임시 화면입니다.
/// 실제 캘린더/쿠키함/설정 기능은 들어 있지 않습니다.
class TeamPlaceholder extends StatelessWidget {
  const TeamPlaceholder({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBg,
      appBar: AppBar(
        backgroundColor: appBg,
        title: Text(title,
            style: const TextStyle(
                color: appDark, fontWeight: FontWeight.w800)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: appBrown),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    color: appDark,
                    fontSize: 19,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: appMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
