import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY'; // Replace with real key
  static const String _systemPrompt = '''
You are Routine AI — a friendly, motivational daily life assistant for Indian users.
You help with:
- Diet and nutrition (Indian foods like roti, dal, rice, paneer, dosa, samosa)
- Workout and fitness guidance
- Study tips for students (UPSC, JEE, NEET, college)
- Daily habits and productivity
- Sleep and mental wellness
- Motivation and mindset

Keep responses short, practical, and friendly. Use simple English.
Add relevant emojis occasionally. Be encouraging, not preachy.
''';

  late final GenerativeModel _textModel;
  late final GenerativeModel _visionModel;

  GeminiService() {
    _textModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
    _visionModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> chat(List<Map<String, String>> history, String message) async {
    try {
      final chat = _textModel.startChat(
        history: history.map((m) {
          return Content(
            m['role'] == 'user' ? 'user' : 'model',
            [TextPart(m['content']!)],
          );
        }).toList(),
      );
      final response = await chat.sendMessage(Content.text(message));
      return response.text ?? 'Sorry, I could not understand that.';
    } catch (e) {
      return 'Oops! Something went wrong. Please try again.';
    }
  }

  Future<String> analyzeFood(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final prompt = '''
Analyze this Indian food image and provide:
1. Food name (in English, mention Hindi name if applicable)
2. Estimated serving size
3. Approximate nutritional info:
   - Calories (kcal)
   - Protein (g)
   - Carbohydrates (g)
   - Fat (g)
4. A brief health tip about this food

Format your response as structured text with clear sections.
If this is not a food image, say so politely.
''';
      final response = await _visionModel.generateContent([
        Content.multi([
          DataPart('image/jpeg', bytes),
          TextPart(prompt),
        ])
      ]);
      return response.text ?? 'Could not analyze the food image.';
    } catch (e) {
      return 'Could not analyze the food image. Please try again.';
    }
  }

  Future<String> getDailySuggestion(Map<String, dynamic> userData) async {
    try {
      final prompt = '''
Based on this user data:
- Completed tasks today: ${userData['tasksCompleted']}
- Gym streak: ${userData['gymStreak']} days
- Water intake: ${userData['waterMl']} ml
- Sleep last night: ${userData['sleepHours']} hours

Give ONE short, personalized motivational suggestion for improving their day.
Max 2 sentences. Be specific, not generic.
''';
      final response = await _textModel.generateContent([Content.text(prompt)]);
      return response.text ?? 'Keep going, you\'re doing great! 🚀';
    } catch (e) {
      return 'Stay consistent — every small step counts! 💪';
    }
  }
}
