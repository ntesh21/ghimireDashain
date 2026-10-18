import 'package:flutter/material.dart';

void main() {
  runApp(const GhimireDashainApp());
}

class GhimireDashainApp extends StatelessWidget {
  const GhimireDashainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ghimireDashain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B1FA2),
          brightness: Brightness.light,
        ),
      ),
      home: const DashainHomePage(),
    );
  }
}

class DashainHomePage extends StatefulWidget {
  const DashainHomePage({super.key});

  @override
  State<DashainHomePage> createState() => _DashainHomePageState();
}

class _DashainHomePageState extends State<DashainHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ghimireDashain'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(0.75),
          indicatorColor: theme.colorScheme.onPrimary,
          tabs: const [
            Tab(text: 'Marriage'),
            Tab(text: 'Kitty'),
            Tab(text: '3 Patti'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MarriageCalculator(),
          KittyCalculator(),
          TeenPattiCalculator(),
        ],
      ),
    );
  }
}

class MarriageCalculator extends StatefulWidget {
  const MarriageCalculator({super.key});

  @override
  State<MarriageCalculator> createState() => _MarriageCalculatorState();
}

class _MarriageCalculatorState extends State<MarriageCalculator> {
  final baseController = TextEditingController(text: '100');
  final marriageController = TextEditingController(text: '2');
  final bonusController = TextEditingController(text: '25');
  final tableController = TextEditingController(text: '4');
  bool showPublic = true;

  String result = '0';

  void calculate() {
    final base = int.tryParse(baseController.text) ?? 0;
    final marriages = int.tryParse(marriageController.text) ?? 0;
    final bonus = int.tryParse(bonusController.text) ?? 0;
    final players = int.tryParse(tableController.text) ?? 1;

    if (players <= 0) {
      setState(() {
        result = 'Table size must be at least 1.';
      });
      return;
    }

    final points = base + (marriages * 50) + bonus + (showPublic ? 25 : 0);
    final perPlayer = points / players;

    setState(() {
      result = 'Total: $points points\nPer player: ${perPlayer.toStringAsFixed(2)} points';
    });
  }

