import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceToText extends StatefulWidget {
  final Function(String) onResponseRecorded;
  const VoiceToText({
    super.key,
    required this.onResponseRecorded
  });

  @override
  State<VoiceToText> createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isRecording = false;
  bool _isProcessing = false;
  String _recognizedText = "";

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  @override
  void dispose() {
    _speech.stop(); 
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    try {
      bool available = await _speech.initialize(
        onError: (errorNotification) {
          _showErrorSnackbar("Speech error: ${errorNotification.errorMsg}");
        },
        onStatus: (status) {
          // Optional: handle status changes like 'listening' or 'notListening'
        },
      );

      if (!available && mounted) {
        _showErrorSnackbar("Speech recognition is not available on this device.");
      }
    } catch (e) {
      _showErrorSnackbar("Failed to initialize speech recognition.");
    }
  }

  Future<void> _startRecording() async {
    if (_isProcessing) return;

    if (!_speech.isAvailable) {
      _showErrorSnackbar("Speech engine not ready. Please try again.");
      return;
    }

    setState(() {
      _isRecording = true;
      _recognizedText = "";
    });

    try {
      await _speech.listen(
        listenMode: stt.ListenMode.confirmation,
        onResult: (result) {
          if (!mounted) return;
          setState(() {
            _recognizedText = result.recognizedWords;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorSnackbar("Failed to start listening.");
    }
  }

  Future<void> _stopRecording() async {
  if (!_isRecording) return;

  setState(() {
    _isRecording = false;
    _isProcessing = true;
  });

  try {
    await _speech.stop();
    final text = _recognizedText.trim();

    if (mounted) {
      widget.onResponseRecorded(text.isNotEmpty ? text : "No answer provided");
    }
  } catch (e) {
    _showErrorSnackbar("Error saving your response.");
  } finally {
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}

  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPressStart: (_) => _startRecording(),
          onLongPressEnd: (_) => _stopRecording(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 85,
            width: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _isProcessing
                    ? [Colors.grey.shade400, Colors.grey.shade600]
                    : _isRecording
                        ? [const Color(0xffFF5252), const Color(0xffFF1744)]
                        : [const Color(0xff0A898D), const Color(0xff0CBABF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isRecording
                          ? const Color(0xffFF5252)
                          : const Color(0xff0A898D))
                      .withValues(alpha: 0.35),
                  blurRadius: _isRecording ? 30 : 20,
                  spreadRadius: _isRecording ? 8 : 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: _isProcessing
                  ? const SizedBox(
                      height: 32,
                      width: 32,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 42,
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 4,
          ),
          child: Text(
            _isProcessing
                ? "Processing audio..."
                : _isRecording
                    ? "Listening..."
                    : "Hold to speak",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}