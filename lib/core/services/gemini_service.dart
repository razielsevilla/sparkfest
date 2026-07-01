import 'package:gabaysr/core/services/ai_service.dart';
import 'package:gabaysr/models/checkin.dart';

class GeminiService implements AiService {
  final String? apiKey;

  GeminiService({this.apiKey});

  @override
  Future<Map<String, String>> checkScamMessage(String messageText, {String? senderNumber}) async {
    // Standardizing input text
    final text = messageText.toLowerCase();

    // 1. Phishing & OTP / PIN request checks
    if (text.contains("otp") || text.contains("pin code") || text.contains("one-time pin") || text.contains("one time pin")) {
      return {
        "riskLevel": "Mataas",
        "reasoning": "Hinihingi nito ang iyong OTP o PIN code. Ang mga bangko o lehitimong ahensya ay hindi kailanman magtatanong ng iyong OTP sa pamamagitan ng text.",
        "recommendedAction": "HUWAG ibigay ang iyong OTP o PIN. Burahin agad ang mensaheng ito."
      };
    }

    // 2. Grandchild/Apo impersonation scam checks
    if ((text.contains("apo") || text.contains("lola") || text.contains("lolo") || text.contains("mama") || text.contains("papa")) &&
        (text.contains("padala") || text.contains("pera") || text.contains("wallet") || text.contains("gcash") || text.contains("ospital") || text.contains("pulis"))) {
      return {
        "riskLevel": "Mataas",
        "reasoning": "Mukha itong Apo o kapamilya na nagpapanggap na nasa panganib upang humingi ng pera agad-agad (impersonation scam).",
        "recommendedAction": "Tawagan muna ang iyong tunay na kapamilya sa kanilang kilalang numero upang mag-verify bago magpadala."
      };
    }

    // 3. Fake raffle or prize notification checks
    if ((text.contains("nanalo") || text.contains("congratulations") || text.contains("raffle") || text.contains("panalo")) &&
        (text.contains("claim") || text.contains("gcash") || text.contains("puntos") || text.contains("piso") || text.contains("pension"))) {
      return {
        "riskLevel": "Mataas",
        "reasoning": "Ito ay nag-aalok ng pekeng premyo o pension kapalit ng pag-click sa link o pagbibigay ng impormasyon.",
        "recommendedAction": "Huwag i-click ang anumang link at huwag magbigay ng personal na detalye."
      };
    }

    // 4. Fake investment pattern checks
    if (text.contains("invest") || text.contains("crypto") || text.contains("guaranteed") || text.contains("doble ang pera") || text.contains("kumita")) {
      if (text.contains("returns") || text.contains("tuyo") || text.contains("kita") || text.contains("easy money")) {
        return {
          "riskLevel": "Mataas",
          "reasoning": "Mukhang investment scam o Ponzi scheme na nangangako ng mabilis at malaking kita na hindi makatotohanan.",
          "recommendedAction": "Iwasan ang pagbibigay ng pera sa mga hindi rehistradong investment platforms."
        };
      }
    }

    // 5. Normal friendly or family pattern checks (Mababa risk)
    if (text.contains("mama") || text.contains("salamat") || text.contains("bukas") || text.contains("kumain") || text.contains("gamot") || text.contains("kamusta")) {
      return {
        "riskLevel": "Mababa",
        "reasoning": "Karaniwang mensahe mula sa pamilya o kaibigan na walang nakikitang senyales ng panloloko.",
        "recommendedAction": "Ligtas itong sagutin."
      };
    }

    // Default Katamtaman/Caution for ambiguous text
    return {
      "riskLevel": "Katamtaman",
      "reasoning": "Hindi namin matukoy nang lubusan kung ito ay ligtas. Mag-ingat kung ang mensahe ay humihingi ng anumang aksyon o naglalaman ng link.",
      "recommendedAction": "Magtanong sa iyong Trusted Circle bago sumagot o gumawa ng aksyon."
    };
  }

  @override
  Future<String> generateWeeklySummary(String seniorName, List<CheckIn> weekCheckIns) async {
    if (weekCheckIns.isEmpty) {
      return "Wala kaming natanggap na check-in mula kay Lolo/Lola $seniorName ngayong linggo. Mas mabuting tawagan o kumustahin natin siya nang direkta.";
    }

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
