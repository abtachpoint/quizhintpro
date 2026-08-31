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
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF673AB7)),
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
];

class Pack {
  final String id, tier;
  final int credits;
  const Pack(this.id,this.credits,this.tier);
}
const packs = <Pack>[
  Pack('credits_10',10,r'$1'), Pack('credits_20',20,r'$2'), Pack('credits_30',30,r'$3'),
  Pack('credits_40',40,r'$4'), Pack('credits_50',50,r'$5'), Pack('credits_60',60,r'$6'),
  Pack('credits_70',70,r'$7'), Pack('credits_80',80,r'$8'), Pack('credits_90',90,r'$9'),
  Pack('credits_100',100,r'$10'),
];

class QuizHintHome extends StatefulWidget {
  const QuizHintHome({super.key});
  @override State<QuizHintHome> createState()=>_QuizHintHomeState();
}

class _QuizHintHomeState extends State<QuizHintHome> {
  final iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? sub;
  final Map<String,ProductDetails> products={};
  final Set<String> processed={};
  int credits=0, qi=0, score=0;
  int? selected;
  bool answered=false, loading=true, storeAvailable=false;
  String? hint, storeMessage;

  @override void initState(){super.initState(); init();}
  Future<void> init() async {
    final p=await SharedPreferences.getInstance();
    if(!p.containsKey('credits')) await p.setInt('credits',3);
    credits=p.getInt('credits')??3;
    processed.addAll(p.getStringList('processed_purchase_ids')??[]);
    sub=iap.purchaseStream.listen(handlePurchases,onError:(_){if(mounted)setState(()=>storeMessage='Purchase update failed.');});
    await loadProducts();
    if(mounted)setState((){});
  }
  Future<void> saveCredits() async => (await SharedPreferences.getInstance()).setInt('credits',credits);
  Future<void> saveProcessed() async => (await SharedPreferences.getInstance()).setStringList('processed_purchase_ids',processed.toList());

  Future<void> loadProducts() async {
    try{
      storeAvailable=await iap.isAvailable();
      if(!storeAvailable){loading=false;storeMessage='Google Play Billing is unavailable in this build.';if(mounted)setState((){});return;}
      final r=await iap.queryProductDetails(packs.map((e)=>e.id).toSet());
      products..clear()..addEntries(r.productDetails.map((e)=>MapEntry(e.id,e)));
      loading=false;
      storeMessage=products.isEmpty?'Credit packs will appear after you create these product IDs in Play Console.':(r.notFoundIDs.isNotEmpty?'Some credit packs are not active yet.':null);
      if(mounted)setState((){});
    }catch(_){loading=false;storeMessage='Could not load Google Play products.';if(mounted)setState((){});}
  }

  Pack? findPack(String id){for(final p in packs){if(p.id==id)return p;}return null;}
  Future<void> handlePurchases(List<PurchaseDetails> list) async {
    for(final x in list){
      if(x.status==PurchaseStatus.pending){if(mounted)setState(()=>storeMessage='Purchase pending…');continue;}
      if(x.status==PurchaseStatus.error){if(mounted)setState(()=>storeMessage='Purchase failed.');}
      if(x.status==PurchaseStatus.purchased||x.status==PurchaseStatus.restored){
        final p=findPack(x.productID);
        final key=x.purchaseID??'${x.productID}:${x.transactionDate??''}';
        if(p!=null&&!processed.contains(key)){
          processed.add(key);credits+=p.credits;await saveCredits();await saveProcessed();
          if(mounted)setState(()=>storeMessage='${p.credits} credits added.');
        }
      }
      if(x.pendingCompletePurchase) await iap.completePurchase(x);
    }
  }

