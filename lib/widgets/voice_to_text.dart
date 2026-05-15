import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:interviya/data/providers/interview_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class VoiceToText extends StatefulWidget {
  const VoiceToText({super.key});

  @override
  State<VoiceToText> createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  final String _hfToken = dotenv.env['HUGGING_FACE_ACCESS_TOKEN   '] ?? "";
  final String _modelUrl = "https://api-inference.huggingface.co/models/openai/whisper-large-v3-turbo";

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/audio_record.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc), 
          path: filePath,
        );

        setState(() {
          _isRecording = true;
        });
        print("AI is listening...");
      }
    } catch (e) {
      print('Error starting record: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      print("AI stopped listening.");

      if (path != null) {
        _sendAudioToHuggingFace(File(path));
      }
    } catch (e) {
      print('Error stopping record: $e');
    }
  }

  Future<void> _sendAudioToHuggingFace(File audioFile) async {
    print("Sending audio to Hugging Face...");
    
    try {
      final bytes = await audioFile.readAsBytes();

      final response = await http.post(
        Uri.parse(_modelUrl),
        headers: {
          'Authorization': 'Bearer $_hfToken',
          'Content-Type': 'audio/x-m4a',
        },
        body: bytes,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String textResult = data['text'] ?? "";
        
        print("Transcription Success: $textResult");
        
        if (mounted && textResult.isNotEmpty) {
          Provider.of<InterviewProvider>(context, listen: false)
              .updateCurrentAnswer(textResult);
        }
      } else {
        print("Hugging Face Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Network or parsing error: $e");
    }
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
            duration: const Duration(milliseconds: 200),
            height: 85,
            width: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _isRecording 
                    ? [const Color(0xffFF5252), const Color(0xffFF1744)] 
                    : [const Color(0xff0A898D), const Color(0xff0CBABF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isRecording ? const Color(0xffFF5252) : const Color(0xff0A898D))
                      .withValues(alpha: 0.35),
                  blurRadius: _isRecording ? 30 : 20,
                  spreadRadius: _isRecording ? 8 : 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              _isRecording ? Icons.stop : Icons.mic, 
              color: Colors.white, 
              size: 42,
            ),
          ),
        ),
        Padding(
  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
  child: Text(
    _isRecording ? "Listening..." : "Hold to speak",
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 12),
  ),
)
      ],
    );
  }
}