  @override
  void dispose() {
    baseController.dispose();
    marriageController.dispose();
    bonusController.dispose();
    tableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            title: 'Marriage Score',
            child: Column(
              children: [
                _InputRow(
                  label: 'Base points',
                  controller: baseController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _InputRow(
                  label: 'Marriage count',
                  controller: marriageController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _InputRow(
                  label: 'Bonus points',
                  controller: bonusController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _InputRow(
                  label: 'Table players',
                  controller: tableController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: showPublic,
                  onChanged: (value) => setState(() => showPublic = value),
                  title: const Text('Public marriage bonus'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: calculate,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Result',
            child: Text(
              result,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class KittyCalculator extends StatefulWidget {
  const KittyCalculator({super.key});

  @override
  State<KittyCalculator> createState() => _KittyCalculatorState();
}

class _KittyCalculatorState extends State<KittyCalculator> {
  final kittyController = TextEditingController(text: '500');
  final playersController = TextEditingController(text: '4');
  final yourContributionController = TextEditingController(text: '125');

  String result = '0';

  void calculate() {
    final totalKitty = double.tryParse(kittyController.text) ?? 0;
    final players = int.tryParse(playersController.text) ?? 1;
    final yourContribution = double.tryParse(yourContributionController.text) ?? 0;

    if (players <= 0) {
      setState(() => result = 'Players must be at least 1.');
      return;
    }

    final share = totalKitty / players;
    final difference = yourContribution - share;

    setState(() {
      result =
          'Per player share: ${share.toStringAsFixed(2)}\nYour contribution: ${yourContribution.toStringAsFixed(2)}\nBalance: ${difference.toStringAsFixed(2)}';
    });
  }

  @override
  void dispose() {
    kittyController.dispose();
    playersController.dispose();
    yourContributionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            title: 'Kitty Split',
            child: Column(
              children: [
                _InputRow(
                  label: 'Total kitty',
                  controller: kittyController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                _InputRow(
                  label: 'Number of players',
                  controller: playersController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _InputRow(
                  label: 'Your contribution',
                  controller: yourContributionController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: calculate,
                    icon: const Icon(Icons.account_balance_wallet),
                    label: const Text('Calculate kitty'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Result',
            child: Text(
              result,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class TeenPattiCalculator extends StatefulWidget {
  const TeenPattiCalculator({super.key});

  @override
  State<TeenPattiCalculator> createState() => _TeenPattiCalculatorState();
}

class _TeenPattiCalculatorState extends State<TeenPattiCalculator> {
  final playerOneController = TextEditingController(text: 'A, K, Q');
  final playerTwoController = TextEditingController(text: '10, 10, 8');
  String result = 'Waiting for cards';

  void calculate() {
    final left = parseCards(playerOneController.text);
    final right = parseCards(playerTwoController.text);

    if (left.length != 3 || right.length != 3) {
      setState(() => result = 'Enter exactly 3 cards per player (example: A, K, 9).');
      return;
    }

    final leftResult = evaluateTeenPatti(left);
    final rightResult = evaluateTeenPatti(right);

    final comparison = compareTeenPatti(leftResult, rightResult);

    setState(() {
      result =
          'Player 1: ${leftResult.label}\nPlayer 2: ${rightResult.label}\nWinner: $comparison';
    });
  }

  @override
  void dispose() {
    playerOneController.dispose();
    playerTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            title: 'Teen Patti Hand Check',
            child: Column(
              children: [
                _InputRow(
                  label: 'Player 1 cards',
                  controller: playerOneController,
                ),
                const SizedBox(height: 12),
                _InputRow(
                  label: 'Player 2 cards',
                  controller: playerTwoController,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: calculate,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Compare hands'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionCard(
            title: 'Result',
            child: Text(
              result,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _InputRow({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

List<String> parseCards(String value) {
  return value
      .split(',')
      .map((card) => card.trim())
      .where((card) => card.isNotEmpty)
      .toList();
}

class TeenPattiHand {
  final int weight;
  final int mainValue;
  final String label;

  const TeenPattiHand({required this.weight, required this.mainValue, required this.label});
}

TeenPattiHand evaluateTeenPatti(List<String> cards) {
  final values = cards.map(cardValue).toList()..sort();
  final counts = <int, int>{};
  for (final value in values) {
    counts[value] = (counts[value] ?? 0) + 1;
  }

  if (counts.length == 1) {
    return TeenPattiHand(
      weight: 8,
      mainValue: values.last,
      label: 'Trail: ${cardLabel(values.last)}',
    );
  }

  final isSequence = values[0] == values[1] - 1 && values[1] == values[2] - 1;
  if (isSequence) {
    return TeenPattiHand(
      weight: 7,
      mainValue: values.last,
      label: 'Sequence: ${cardLabel(values.last)}',
    );
  }

  if (counts.length == 2 && counts.values.contains(2)) {
    final pairValue = counts.entries.where((entry) => entry.value == 2).first.key;
    return TeenPattiHand(
      weight: 6,
      mainValue: pairValue,
      label: 'Pair: ${cardLabel(pairValue)}',
    );
  }

  return TeenPattiHand(
    weight: 5,
    mainValue: values.last,
    label: 'High Card: ${cardLabel(values.last)}',
  );
}

String compareTeenPatti(TeenPattiHand left, TeenPattiHand right) {
  if (left.weight > right.weight) {
    return 'Player 1 wins';
  }
  if (right.weight > left.weight) {
    return 'Player 2 wins';
  }
  if (left.mainValue > right.mainValue) {
    return 'Player 1 wins';
  }
  if (right.mainValue > left.mainValue) {
    return 'Player 2 wins';
  }
  return 'Tie';
}

int cardValue(String card) {
  final normalized = card.trim().toUpperCase();
  final clean = normalized.replaceAll(RegExp(r'[^A-Z0-9]'), '');

  return switch (clean) {
    'A' => 14,
    'K' => 13,
    'Q' => 12,
    'J' => 11,
    '10' => 10,
    '9' => 9,
    '8' => 8,
    '7' => 7,
    '6' => 6,
    '5' => 5,
    '4' => 4,
    '3' => 3,
    '2' => 2,
    _ => 0,
  };
}

String cardLabel(int value) {
  return switch (value) {
    14 => 'A',
    13 => 'K',
    12 => 'Q',
    11 => 'J',
    10 => '10',
    9 => '9',
    8 => '8',
    7 => '7',
    6 => '6',
    5 => '5',
    4 => '4',
    3 => '3',
    2 => '2',
    _ => '0',
  };
}
