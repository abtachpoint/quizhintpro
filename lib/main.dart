import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizHintProApp());
}

class QuizHintProApp extends StatelessWidget {
  const QuizHintProApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Quiz Hint Pro',
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF673AB7),
    ),
    home: const QuizHintHome(),
  );
}

class Q {
  final String text, hint;
  final List<String> options;
  final int answer;
  const Q(this.text, this.options, this.answer, this.hint);
}

const qs = <Q>[
  Q('Which planet is known as the Red Planet?', ['Earth','Mars','Jupiter','Venus'], 1, 'It is the fourth planet from the Sun.'),
  Q('What is the capital of Japan?', ['Seoul','Tokyo','Beijing','Bangkok'], 1, 'It is Japan’s largest city.'),
  Q('How many continents are there?', ['5','6','7','8'], 2, 'The number is one more than six.'),
  Q('Which gas do plants mainly absorb?', ['Oxygen','Nitrogen','Carbon dioxide','Hydrogen'], 2, 'Plants use it during photosynthesis.'),
  Q('Which ocean is the largest?', ['Atlantic','Indian','Pacific','Arctic'], 2, 'It lies between Asia and the Americas.'),
  Q('How many days are in a leap year?', ['364','365','366','367'], 2, 'A leap year adds one day to February.'),
  Q('What is H2O commonly called?', ['Salt','Water','Oxygen','Hydrogen'], 1, 'You drink it every day.'),
  Q('Which shape has three sides?', ['Square','Circle','Triangle','Rectangle'], 2, 'Its name starts with “tri”.'),
  Q('Which animal is the fastest on land?', ['Lion','Cheetah','Horse','Tiger'], 1, 'It is a spotted big cat.'),
  Q('Which instrument measures temperature?', ['Barometer','Thermometer','Compass','Scale'], 1, 'Its name starts with “thermo”.'),
  Q('How many hours are in one day?', ['12','18','24','30'], 2, 'Two groups of twelve.'),
  Q('Which direction is opposite to north?', ['East','West','South','Up'], 2, 'It is at the bottom of most maps.'),
  Q('Which organ pumps blood around the body?', ['Lung','Heart','Kidney','Stomach'], 1, 'You can feel it beating in your chest.'),
  Q('Which of these is a primary color in the RGB color model?', ['Green','Purple','Blue','Orange'], 2, 'Think of the three colors used by digital screens.'),
  Q('Which device is mainly used to take photographs?', ['Camera','Printer','Router','Speaker'], 0, 'Most phones have one or more of these.'),
  Q('Which number comes immediately after 99?', ['98','100','101','109'], 1, 'It is the first three-digit number.'),
  Q('Which season normally follows spring in a four-season calendar?', ['Winter','Autumn','Summer','Monsoon'], 2, 'It is usually the warmest season.'),
  Q('What is the opposite of “ancient”?', ['Old','Historic','Modern','Past'], 2, 'Think of something current or new.'),
  Q('Which month normally has 28 days in a common year?', ['February','April','June','September'], 0, 'It is the second month of the year.'),
  Q('Which animal is the largest living land animal?', ['Giraffe','Elephant','Rhino','Hippo'], 1, 'It has a trunk.'),
  Q('Which planet is the largest in our Solar System?', ['Earth','Mars','Jupiter','Saturn'], 2, 'It is a gas giant with a famous Great Red Spot.'),
  Q('What is the closest star to Earth?', ['Sirius','Polaris','The Sun','Betelgeuse'], 2, 'Earth orbits this star.'),
  Q('What is Earth’s natural satellite called?', ['Moon','Mars','Venus','Titan'], 0, 'It is visible in the night sky in different phases.'),
  Q('At standard sea-level pressure, water boils at what temperature in Celsius?', ['0°C','50°C','100°C','150°C'], 2, 'This is the standard boiling point used in basic science.'),
  Q('At standard pressure, water freezes at what temperature in Celsius?', ['0°C','10°C','32°C','100°C'], 0, 'It is the starting point of the Celsius scale.'),
  Q('How many days are in one week?', ['5','6','7','8'], 2, 'Count from Monday through Sunday.'),
  Q('How many months are in one year?', ['10','11','12','13'], 2, 'A calendar year is divided into this many named months.'),
  Q('How many minutes are in one hour?', ['30','45','60','90'], 2, 'A clock hour contains four quarters of 15 minutes.'),
  Q('How many meters are in one kilometer?', ['100','500','1000','1500'], 2, 'The prefix “kilo” means one thousand.'),
  Q('How many centimeters are in one meter?', ['10','50','100','1000'], 2, 'A centimeter is one hundredth of a meter.'),
  Q('What is the capital of France?', ['Madrid','Paris','Rome','Berlin'], 1, 'The Eiffel Tower is located there.'),
  Q('What is the capital of Italy?', ['Milan','Venice','Rome','Naples'], 2, 'The Colosseum is located there.'),
  Q('What is the capital of Australia?', ['Sydney','Melbourne','Canberra','Perth'], 2, 'It is not Australia’s largest city.'),
  Q('What is the capital of Canada?', ['Toronto','Vancouver','Ottawa','Montreal'], 2, 'It is located in Ontario.'),
  Q('What is the capital of Egypt?', ['Cairo','Alexandria','Giza','Luxor'], 0, 'It is Egypt’s largest metropolitan area.'),
  Q('On which continent is the Nile River primarily located?', ['Asia','Africa','Europe','South America'], 1, 'The river flows through northeastern Africa.'),
  Q('On which continent is the Sahara Desert located?', ['Africa','Asia','Australia','Europe'], 0, 'It stretches across the northern part of this continent.'),
  Q('Which mountain has the highest elevation above sea level?', ['K2','Kangchenjunga','Mount Everest','Lhotse'], 2, 'It lies in the Himalayas.'),
  Q('Which is the world’s largest hot desert?', ['Gobi','Sahara','Kalahari','Atacama'], 1, 'It covers much of North Africa.'),
  Q('India is part of which continent?', ['Africa','Asia','Europe','South America'], 1, 'It is in South Asia.'),
  Q('What is a five-sided polygon called?', ['Triangle','Pentagon','Hexagon','Octagon'], 1, 'The prefix “penta” means five.'),
  Q('What is a six-sided polygon called?', ['Pentagon','Hexagon','Heptagon','Octagon'], 1, 'The prefix “hexa” means six.'),
  Q('What is an eight-sided polygon called?', ['Hexagon','Heptagon','Octagon','Nonagon'], 2, 'The prefix “octa” refers to eight.'),
  Q('How many degrees are in a right angle?', ['45°','60°','90°','180°'], 2, 'It is one quarter of a full turn.'),
  Q('What is 9 × 8?', ['63','72','81','88'], 1, 'Think of eight groups of nine.'),
  Q('What is 12 × 12?', ['124','132','144','154'], 2, 'It is twelve groups of twelve.'),
  Q('What is 100 ÷ 4?', ['20','25','40','50'], 1, 'Split 100 into four equal groups.'),
  Q('What is half of 50?', ['15','20','25','30'], 2, 'Divide 50 by two.'),
  Q('What is 15 + 27?', ['32','40','42','52'], 2, 'Add 20 to 15, then add the remaining 7.'),
  Q('What is 100 − 37?', ['53','63','67','73'], 1, 'Subtract 30 first, then subtract 7.'),
  Q('How many letters are in the English alphabet?', ['24','25','26','27'], 2, 'It begins with A and ends with Z.'),
  Q('Which letter is a vowel?', ['B','D','A','T'], 2, 'English has the vowels A, E, I, O and U.'),
  Q('What is the plural form of “child”?', ['Childs','Children','Childes','Childrens'], 1, 'This word has an irregular plural.'),
  Q('What is the opposite of “hot”?', ['Warm','Cold','Dry','Bright'], 1, 'Think of a low temperature.'),
  Q('Which word is closest in meaning to “quick”?', ['Slow','Fast','Heavy','Quiet'], 1, 'It describes something moving rapidly.'),
  Q('What is the past tense of “go”?', ['Goed','Gone','Went','Going'], 2, 'It is an irregular past-tense form.'),
  Q('Which is the first month of the year?', ['December','January','March','June'], 1, 'New Year’s Day is in this month.'),
  Q('Which is the last month of the year?', ['October','November','December','January'], 2, 'Christmas is in this month.'),
  Q('How many days are in April?', ['28','29','30','31'], 2, 'Remember the rhyme: thirty days hath September, April, June and November.'),
  Q('How many days are in February in a common year?', ['27','28','29','30'], 1, 'Leap years add one extra day.'),
  Q('How many colors are traditionally listed in a rainbow?', ['5','6','7','8'], 2, 'A common mnemonic is ROYGBIV.'),
  Q('What mainly causes day and night on Earth?', ['Earth’s rotation','Earth’s revolution','The Moon’s orbit','Cloud movement'], 0, 'Earth spins once roughly every 24 hours.'),
  Q('About how long does Earth take to orbit the Sun?', ['One day','One week','One month','One year'], 3, 'This motion defines the length of a year.'),
  Q('Mixing blue and yellow paint usually produces which color?', ['Green','Purple','Orange','Brown'], 0, 'Think of basic subtractive color mixing.'),
  Q('Which of these animals is a mammal?', ['Shark','Whale','Trout','Octopus'], 1, 'It breathes air and nurses its young.'),
  Q('Which bird is famous for being unable to fly?', ['Eagle','Sparrow','Ostrich','Falcon'], 2, 'It is a very large running bird.'),
  Q('What is the largest living mammal?', ['African elephant','Blue whale','Giraffe','Hippopotamus'], 1, 'It lives in the ocean.'),
  Q('What is a young frog called?', ['Calf','Tadpole','Cub','Chick'], 1, 'It begins life in water with a tail.'),
  Q('Which insect is best known for making honey?', ['Ant','Bee','Butterfly','Dragonfly'], 1, 'It lives in colonies with a queen.'),
  Q('How many legs does a spider have?', ['6','8','10','12'], 1, 'Spiders are arachnids, not insects.'),
  Q('How many legs does a typical adult insect have?', ['4','6','8','10'], 1, 'Insects have three pairs of legs.'),
  Q('How many bones are typically in an adult human skeleton?', ['106','206','306','406'], 1, 'The commonly taught adult count is just over two hundred.'),
  Q('Which organs are mainly responsible for breathing?', ['Kidneys','Lungs','Liver','Stomach'], 1, 'They exchange oxygen and carbon dioxide.'),
  Q('Which organs primarily filter waste from the blood to make urine?', ['Lungs','Kidneys','Heart','Pancreas'], 1, 'Humans normally have two of these bean-shaped organs.'),
  Q('Which vitamin is commonly associated with sunlight exposure?', ['Vitamin A','Vitamin C','Vitamin D','Vitamin K'], 2, 'Skin can produce it after exposure to sunlight.'),
  Q('Which metal is strongly attracted to ordinary magnets?', ['Iron','Gold','Aluminum','Copper'], 0, 'It is a common ferromagnetic metal.'),
  Q('What is the solid form of water called?', ['Steam','Ice','Mist','Dew'], 1, 'It forms when water freezes.'),
  Q('What is water vapor?', ['Solid water','Gaseous water','Frozen water','Salt water'], 1, 'It is water in the gas phase.'),
  Q('Which unit is commonly used to measure sound level?', ['Volt','Decibel','Meter','Liter'], 1, 'The abbreviation is dB.'),
  Q('What is the SI unit of electric current?', ['Volt','Watt','Ampere','Ohm'], 2, 'Its symbol is A.'),
  Q('What does CPU stand for?', ['Central Processing Unit','Computer Power Utility','Core Program User','Central Print Unit'], 0, 'It is the main processing component in a computer.'),
  Q('What does URL stand for?', ['Universal Read Link','Uniform Resource Locator','User Routing Line','Unified Remote Location'], 1, 'It identifies the address of a resource on the web.'),
  Q('Which of these is primarily an input device?', ['Monitor','Speaker','Keyboard','Projector'], 2, 'It is used to type letters and commands.'),
  Q('Which of these is primarily an output device?', ['Keyboard','Mouse','Monitor','Microphone'], 2, 'It displays visual information from a computer.'),
  Q('How many bits are in one byte?', ['4','8','16','32'], 1, 'A byte is made from a small fixed group of binary digits.'),
  Q('What does WWW stand for?', ['World Wide Web','World Web Window','Wide World Wire','Web World Work'], 0, 'It refers to the system of linked web pages.'),
  Q('Which company develops the Android operating system?', ['Apple','Google','Nintendo','Adobe'], 1, 'The same company operates Google Play.'),
  Q('Which company makes the iPhone?', ['Samsung','Google','Apple','Microsoft'], 2, 'Its logo is a bitten fruit.'),
  Q('What does GPS stand for?', ['Global Positioning System','General Path Service','Geo Place Signal','Global Phone System'], 0, 'It is a satellite-based positioning system.'),
  Q('What does PDF stand for?', ['Portable Document Format','Personal Data File','Printed Document Form','Public Display File'], 0, 'It is a common document file format.'),
  Q('What does a red traffic light normally mean?', ['Go','Stop','Turn only','Speed up'], 1, 'It tells drivers to wait.'),
  Q('What does a green traffic light normally mean?', ['Stop','Go when safe','Reverse','Park'], 1, 'It permits traffic to proceed when the way is clear.'),
  Q('A compass needle generally aligns with which directions?', ['East–West','North–South','Up–Down','Left–Right'], 1, 'A compass is used to find north.'),
  Q('In which direction does the Sun appear to rise?', ['North','South','East','West'], 2, 'Earth’s rotation makes sunrise appear on this side of the horizon.'),
  Q('In which direction does the Sun appear to set?', ['North','South','East','West'], 3, 'It is opposite the usual sunrise direction.'),
  Q('How many squares are on a standard chessboard?', ['36','49','64','81'], 2, 'The board has 8 rows and 8 columns.'),
  Q('How many players from one team are normally on the field in association football (soccer)?', ['9','10','11','12'], 2, 'This count includes the goalkeeper.'),
  Q('How many rings are on the Olympic symbol?', ['4','5','6','7'], 1, 'The symbol uses five interlocking rings.'),
  Q('How many points is a successful free throw worth in basketball?', ['1','2','3','4'], 0, 'A free throw is the lowest-value standard scoring shot.'),
  Q('How many items are in one dozen?', ['10','11','12','13'], 2, 'A dozen is a common counting group.'),
];

