import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AnatoomiaMaster());
}

// Lubab hiirega lohistamist (swipe) veebis ja desktopis
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class AnatoomiaMaster extends StatelessWidget {
  const AnatoomiaMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Anatoomia Master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Avaleht(),
    );
  }
}

// --- ÜHINE TTS FUNKTSIOON ---
final FlutterTts globalTts = FlutterTts();

Future<void> seadistaTts() async {
  if (kIsWeb) return;
  try {
    await globalTts.setLanguage("et-EE");
    await globalTts.setPitch(1.0);
    await globalTts.setSpeechRate(0.5);
  } catch (e) {
    debugPrint("TTS seadistamise viga: $e");
  }
}

Future<void> loeTekst(String tekst, bool isLatin) async {
  if (kIsWeb) return;

  String toodedTekst = tekst;
  if (!isLatin) {
    toodedTekst = toodedTekst
        .replaceAll('C1', 'kaelalüli üks')
        .replaceAll('C2', 'kaelalüli kaks')
        .replaceAll('C3', 'kaelalüli kolm')
        .replaceAll('C4', 'kaelalüli neli')
        .replaceAll('C5', 'kaelalüli viis')
        .replaceAll('C6', 'kaelalüli kuus')
        .replaceAll('C7', 'kaelalüli seitse')
        .replaceAll('L1', 'nimmelüli üks')
        .replaceAll('L2', 'nimmelüli kaks')
        .replaceAll('L3', 'nimmelüli kolm')
        .replaceAll('L4', 'nimmelüli neli')
        .replaceAll('L5', 'nimmelüli viis')
        .replaceAll('GH', 'õlaliigese')
        .replaceAll('post.', 'tagumine')
        .replaceAll('ant.', 'eesmine')
        .replaceAll('dist.', 'kaugmine');
  }

  try {
    if (isLatin) {
      bool supportsLatin = await globalTts.isLanguageAvailable("la") ?? false;
      await globalTts.setLanguage(supportsLatin ? "la" : "et-EE");
    } else {
      await globalTts.setLanguage("et-EE");
    }
    await globalTts.speak(toodedTekst);
  } catch (e) {
    debugPrint("Hääldamise viga: $e");
  }
}

class Avaleht extends StatefulWidget {
  const Avaleht({super.key});
  @override
  State<Avaleht> createState() => _AvalehtState();
}

class _AvalehtState extends State<Avaleht> {
  List<List<String>> _andmed = [];

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) seadistaTts();
    _laeAndmedVaikselt();
  }

  void _laeAndmedVaikselt() async {
    try {
      final sisu = await rootBundle.loadString('assets/andmed.csv');
      List<List<dynamic>> tabel = const CsvToListConverter(fieldDelimiter: ';').convert(sisu);
      List<List<String>> puhastatud = [];
      for (var rida in tabel) {
        if (rida.isNotEmpty && rida[0].toString().trim().isNotEmpty) {
          puhastatud.add(rida.map((cell) => cell.toString().trim()).toList());
        }
      }
      if (puhastatud.isNotEmpty && puhastatud[0][0].toLowerCase().contains('fail')) {
        puhastatud.removeAt(0);
      }
      setState(() { _andmed = puhastatud; });
    } catch (e) {
      debugPrint("Viga: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anatoomia Master"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _menuuNupp(context, "ÕPPIMINE", Colors.green.shade100, const Manguekraan(isExam: false)),
              const SizedBox(height: 30),
              _menuuNupp(context, "EKSAM (20)", Colors.orange.shade100, const Manguekraan(isExam: true)),
              const SizedBox(height: 30),
              _menuuNupp(context, "SIRVIMINE", Colors.blue.shade100, SirvimisEkraan(andmed: _andmed)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuuNupp(BuildContext context, String tekst, Color varv, Widget sihtkoht) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size(320, 90), backgroundColor: varv),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => sihtkoht)),
      child: Text(tekst, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }
}

class SirvimisEkraan extends StatefulWidget {
  final List<List<String>> andmed;
  const SirvimisEkraan({super.key, required this.andmed});