  Future<void> buy(Pack p) async {
    final product=products[p.id];
    if(product==null){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('This pack is not active in Google Play yet.')));return;}
    await iap.buyConsumable(purchaseParam: PurchaseParam(productDetails: product),autoConsume:true);
  }

  Future<void> useHint() async {
    if(hint!=null)return;
    if(credits<=0){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('No credits left. Open Shop to buy more.')));return;}
    setState((){credits--;hint=qs[qi].hint;});await saveCredits();
  }

  void answer(int i){if(answered)return;setState((){selected=i;answered=true;if(i==qs[qi].answer)score++;});}
  void next(){setState((){qi=(qi+1)%qs.length;selected=null;answered=false;hint=null;if(qi==0)score=0;});}
  @override void dispose(){sub?.cancel();super.dispose();}

  @override Widget build(BuildContext context)=>DefaultTabController(
    length:2,
    child:Scaffold(
      appBar:AppBar(title:const Text('Quiz Hint Pro',style:TextStyle(fontWeight:FontWeight.w900)),centerTitle:true,
        actions:[Padding(padding:const EdgeInsets.only(right:12),child:Chip(avatar:const Icon(Icons.stars_rounded,size:18),label:Text('$credits',style:const TextStyle(fontWeight:FontWeight.w800))))],
        bottom:const TabBar(tabs:[Tab(icon:Icon(Icons.quiz_outlined),text:'Quiz'),Tab(icon:Icon(Icons.shopping_bag_outlined),text:'Shop')]),
      ),
      body:TabBarView(children:[quizTab(),shopTab()]),
    ),
  );

  Widget quizTab(){
    final q=qs[qi];
    return SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      Row(children:[Expanded(child:Text('Question ${qi+1} of ${qs.length}',style:const TextStyle(fontWeight:FontWeight.w700))),Text('Score: $score')]),
      const SizedBox(height:8),LinearProgressIndicator(value:(qi+1)/qs.length),const SizedBox(height:20),
      Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(color:Theme.of(context).colorScheme.primaryContainer,borderRadius:BorderRadius.circular(22)),child:Text(q.text,textAlign:TextAlign.center,style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w900))),
      const SizedBox(height:18),
      for(int i=0;i<q.options.length;i++) ...[answerButton(q,i),const SizedBox(height:10)],
      const SizedBox(height:6),OutlinedButton.icon(onPressed:hint==null?useHint:null,icon:const Icon(Icons.lightbulb_outline),label:Padding(padding:const EdgeInsets.symmetric(vertical:13),child:Text(hint==null?'Use 1 Credit for Hint':'Hint Revealed',style:const TextStyle(fontWeight:FontWeight.w800)))),
      if(hint!=null)...[const SizedBox(height:12),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Theme.of(context).colorScheme.secondaryContainer,borderRadius:BorderRadius.circular(16)),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[const Icon(Icons.lightbulb),const SizedBox(width:10),Expanded(child:Text(hint!))]))],
      if(answered)...[const SizedBox(height:16),FilledButton(onPressed:next,child:const Padding(padding:EdgeInsets.symmetric(vertical:14),child:Text('Next Question',style:TextStyle(fontWeight:FontWeight.w900))))],
      const SizedBox(height:14),Text('First launch includes 3 complimentary credits. Each hint uses 1 credit.',textAlign:TextAlign.center,style:Theme.of(context).textTheme.bodySmall),
    ])));
  }

  Widget answerButton(Q q,int i){
    Color? bg,fg;
    if(answered){if(i==q.answer){bg=Colors.green.shade100;fg=Colors.green.shade900;}else if(selected==i){bg=Colors.red.shade100;fg=Colors.red.shade900;}}
    return FilledButton.tonal(onPressed:answered?null:()=>answer(i),style:FilledButton.styleFrom(backgroundColor:bg,foregroundColor:fg,padding:const EdgeInsets.symmetric(vertical:16,horizontal:16),alignment:Alignment.centerLeft),child:Row(children:[CircleAvatar(radius:15,child:Text(String.fromCharCode(65+i))),const SizedBox(width:12),Expanded(child:Text(q.options[i],style:const TextStyle(fontWeight:FontWeight.w700)))]));
  }

  Widget shopTab()=>SafeArea(child:RefreshIndicator(onRefresh:loadProducts,child:ListView(padding:const EdgeInsets.all(20),children:[
    Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:Theme.of(context).colorScheme.primaryContainer,borderRadius:BorderRadius.circular(22)),child:Column(children:[const Icon(Icons.stars_rounded,size:46),const SizedBox(height:8),Text('Your Credits: $credits',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w900)),const SizedBox(height:6),const Text('1 hint = 1 credit. Packs are consumable and can be purchased repeatedly.',textAlign:TextAlign.center)])),
    const SizedBox(height:16),
    if(loading)const Padding(padding:EdgeInsets.all(20),child:Center(child:CircularProgressIndicator())),
    if(storeMessage!=null)...[Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:Theme.of(context).colorScheme.surfaceContainerHighest,borderRadius:BorderRadius.circular(14)),child:Text(storeMessage!,textAlign:TextAlign.center)),const SizedBox(height:14)],
    for(final p in packs) packTile(p),
    const SizedBox(height:10),Text('Actual prices are set in Google Play Console and can be localized by country.',textAlign:TextAlign.center,style:Theme.of(context).textTheme.bodySmall),
  ])));

  Widget packTile(Pack p){final product=products[p.id];final enabled=storeAvailable&&product!=null;return Card(margin:const EdgeInsets.only(bottom:10),child:ListTile(leading:const CircleAvatar(child:Icon(Icons.stars_rounded)),title:Text('${p.credits} Credits',style:const TextStyle(fontWeight:FontWeight.w900)),subtitle:Text(product==null?'${p.tier} target • ${p.id}':p.id),trailing:FilledButton(onPressed:enabled?()=>buy(p):null,child:Text(product?.price??'Not active'))));}
}
