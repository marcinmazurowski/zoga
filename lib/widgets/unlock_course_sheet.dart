import 'package:flutter/material.dart';
import '../services/course_repository.dart';
import '../theme/app_colors.dart';

/// Bottom sheet triggered by the center nav-bar button: lets the user type
/// an unlock code and immediately reveals the matching course, no sync step
/// needed since the local repository already holds the full catalog.
class UnlockCourseSheet extends StatefulWidget {
  const UnlockCourseSheet({super.key});

  @override
  State<UnlockCourseSheet> createState() => _UnlockCourseSheetState();
}

class _UnlockCourseSheetState extends State<UnlockCourseSheet> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _message;
  bool _success = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _loading = true;
      _message = null;
    });
    final result = await courseRepository.redeemCode(code);
    setState(() {
      _loading = false;
      switch (result) {
        case UnlockResult.success:
          _success = true;
          _message = 'Kurs odblokowany! Jest już dostępny na liście.';
          break;
        case UnlockResult.alreadyUsed:
          _success = false;
          _message = 'Ten kod został już wykorzystany.';
          break;
        case UnlockResult.invalidCode:
          _success = false;
          _message = 'Nieprawidłowy kod. Sprawdź i spróbuj ponownie.';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Odblokuj kurs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(_success),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Wpisz kod otrzymany od Zoga Multidimensional Movement, aby uzyskać dostęp do kursu.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Kod kursu',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => _submit(),
            ),
            if (_message != null) ...[
              const SizedBox(height: 12),
              Text(
                _message!,
                style: TextStyle(
                  color: _success ? AppColors.success : AppColors.error,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Odblokuj'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