  @override
  State<SirvimisEkraan> createState() => _SirvimisEkraanState();
}

class _SirvimisEkraanState extends State<SirvimisEkraan> {
  late List<List<String>> _filtreeritudAndmed;
  final TextEditingController _otsinguController = TextEditingController();
  final PageController _pageController = PageController();
  bool _onOtsing = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _filtreeritudAndmed = widget.andmed;
  }

  void _filtreeri(String vaartus) {
    setState(() {
      _filtreeritudAndmed = widget.andmed
          .where((lihas) =>
      lihas[0].toLowerCase().contains(vaartus.toLowerCase()) ||
          lihas[1].toLowerCase().contains(vaartus.toLowerCase()))
          .toList();
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.andmed.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    bool isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: _onOtsing
            ? TextField(
          controller: _otsinguController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Otsi lihast...", border: InputBorder.none),
          onChanged: _filtreeri,
        )
            : const Text("Lihaste entsüklopeedia"),
        actions: [
          IconButton(
            icon: Icon(_onOtsing ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _onOtsing = !_onOtsing;
                if (!_onOtsing) {
                  _otsinguController.clear();
                  _filtreeritudAndmed = widget.andmed;
                }
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          _filtreeritudAndmed.isEmpty
              ? const Center(child: Text("Lihast ei leitud", style: TextStyle(fontSize: 20)))
              : PageView.builder(
            controller: _pageController,
            itemCount: _filtreeritudAndmed.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final lihas = _filtreeritudAndmed[index];

              Widget infoSisu = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${index + 1} / ${_filtreeritudAndmed.length}", style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(lihas[0],
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            textAlign: TextAlign.center),
                      ),
                      if (!kIsWeb)
                        IconButton(
                          icon: const Icon(Icons.volume_up, size: 40, color: Colors.deepPurple),
                          onPressed: () => loeTekst(lihas[0], true),
                        ),
                    ],
                  ),
                  Text(lihas[1], style: const TextStyle(fontSize: 26, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                  const Divider(height: 40),
                  _infoRida("ALGUSKOHT (A)", lihas[2]),
                  _infoRida("KINNITUSKOHT (K)", lihas[3]),
                  _infoRida("FUNKTSIOON (F)", lihas[4]),
                ],
              );

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isWide
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: SizedBox(height: 500, child: leiaPiltGlobaalne(lihas[0]))),
                      const SizedBox(width: 40),
                      Expanded(flex: 1, child: infoSisu),
                    ],
                  )
                      : Column(
                    children: [
                      SizedBox(height: 300, child: leiaPiltGlobaalne(lihas[0])),
                      const SizedBox(height: 15),
                      infoSisu,
                      const SizedBox(height: 40),
                      const Text("← Libista küljele või kasuta nooli →", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_currentPage > 0)
            Positioned(
              left: 10,
              top: MediaQuery.of(context).size.height / 2 - 50,
              child: CircleAvatar(
                backgroundColor: Colors.deepPurple.withAlpha(128),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                ),
              ),
            ),
          if (_currentPage < _filtreeritudAndmed.length - 1)
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height / 2 - 50,
              child: CircleAvatar(
                backgroundColor: Colors.deepPurple.withAlpha(128),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRida(String tiitel, String tekst) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(tiitel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepPurple)),
              const Spacer(),
              if (!kIsWeb)
                IconButton(
                  icon: const Icon(Icons.play_circle_outline, color: Colors.blue),
                  onPressed: () => loeTekst(tekst, false),
                )
            ],
          ),
          Text(tekst, style: const TextStyle(fontSize: 20)),
          const Divider(color: Colors.black12),
        ],
      ),
    );
  }
}

Widget leiaPiltGlobaalne(String nimi) {
  String puhas = nimi.replaceAll(RegExp(r'^[mitaluMITALU]+\.\s*'), '').trim();
  List<String> proovid = [
    'assets/pildid/m.$puhas.png',
    'assets/pildid/mm.$puhas.png',
    'assets/pildid/M.$puhas.png',
    'assets/pildid/$puhas.png',
    'assets/pildid/m. $puhas.png',
    'assets/pildid/M. $puhas.png',
    'assets/pildid/mm. $puhas.png',
    'assets/pildid/M.quadriceps femoris.png',
    'assets/pildid/kasivarre painutajalihased.png',
    'assets/pildid/kasivarre sirutajalihased.png',
  ];

  return _prooviPilte(proovid, 0);
}