class Pack {
  final String id, tier;
  final int credits;
  const Pack(this.id, this.credits, this.tier);
}

const packs = <Pack>[
  Pack('credits_5', 5, r'$0.51'),
  Pack('credits_10', 10, r'$1.01'),
  Pack('credits_20', 20, r'$2.01'),
  Pack('credits_30', 30, r'$3.01'),
  Pack('credits_40', 40, r'$4.01'),
  Pack('credits_50', 50, r'$5.01'),
  Pack('credits_60', 60, r'$6.01'),
  Pack('credits_70', 70, r'$7.01'),
  Pack('credits_80', 80, r'$8.01'),
  Pack('credits_90', 90, r'$9.01'),
  Pack('credits_100', 100, r'$10.01'),
];

class QuizHintHome extends StatefulWidget {
  const QuizHintHome({super.key});
  @override
  State<QuizHintHome> createState() => _QuizHintHomeState();
}

class _QuizHintHomeState extends State<QuizHintHome> {
  final iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? sub;

  final Map<String, ProductDetails> products = {};
  final Set<String> processed = {};

  late List<int> questionOrder;

  int credits = 0;
  int qi = 0;
  int score = 0;
  int? selected;

  bool answered = false;
  bool loading = true;
  bool storeAvailable = false;

  String? hint;
  String? storeMessage;

