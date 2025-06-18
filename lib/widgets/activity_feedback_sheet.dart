import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class ActivityFeedbackSheet extends StatefulWidget {
  final void Function(
      {required int understanding,
      required int participation,
      required String notes}) onSend;
  final VoidCallback onClose;
  final bool isLoading;

  const ActivityFeedbackSheet({
    super.key,
    required this.onSend,
    required this.onClose,
    this.isLoading = false,
  });

  @override
  State<ActivityFeedbackSheet> createState() => _ActivityFeedbackSheetState();
}

class _ActivityFeedbackSheetState extends State<ActivityFeedbackSheet> {
  int understanding = 0;
  int participation = 0;
  String notes = '';
  String? errorText;
  bool sending = false;

  Widget _buildStars(int value, void Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          3,
          (i) => GestureDetector(
                onTap: () => onChanged(i + 1),
                child: Icon(
                  Icons.star_rounded,
                  size: 60,
                  color: (i < value)
                      ? app_theme.kPrimaryColor
                      : app_theme.kTriaryColor.withOpacity(0.8),
                ),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32),
              Text('Great Job!',
                  style: app_theme.blackTextStyle
                      .copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 28),
                onPressed: () {
                  widget.onClose();
                  widget.onSend(
                      understanding: understanding,
                      participation: participation,
                      notes: notes);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Tell us how well did they understand?',
              style: app_theme.blackTextStyle
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _buildStars(understanding, (v) => setState(() => understanding = v)),
          Text('choose your stars',
              style: app_theme.blackTextStyle
                  .copyWith(fontSize: 12, color: Colors.black38)),
          const SizedBox(height: 20),
          Text('How involved were they?',
              style: app_theme.blackTextStyle
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _buildStars(participation, (v) => setState(() => participation = v)),
          Text('choose your stars',
              style: app_theme.blackTextStyle
                  .copyWith(fontSize: 12, color: Colors.black38)),
          const SizedBox(height: 20),
          TextField(
            minLines: 2,
            maxLines: 5,
            maxLength: 500,
            onChanged: (v) => setState(() => notes = v),
            decoration: InputDecoration(
              hintText: 'The activity is so fun!',
              filled: true,
              fillColor: app_theme.kTriaryColor.withOpacity(0.8),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
              counterText: '${notes.length}/500',
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 14)),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: app_theme.kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: widget.isLoading || sending
                  ? null
                  : () async {
                      setState(() {
                        errorText = null;
                        sending = true;
                      });
                      // If all are empty, show error
                      if ((understanding == 0 &&
                          participation == 0 &&
                          notes.trim().isEmpty)) {
                        setState(() {
                          errorText = 'Please fill in at least one field.';
                          sending = false;
                        });
                        return;
                      }
                      widget.onSend(
                          understanding: understanding,
                          participation: participation,
                          notes: notes);
                    },
              child: widget.isLoading || sending
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('Send',
                      style: app_theme.whiteTextStyle
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