Widget _prooviPilte(List<String> teed, int indeks) {
  if (indeks >= teed.length) {
    return const Center(child: Icon(Icons.broken_image, size: 80, color: Colors.red));
  }
  return Image.asset(
    teed[indeks],
    fit: BoxFit.contain,
    errorBuilder: (c, e, s) => _prooviPilte(teed, indeks + 1),
  );
}

class Manguekraan extends StatefulWidget {
  final bool isExam;
  const Manguekraan({super.key, required this.isExam});
  @override
  State<Manguekraan> createState() => _ManguekraanState();
}

class _ManguekraanState extends State<Manguekraan> {
  List<List<String>> _andmed = [];
  int _oigeIndeks = -1;
  List<String> _valikud = [];
  final Set<String> _valedVastused = {};
  bool _laetud = false;
  int _faas = 0;
  int _eksamiProgress = 0;
  List<int> _eksamiJarjekord = [];
  Timer? _timer;
  int _aegSekundites = 1800;
  final List<int> _oigedStats = [0, 0, 0, 0];
  final List<int> _valedStats = [0, 0, 0, 0];
  bool _faasisTehtudViga = false;

  @override
  void initState() {
    super.initState();
    _laeAndmed();
    if (widget.isExam) _alustaTaimerit();
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  Future<void> _salvestaViga(String lihaseNimi) async {
    final prefs = await SharedPreferences.getInstance();
    int praegusedVead = prefs.getInt(lihaseNimi) ?? 0;
    await prefs.setInt(lihaseNimi, praegusedVead + 1);
  }

  void _alustaTaimerit() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_aegSekundites > 0) { if (mounted) setState(() => _aegSekundites--); }
      else { _timer?.cancel(); _naitaLopuStatistikat(); }
    });
  }

  void _laeAndmed() async {
    try {
      final sisu = await rootBundle.loadString('assets/andmed.csv');
      List<List<dynamic>> tabel = const CsvToListConverter(fieldDelimiter: ';').convert(sisu);
      List<List<String>> puhastatud = [];
      for (var rida in tabel) { if (rida.isNotEmpty && rida[0].toString().trim().isNotEmpty) puhastatud.add(rida.map((cell) => cell.toString().trim()).toList()); }
      setState(() {
        _andmed = puhastatud;
        if (_andmed.isNotEmpty && _andmed[0][0].toLowerCase().contains('fail')) _andmed.removeAt(0);
        if (widget.isExam) {
          _eksamiJarjekord = List.generate(_andmed.length, (i) => i)..shuffle();
          _eksamiJarjekord = _eksamiJarjekord.sublist(0, min(20, _andmed.length));
        }
        _laetud = true;
        _uusKysimus();
      });
    } catch (e) { debugPrint("Viga: $e"); }
  }

  void _uusKysimus() {
    setState(() {
      _faas = 0; _faasisTehtudViga = false;
      if (widget.isExam) { if (_eksamiProgress >= _eksamiJarjekord.length) { _timer?.cancel(); _naitaLopuStatistikat(); return; } _oigeIndeks = _eksamiJarjekord[_eksamiProgress]; }
      else { _oigeIndeks = Random().nextInt(_andmed.length); }
      _genereeriValikud();
    });
  }

  void _genereeriValikud() {
    int tulp = _faas == 0 ? 0 : (_faas + 1);
    String oige = _andmed[_oigeIndeks][tulp];
    List<String> uued = [oige];
    List<String> koik = _andmed.map((r) => r[tulp]).toSet().toList()..remove(oige)..shuffle();
    for (var v in koik) { if (uued.length < 3) uued.add(v); }
    uued.shuffle();
    setState(() { _valikud = uued; _valedVastused.clear(); });
  }

  void _kontrolliVastust(String v) {
    int tulp = _faas == 0 ? 0 : (_faas + 1);
    String oige = _andmed[_oigeIndeks][tulp];
    if (v == oige) {
      if (!_faasisTehtudViga) _oigedStats[_faas]++;
      if (widget.isExam && !kIsWeb) loeTekst(oige, _faas == 0);
      if (_faas < 3) { setState(() { _faas++; _faasisTehtudViga = false; _genereeriValikud(); }); }
      else { if (widget.isExam) { _eksamiProgress++; _uusKysimus(); } else { _naitaViduSonumit(); } }
    } else {
      setState(() {
        if (!_faasisTehtudViga) {
          _valedStats[_faas]++;
          _faasisTehtudViga = true;
          if (_faas == 0) {
            _salvestaViga(_andmed[_oigeIndeks][0]);
          }
        }
        _valedVastused.add(v);
      });
    }
  }

  void _naitaLopuStatistikat() {
    int kokkuOigeid = _oigedStats.reduce((a, b) => a + b);
    double protsent = (kokkuOigeid / 80) * 100;
    showDialog(context: context, barrierDismissible: false, builder: (c) => AlertDialog(title: const Text("EKSAM LÄBI!"), content: Text("Tulemus: ${protsent.toStringAsFixed(1)}%"), actions: [ElevatedButton(onPressed: () { Navigator.pop(c); Navigator.pop(context); }, child: const Text("OK"))]));
  }

  void _naitaViduSonumit() {
    showDialog(context: context, barrierDismissible: false, builder: (c) => AlertDialog(title: const Text("ÕIGE! 🎉"), actions: [TextButton(onPressed: () { Navigator.pop(c); _uusKysimus(); }, child: const Text("EDASI"))]));
  }

  @override
  Widget build(BuildContext context) {
    if (!_laetud) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final lihas = _andmed[_oigeIndeks];
    bool isWide = MediaQuery.of(context).size.width > 800;

    Widget sisu = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (_faas > 0) Text(lihas[1], style: TextStyle(fontSize: isWide ? 40 : 34, fontWeight: FontWeight.bold, color: Colors.deepPurple), textAlign: TextAlign.center),
      const SizedBox(height: 10),
      Text(["Mis lihas see on?", "ALGUSKOHT (A)?", "KINNITUSKOHT (K)?", "FUNKTSIOON (F)?"][_faas], style: TextStyle(fontSize: isWide ? 32 : 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      const SizedBox(height: 20),
      ..._valikud.map((v) {
        bool onVale = _valedVastused.contains(v);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, isWide ? 90 : 75),
              backgroundColor: onVale ? Colors.red : null,
              disabledBackgroundColor: onVale ? Colors.red : null
            ),
            onPressed: onVale ? null : () => _kontrolliVastust(v),
            child: Text(_faas == 0 && !v.toLowerCase().startsWith('m.') ? "m. $v" : v, style: TextStyle(fontSize: isWide ? 26 : 22), textAlign: TextAlign.center)
          )
        );
      }),
    ]);

    return Scaffold(
      appBar: AppBar(title: Text(widget.isExam ? "EKSAM: ${_eksamiProgress + 1}/20" : "ÕPPIMINE"), actions: [
        if (!widget.isExam && !kIsWeb) IconButton(icon: const Icon(Icons.volume_up, size: 35), onPressed: () => loeTekst(_faas == 0 ? lihas[0] : lihas[_faas + 1], _faas == 0)),
        if (widget.isExam) Center(child: Padding(padding: const EdgeInsets.only(right: 15), child: Text("${_aegSekundites ~/ 60}:${(_aegSekundites % 60).toString().padLeft(2, '0')}", style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold)))),
      ]),
      body: isWide ? Row(children: [Expanded(flex: 2, child: leiaPiltGlobaalne(lihas[0])), Expanded(flex: 1, child: sisu)]) : Column(children: [Expanded(flex: 3, child: leiaPiltGlobaalne(lihas[0])), Expanded(flex: 4, child: SingleChildScrollView(child: sisu))]),
    );
  }
}
