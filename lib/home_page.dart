import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:voice_asisstant_app/ai_service.dart';
import 'feature_box.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  FlutterTts flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Rhizicube')),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(children: [
                Center(
                  child: Container(
                      width: 110,
                      height: 110,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(26, 230, 179, 179),
                      )),
                ),
                Container(
                    height: 180,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/virtualAssistantSenior.png',
                          ),
                        )))
              ]),
            ),
            ZoomIn(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 50)
                      .copyWith(top: 10, bottom: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.lightBlue,
                      ),
                      borderRadius: BorderRadius.circular(20).copyWith(
                        topLeft: Radius.zero,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      generatedContent == null
                          ? 'Hello, Rhizicube is here with some AI tools to help you out in your tasks'
                          : generatedContent!,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: generatedContent == null ? 30 : 22,
                        fontFamily: 'Cera Pro',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(generatedImageUrl!),
                ),
              ),
            FadeInRight(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    top: 7,
                    left: 85,
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Here are some features',
                    style: TextStyle(
                      fontFamily: 'Cera pro',
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInRight(
                    delay: Duration(milliseconds: 200),
                    child: const Feature(
                      color: Colors.blue,
                      headerText: 'ChatGPT',
                      contentText: 'Smarter AI chatbot solutions',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: 400),
                    child: Feature(
                      color: Color.fromARGB(255, 95, 173, 238),
                      headerText: 'Dall-E',
                      contentText: 'Creative AI personal assistant',
                    ),
                  ),
                  SlideInRight(
                    delay: Duration(milliseconds: 600),
                    child: Feature(
                      color: Color.fromARGB(255, 6, 136, 243),
                      headerText: 'Smart Voice Assistant',
                      contentText: 'Personlised AI assistancepowered by voice',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ElasticIn(
        delay: Duration(milliseconds: 1000),
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedContent = null;
                generatedImageUrl = speech;

                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            } else {
              await initSpeechToText();
            }
          },
          backgroundColor: Colors.blue,
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
