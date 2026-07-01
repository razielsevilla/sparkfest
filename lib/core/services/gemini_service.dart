import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gabaysr/core/services/ai_service.dart';
import 'package:gabaysr/models/checkin.dart';

class GeminiService implements AiService {
  final String? apiKey;

  GeminiService({String? apiKey})
      : apiKey = (apiKey != null && apiKey.trim().isNotEmpty)
            ? apiKey
            : const String.fromEnvironment('GEMINI_API_KEY');

  @override
  Future<Map<String, String>> checkScamMessage(String messageText, {String? senderNumber}) async {
    // If no API key is configured, run the fallback local offline rule parser
    if (apiKey == null || apiKey!.trim().isEmpty) {
      return _localScamCheck(messageText, senderNumber: senderNumber);
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey!,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
        systemInstruction: Content.system(
          "You are a scam-detection assistant for a Filipino senior citizen safety app "
          "called Gabay Sr. You analyze SMS messages, social media messages, or call "
          "transcripts to determine if they are likely scams targeting Filipino seniors. "
          "Respond ONLY in this exact JSON format, no other text:\n"
          "{\n"
          "  \"riskLevel\": \"Mataas\" | \"Katamtaman\" | \"Mababa\",\n"
          "  \"reasoning\": \"<1-2 sentence explanation in simple Filipino/Taglish>\",\n"
          "  \"recommendedAction\": \"<1 short, clear instruction in Filipino>\"\n"
          "}"
        ),
      );

      final prompt = "Message: \"$messageText\"\nSender number: \"${senderNumber ?? 'Unknown'}\"";
      final response = await model.generateContent([Content.text(prompt)]);
      
      final textResult = response.text;
      if (textResult == null || textResult.isEmpty) {
        throw Exception("Empty response from Gemini API");
      }

      final Map<String, dynamic> data = jsonDecode(textResult.trim());
      return {
        "riskLevel": data['riskLevel'] ?? "Katamtaman",
        "reasoning": data['reasoning'] ?? "Hindi matukoy nang husto ang mensahe.",
        "recommendedAction": data['recommendedAction'] ?? "Magtanong sa iyong Trusted Circle."
      };
    } catch (e) {
      // Clean fallback if API fails
      return _localScamCheck(messageText, senderNumber: senderNumber);
    }
  }

  @override
  Future<String> generateWeeklySummary(String seniorName, List<CheckIn> weekCheckIns) async {
    if (weekCheckIns.isEmpty) {
      return "Wala kaming natanggap na check-in mula kay Lolo/Lola $seniorName ngayong linggo. Mas mabuting tawagan o kumustahin natin siya nang direkta.";
    }

    if (apiKey == null || apiKey!.trim().isEmpty) {
      return _localWeeklySummary(seniorName, weekCheckIns);
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey!,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
        systemInstruction: Content.system(
          "You are a warm, caring assistant generating a weekly summary of a Filipino "
          "senior citizen's wellbeing for their family members, who may live far away "
          "(including overseas/OFW family). Write in a warm, conversational Filipino "
          "or Taglish tone, as if a caring friend is giving the family an update.\n"
          "Guidelines:\n"
          "- 3 to 4 sentences only\n"
          "- Highlight positive moments first\n"
          "- Gently mention any days with low mood or missed check-ins, without alarm\n"
          "- Do not use clinical or robotic language\n"
          "Respond ONLY in this exact JSON format, no other text:\n"
          "{\n"
          "  \"summaryText\": \"<3-4 sentence warm summary in Filipino/Taglish>\",\n"
          "  \"moodTrend\": \"Improving\" | \"Stable\" | \"Declining\"\n"
          "}"
        ),
      );

      final checkInListString = weekCheckIns.map((c) => 
        "Date: ${c.date}, Mood: ${c.mood}, Activities: ${c.activities.join(', ')}, Note: ${c.note ?? 'None'}"
      ).join("\n");

      final prompt = "Senior's name: $seniorName\nThis week's check-ins:\n$checkInListString";
      final response = await model.generateContent([Content.text(prompt)]);

      final textResult = response.text;
      if (textResult == null || textResult.isEmpty) {
        throw Exception("Empty response");
      }

      final Map<String, dynamic> data = jsonDecode(textResult.trim());
      return data['summaryText'] ?? _localWeeklySummary(seniorName, weekCheckIns);
    } catch (e) {
      return _localWeeklySummary(seniorName, weekCheckIns);
    }
  }

  // ==========================================
  // LOCAL FALLBACK GENERATORS
  // ==========================================

  Map<String, String> _localScamCheck(String messageText, {String? senderNumber}) {
    final text = messageText.toLowerCase();

    if (text.contains("otp") || text.contains("pin code") || text.contains("one-time pin") || text.contains("one time pin")) {
      return {
        "riskLevel": "Mataas",
        "reasoning": "Hinihingi nito ang iyong OTP o PIN code. Ang mga bangko o lehitimong ahensya ay hindi kailanman magtatanong ng iyong OTP sa pamamagitan ng text.",
        "recommendedAction": "HUWAG ibigay ang iyong OTP o PIN. Burahin agad ang mensaheng ito."
      };
    }

    if ((text.contains("apo") || text.contains("lola") || text.contains("lolo") || text.contains("mama") || text.contains("papa")) &&
        (text.contains("padala") || text.contains("pera") || text.contains("wallet") || text.contains("gcash") || text.contains("ospital") || text.contains("pulis"))) {
      return {
        "riskLevel": "Mataas",
        "reasoning": "Mukha itong Apo o kapamilya na nagpapanggap na nasa panganib upang humingi ng pera agad-agad (impersonation scam).",
        "recommendedAction": "Tawagan muna ang iyong tunay na kapamilya sa kanilang kilalang numero upang mag-verify bago magpadala."
      };
    }

    if ((text.contains("nanalo") || text.contains("congratulations") || text.contains("raffle") || text.contains("panalo")) &&
        (text.contains("claim") || text.contains("gcash") || text.contains("puntos") || text.contains("piso") || text.contains("pension"))) {
      return {
        "riskLevel": "Mataas",
        "reasoning": "Ito ay nag-aalok ng pekeng premyo o pension kapalit ng pag-click sa link o pagbibigay ng impormasyon.",
        "recommendedAction": "Huwag i-click ang anumang link at huwag magbigay ng personal na detalye."
      };
    }

    if (text.contains("invest") || text.contains("crypto") || text.contains("guaranteed") || text.contains("doble ang pera") || text.contains("kumita")) {
      if (text.contains("returns") || text.contains("tuyo") || text.contains("kita") || text.contains("easy money")) {
        return {
          "riskLevel": "Mataas",
          "reasoning": "Mukhang investment scam o Ponzi scheme na nangangako ng mabilis at malaking kita na hindi makatotohanan.",
          "recommendedAction": "Iwasan ang pagbibigay ng pera sa mga hindi rehistradong investment platforms."
        };
      }
    }

    if (text.contains("mama") || text.contains("salamat") || text.contains("bukas") || text.contains("kumain") || text.contains("gamot") || text.contains("kamusta")) {
      return {
        "riskLevel": "Mababa",
        "reasoning": "Karaniwang mensahe mula sa pamilya o kaibigan na walang nakikitang senyales ng panloloko.",
        "recommendedAction": "Ligtas itong sagutin."
      };
    }

    return {
      "riskLevel": "Katamtaman",
      "reasoning": "Hindi namin matukoy nang lubusan kung ito ay ligtas. Mag-ingat kung ang mensahe ay humihingi ng anumang aksyon o naglalaman ng link.",
      "recommendedAction": "Magtanong sa iyong Trusted Circle bago sumagot o gumawa ng aksyon."
    };
  }

  String _localWeeklySummary(String seniorName, List<CheckIn> weekCheckIns) {
    int happyCount = weekCheckIns.where((c) => c.mood == "Masaya").length;
    int sadCount = weekCheckIns.where((c) => c.mood == "Malungkot").length;
    int stableCount = weekCheckIns.where((c) => c.mood == "Okay lang").length;

    String moodSummary = "naging okay";
    if (happyCount > sadCount && happyCount >= stableCount) {
      moodSummary = "naging masaya at maganda";
    } else if (sadCount > happyCount) {
      moodSummary = "may ilang araw na naging malungkot";
    }

    Set<String> uniqueActivities = {};
    for (var checkin in weekCheckIns) {
      uniqueActivities.addAll(checkin.activities);
    }

    String activitySummary = "";
    if (uniqueActivities.isNotEmpty) {
      activitySummary = " Kabilang sa kanyang mga ginawa ang: ${uniqueActivities.take(3).join(', ')}.";
    }

    return "Sa kabuuan, ang linggo ni Lola/Lolo $seniorName ay $moodSummary.$activitySummary Palaging nariyan ang kanyang Trusted Circle para sa kanya.";
  }
}