  @override
  void initState() {
    super.initState();
    questionOrder = List<int>.generate(qs.length, (i) => i)..shuffle();
    init();
  }

  Q get currentQuestion => qs[questionOrder[qi]];

  Future<void> init() async {
    final p = await SharedPreferences.getInstance();

    if (!p.containsKey('credits')) {
      await p.setInt('credits', 3);
    }
    credits = p.getInt('credits') ?? 3;

    processed.addAll(
      p.getStringList('processed_purchase_ids') ?? [],
    );

    sub = iap.purchaseStream.listen(
      handlePurchases,
      onError: (_) {
        if (mounted) {
          setState(() => storeMessage = 'Purchase update failed.');
        }
      },
    );

    await loadProducts();

    if (mounted) setState(() {});
  }

  Future<void> saveCredits() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('credits', credits);
  }

  Future<void> saveProcessed() async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(
      'processed_purchase_ids',
      processed.toList(),
    );
  }

  Future<void> loadProducts() async {
    try {
      storeAvailable = await iap.isAvailable();

      if (!storeAvailable) {
        loading = false;
        storeMessage = 'Google Play Billing is unavailable in this build.';
        if (mounted) setState(() {});
        return;
      }

      final r = await iap.queryProductDetails(
        packs.map((e) => e.id).toSet(),
      );

      products
        ..clear()
        ..addEntries(
          r.productDetails.map((e) => MapEntry(e.id, e)),
        );

      loading = false;

      storeMessage = products.isEmpty
          ? 'Credit packs will appear after you create these product IDs in Play Console.'
          : (r.notFoundIDs.isNotEmpty
              ? 'Some credit packs are not active yet.'
              : null);

      if (mounted) setState(() {});
    } catch (_) {
      loading = false;
      storeMessage = 'Could not load Google Play products.';
      if (mounted) setState(() {});
    }
  }

  Pack? findPack(String id) {
    for (final p in packs) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> handlePurchases(
    List<PurchaseDetails> list,
  ) async {
    for (final x in list) {
      if (x.status == PurchaseStatus.pending) {
        if (mounted) {
          setState(() => storeMessage = 'Purchase pending…');
        }
        continue;
      }

      if (x.status == PurchaseStatus.error) {
        if (mounted) {
          setState(() => storeMessage = 'Purchase failed.');
        }
      }

      if (x.status == PurchaseStatus.purchased ||
          x.status == PurchaseStatus.restored) {
        final p = findPack(x.productID);
        final key = x.purchaseID ??
            '${x.productID}:${x.transactionDate ?? ''}';

        if (p != null && !processed.contains(key)) {
          processed.add(key);
          credits += p.credits;

          await saveCredits();
          await saveProcessed();

          if (mounted) {
            setState(
              () => storeMessage = '${p.credits} credits added.',
            );
          }
        }
      }

      if (x.pendingCompletePurchase) {
        await iap.completePurchase(x);
      }
    }
  }

  Future<void> buy(Pack p) async {
    final product = products[p.id];

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This pack is not active in Google Play yet.',
          ),
        ),
      );
      return;
    }

    await iap.buyConsumable(
      purchaseParam: PurchaseParam(
        productDetails: product,
      ),
      autoConsume: true,
    );
  }

  Future<void> useHint() async {
    if (hint != null) return;

    if (credits <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No credits left. Open Shop to buy more.',
          ),
        ),
      );
      return;
    }

    setState(() {
      credits--;
      hint = currentQuestion.hint;
    });

    await saveCredits();
  }

  void answer(int i) {
    if (answered) return;

    setState(() {
      selected = i;
      answered = true;

      if (i == currentQuestion.answer) {
        score++;
      }
    });
  }

  void next() {
    setState(() {
      if (qi + 1 >= questionOrder.length) {
        questionOrder.shuffle();
        qi = 0;
        score = 0;
      } else {
        qi++;
      }

      selected = null;
      answered = false;
      hint = null;
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz Hint Pro',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: const Icon(
                Icons.stars_rounded,
                size: 18,
              ),
              label: Text(
                '$credits',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
        bottom: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.quiz_outlined),
              text: 'Quiz',
            ),
            Tab(
              icon: Icon(Icons.shopping_bag_outlined),
              text: 'Shop',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          quizTab(),
          shopTab(),
        ],
      ),
    ),
  );

  Widget quizTab() {
    final q = currentQuestion;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Question ${qi + 1} of ${qs.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text('Score: $score'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (qi + 1) / qs.length,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                q.text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            for (int i = 0; i < q.options.length; i++) ...[
              answerButton(q, i),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            OutlinedButton.icon(
              onPressed: hint == null ? useHint : null,
              icon: const Icon(Icons.lightbulb_outline),
              label: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                child: Text(
                  hint == null
                      ? 'Use 1 Credit for Hint'
                      : 'Hint Revealed',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            if (hint != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(hint!),
                    ),
                  ],
                ),
              ),
            ],
            if (answered) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: next,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  child: Text(
                    'Next Question',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Text(
              '100 quiz questions • questions are shuffled each round • first launch includes 3 complimentary credits • each hint uses 1 credit.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget answerButton(Q q, int i) {
    Color? bg, fg;

    if (answered) {
      if (i == q.answer) {
        bg = Colors.green.shade100;
        fg = Colors.green.shade900;
      } else if (selected == i) {
        bg = Colors.red.shade100;
        fg = Colors.red.shade900;
      }
    }

    return FilledButton.tonal(
      onPressed: answered ? null : () => answer(i),
      style: FilledButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        alignment: Alignment.centerLeft,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            child: Text(
              String.fromCharCode(65 + i),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              q.options[i],
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shopTab() => SafeArea(
    child: RefreshIndicator(
      onRefresh: loadProducts,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.stars_rounded,
                  size: 46,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Credits: $credits',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Need help with a question?\nUse 1 credit to reveal a hint.\nNew users get 3 free credits.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (storeMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                storeMessage!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),
          ],
          for (final p in packs) packTile(p),
        ],
      ),
    ),
  );

  Widget packTile(Pack p) {
    final product = products[p.id];
    final enabled = storeAvailable && product != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.stars_rounded),
        ),
        title: Text(
          '${p.credits} Credits',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        trailing: FilledButton(
          onPressed: enabled ? () => buy(p) : null,
          child: Text(
            product?.price ?? 'Not active',
          ),
        ),
      ),
    );
  }
}
