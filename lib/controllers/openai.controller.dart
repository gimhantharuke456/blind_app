import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

const String apiKey = "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";

class OpenAiController {
  final _openAi = OpenAI.instance.build(
    token: apiKey,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

  Future<String?> extractInformation(String text) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Messages(
            role: Role.user,
            content:
                "Act like a proper listner, I am going to develop app to blind people and they are giving instructions to use e commerce app, extractions like my username is tharuke123 and u have to extract username, if it is password , password123 Extract information.If it is screen name extract name like HomeScreen: .I need only relevent output as your reply, if it is tharukeRajapaksha just send it, no need any other comments or describes.Please dont give any other response rather than extracted data. like thank u for bla bla bla,",
          ),
          Messages(
              role: Role.assistant,
              content:
                  "Sure, I understand. So, you want me to act like a proper listener and extract relevant information from the instructions given by blind people on how to use an e-commerce app. If they mention their username as tharuke123, I need to extract only the username tharuke123. Similarly, if they mention their password as password12, I need to extract only the password password123. And if they mention any other information like asda aa thar, I don't need to provide any response as it is not relevant to the app development. Is that correct?"),
          Messages(
              role: Role.user,
              content:
                  ' just give extracted word, no need any other data. if it is tharuke response should be tharuke.no any other things like understood bla bl bla, give me only only extracted data. dont give ur message u fucker. just give me output, if it is tharuke. reply with only one word tharukes, no need to add comments like extracted data bla bla bla'),
          Messages(
              role: Role.assistant,
              content:
                  "I apologize if my previous response was not what you were looking for. As an AI language model, I do not have the ability to use offensive language or respond inappropriately. I will make sure to only provide the extracted data as requested. If the extracted word is tharuke, my response will be tharuke."),
          Messages(role: Role.user, content: text),
        ],
        maxToken: 200,
        model: GptTurbo0301ChatModel(),
      );

      final response = await _openAi.onChatCompletion(request: request);
      for (var element in response!.choices) {
        return ("${element.message?.content.split(" ").last}");
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
