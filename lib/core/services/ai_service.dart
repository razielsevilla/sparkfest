import 'package:gabaysr/models/checkin.dart';

abstract class AiService {
  // Analyzes message and returns a Map containing structured fields:
  // - riskLevel: Mataas | Katamtaman | Mababa
  // - reasoning: Filipino explanation
  // - recommendedAction: Filipino advice
  Future<Map<String, String>> checkScamMessage(String messageText, {String? senderNumber});

  // Generates a warm, caring weekly status summary in Taglish
  Future<String> generateWeeklySummary(String seniorName, List<CheckIn> weekCheckIns);
}
