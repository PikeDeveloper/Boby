import 'package:boby/controllers/app_controller.dart';
import 'package:boby/ui/screens/letters_soup/widgets/words.dart';
import 'package:boby/ui/shared/winner_screen.dart';
import 'package:boby/ui/shared/word_of_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class LettersSoup extends StatefulWidget {
  const LettersSoup({super.key});

  @override
  State<LettersSoup> createState() => _LettersSoupState();
}

class _LettersSoupState extends State<LettersSoup> {
  static const int size = 6;
  final Color colorLetter = const Color.fromARGB(238, 64, 64, 64);
  
  // List of colors for different words (darker shades for better text contrast)
  final List<Color> wordColors = [
    Colors.red.shade400,
       Colors.purple.shade400,
    Colors.green.shade400,
    Colors.orange.shade400,
     Colors.blue.shade400,
    Colors.teal.shade400,
    Colors.pink.shade400,
    Colors.indigo.shade400,
  ];
  
  // Map to store colors for each word
  final Map<String, Color> wordColorMap = {};
  late List<String> words;
  late String topicTitle;
  late List<List<String>> grid;
  final Set<String> foundWords = {};
  final Set<Point> foundCells = {};
  final List<List<Point>> foundPaths = [];
  Point? start;
  Point? end;
  List<Point> selectionPath = [];
  final _Rng _rng = _Rng();

  final String winnerSound = "assets/sounds/winner-game.wav";
  bool _playedWin = false;

  @override
  void initState() {
    super.initState();
    _selectRandomCategory();
    grid = _generateGrid(size, words);
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                topicTitle,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildWordList(),
              const SizedBox(height: 12),
              Expanded(child: _buildGrid()),
              const SizedBox(height: 8),
              _buildControls(),
            ],
          ),
        ),
        if (foundWords.length == words.length)
          WinnerScreen(onTap: () {
            setState(() {
              _selectRandomCategory();
              grid = _generateGrid(size, words);
              foundWords.clear();
              foundCells.clear();
              foundPaths.clear();
              start = null;
              end = null;
              selectionPath = [];
            });
          }),
      ],
    );
  }

  Widget _buildWordList() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: words
          .map((w) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:  Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: wordColorMap[w]?.withValues(alpha: 1) ?? Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Text(
                  w,
                  style: TextStyle(
                    color: colorLetter,
                    fontWeight: FontWeight.bold,
                    decoration: foundWords.contains(w)
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: colorLetter,
                    decorationThickness: 2,
                  ),
                ),
              ))
          .toList(),
    );
  }

  BorderRadius _getBorderRadius(int row, int col, int size) {
    // Top-left corner
    if (row == 0 && col == 0) {
      return const BorderRadius.only(topLeft: Radius.circular(12));
    }
    // Top-right corner
    else if (row == 0 && col == size - 1) {
      return const BorderRadius.only(topRight: Radius.circular(12));
    }
    // Bottom-left corner
    else if (row == size - 1 && col == 0) {
      return const BorderRadius.only(bottomLeft: Radius.circular(12));
    }
    // Bottom-right corner
    else if (row == size - 1 && col == size - 1) {
      return const BorderRadius.only(bottomRight: Radius.circular(12));
    }
    
    // For all other cells, no rounded corners
    return BorderRadius.zero;
  }

  Widget _buildGrid() {
    final available =
        MediaQuery.of(context).size.width - 20; // 10px margin each side
    final gridWidth = available > 600 ? 600.0 : available;
    final cellSize = gridWidth / size;
    return Center(
      child: GestureDetector(
        onPanStart: (details) {
          final local = details.localPosition;
          final p = _cellFromLocal(local, cellSize);
          if (p != null) {
            setState(() {
              start = p;
              end = null;
              selectionPath = [p];
            });
          }
        },
        onPanUpdate: (details) {
          if (start == null) return;
          final p = _cellFromLocal(details.localPosition, cellSize);
          if (p == null) return;
          final snapped = _snapPoint(start!, p);
          final path = _straightPath(start!, snapped);
          setState(() {
            end = snapped;
            selectionPath = path;
          });
        },
        onPanEnd: (_) {
          if (start == null || selectionPath.isEmpty) return;
          final s = _lettersFrom(selectionPath);
          String? matched;
          if (words.contains(s)) matched = s;
          setState(() {
            if (matched != null) {
              foundWords.add(matched);
              foundCells.addAll(selectionPath);
              foundPaths.add(List<Point>.from(selectionPath));
              _maybePlayWin();
            }
            start = null;
            end = null;
            selectionPath = [];
          });
        },
        child: SizedBox(
          width: gridWidth,
          height: gridWidth,
          child: Stack(
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size,
                ),
                itemCount: size * size,
                itemBuilder: (context, index) {
                  final r = index ~/ size;
                  final c = index % size;
                  final p = Point(r, c);
                  return InkWell(
                    onTap: () => _onCellTap(p),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            border: Border.all(
                              color: Colors.black12,
                              width: 1,
                            ),
                            borderRadius: _getBorderRadius(r, c, size),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            grid[r][c],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        if (isPartOfFoundWord(p))
                          Container(
                            decoration: BoxDecoration(
                            //  color: getHighlightColor(p)?.withOpacity(0.3),
                              borderRadius: _getBorderRadius(r, c, size),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              CustomPaint(
                size: Size(gridWidth, gridWidth),
                painter: _SelectionPainter(
                  cellSize: cellSize,
                  currentPath: selectionPath,
                  foundPaths: foundPaths,
                  wordColorMap: wordColorMap,
                  grid: grid,
                  size: size,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _reset,
          child: WordOfImages(letters: ["N", "E", "W"], letterSize: 20),
        ),
        Text('${foundWords.length}/${words.length} found'),
      ],
    );
  }

  void _reset() {
    setState(() {
      _selectRandomCategory();
      grid = _generateGrid(size, words);
      foundWords.clear();
      foundCells.clear();
      foundPaths.clear();
      start = null;
      end = null;
      selectionPath = [];
      _playedWin = false;
    });
  }

  void _onCellTap(Point p) {
    setState(() {
      if (start == null) {
        start = p;
        selectionPath = [p];
        return;
      }
      if (end == null) {
        end = p;
        final path = _straightPath(start!, end!);
        selectionPath = path;
        final s = _lettersFrom(path);
        String? matched;
        if (words.contains(s)) matched = s;
        if (matched != null) {
          foundWords.add(matched);
          foundCells.addAll(path);
          foundPaths.add(List<Point>.from(path));
          _maybePlayWin();
        }
        start = null;
        end = null;
        return;
      }
      start = p;
      end = null;
      selectionPath = [p];
    });
  }

  Point? _cellFromLocal(Offset local, double cellSize) {
    final c = (local.dx / cellSize).floor();
    final r = (local.dy / cellSize).floor();
    if (r < 0 || r >= size || c < 0 || c >= size) return null;
    return Point(r, c);
  }

  Point _snapPoint(Point s, Point e) {
    final dr = e.r - s.r;
    final dc = e.c - s.c;
    if (dr == 0 && dc == 0) return s;

    final adr = dr.abs();
    final adc = dc.abs();
    if (adr == adc) {
      final k = adr; // move diagonally
      final r = _clamp(s.r + k * dr.sign, 0, size - 1);
      final c = _clamp(s.c + k * dc.sign, 0, size - 1);
      return Point(r, c);
    }
    if (adr > adc) {
      // vertical snap
      final r = _clamp(s.r + adr * dr.sign, 0, size - 1);
      return Point(r, s.c);
    } else {
      // horizontal snap
      final c = _clamp(s.c + adc * dc.sign, 0, size - 1);
      return Point(s.r, c);
    }
  }

  int _clamp(int v, int min, int max) => v < min ? min : (v > max ? max : v);

  // Check if a cell is part of a found word
  bool isPartOfFoundWord(Point p) {
    for (final path in foundPaths) {
      if (path.any((point) => point.r == p.r && point.c == p.c)) {
        return true;
      }
    }
    return false;
  }
  
  // Get the highlight color of the word at a specific cell
  Color? getHighlightColor(Point p) {
    for (var i = 0; i < foundPaths.length; i++) {
      if (foundPaths[i].any((point) => point.r == p.r && point.c == p.c)) {
        final word = _lettersFrom(foundPaths[i]);
        return wordColorMap[word]?.withOpacity(0.3);
      }
    }
    return null;
  }

  void _selectRandomCategory() {
    final list = Words.words;
    if (list.isEmpty) {
      setState(() {
        topicTitle = 'Words';
        words = const [];
      });
      return;
    }
    
    final idx = _rng.nextInt(list.length);
    final item = list[idx];
    final newTitle = (item['title'] ?? 'Words').toString();
    final raw = (item['words'] as List).map((e) => e.toString()).toList();
    
    // Normalize: keep only A-Z letters and uppercase
    final normalized = raw
        .map((e) => e.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), ''))
        .where((w) => w.isNotEmpty)
        .toList();
        
    // Prefer words that fit the grid (<= size). If none fit, fall back to all.
    final eligible = normalized.where((w) => w.length <= size).toList();
    final pool = eligible.isNotEmpty ? eligible : List<String>.from(normalized);
    final selected = <String>[];
    
    while (selected.length < 4 && pool.isNotEmpty) {
      final i = _rng.nextInt(pool.length);
      selected.add(pool.removeAt(i));
    }
    
    setState(() {
      words = selected;
      topicTitle = newTitle;
      
      // Clear previous state
      foundWords.clear();
      foundCells.clear();
      foundPaths.clear();
      start = null;
      end = null;
      selectionPath = [];
      _playedWin = false;
      
      // Assign colors to words
      wordColorMap.clear();
      for (var i = 0; i < words.length; i++) {
        wordColorMap[words[i]] = wordColors[i % wordColors.length];
      }
      
      // Regenerate grid with new words
      grid = _generateGrid(size, words);
    });
  }

  void _maybePlayWin() {
    if (!_playedWin && foundWords.length == words.length) {
      final appController = Get.find<AppController>();
      appController.playMenuSound(winnerSound);
      _playedWin = true;
    }
  }

  String _lettersFrom(List<Point> path) {
    final buffer = StringBuffer();
    for (final p in path) {
      buffer.write(grid[p.r][p.c]);
    }
    return buffer.toString();
  }

  List<Point> _straightPath(Point a, Point b) {
    final dr = (b.r - a.r).sign;
    final dc = (b.c - a.c).sign;
    if (dr == 0 && dc == 0) return [a];
    if (!((dr == 0 && dc != 0) ||
        (dr != 0 && dc == 0) ||
        (dr != 0 && dc != 0 && (b.r - a.r).abs() == (b.c - a.c).abs()))) {
      return [a];
    }
    final path = <Point>[];
    var r = a.r;
    var c = a.c;
    path.add(Point(r, c));
    while (r != b.r || c != b.c) {
      r += dr;
      c += dc;
      path.add(Point(r, c));
    }
    return path;
  }

  List<List<String>> _generateGrid(int n, List<String> words) {
    final rng = _Rng();
    final dirs = [
      // Only left-to-right orientations: horizontal right and rightward diagonals
      const Offset(1, 0), // →
      const Offset(1, 1), // ↘
      const Offset(1, -1), // ↗
    ];

    // Try multiple times until all words are placed
    for (var outer = 0; outer < 400; outer++) {
      final grid = List.generate(n, (_) => List.generate(n, (_) => ''));
      // Place in a randomized order to improve chances
      final order = List<String>.from(words);
      _shuffle(order, rng);

      var allPlaced = true;
      for (final w in order) {
        var placed = false;
        for (var attempts = 0; attempts < 600 && !placed; attempts++) {
          final dir = dirs[rng.nextInt(dirs.length)];
          final sr = rng.nextInt(n);
          final sc = rng.nextInt(n);
          if (_canPlace(grid, w, sr, sc, dir)) {
            _place(grid, w, sr, sc, dir);
            placed = true;
          }
        }
        if (!placed) {
          allPlaced = false;
          break; // restart whole grid
        }
      }

      if (!allPlaced) {
        continue; // try a new empty grid
      }

      // Fill remaining cells
      for (var r = 0; r < n; r++) {
        for (var c = 0; c < n; c++) {
          if (grid[r][c].isEmpty) {
            grid[r][c] = _randomLetter(rng);
          }
        }
      }
      return grid;
    }

    // Fallback: last-try naive grid (should rarely happen)
    final fallback = List.generate(n, (_) => List.generate(n, (_) => ''));
    final fbRng = _Rng();
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        fallback[r][c] = _randomLetter(fbRng);
      }
    }
    return fallback;
  }

  bool _canPlace(List<List<String>> g, String w, int sr, int sc, Offset dir) {
    final n = g.length;
    var r = sr;
    var c = sc;
    for (var i = 0; i < w.length; i++) {
      if (r < 0 || r >= n || c < 0 || c >= n) return false;
      final ch = w[i];
      if (g[r][c].isNotEmpty && g[r][c] != ch) return false;
      r += dir.dy.toInt();
      c += dir.dx.toInt();
    }
    return true;
  }

  void _place(List<List<String>> g, String w, int sr, int sc, Offset dir) {
    var r = sr;
    var c = sc;
    for (var i = 0; i < w.length; i++) {
      g[r][c] = w[i];
      r += dir.dy.toInt();
      c += dir.dx.toInt();
    }
  }

  String _randomLetter(_Rng rng) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return letters[rng.nextInt(letters.length)];
  }
}

class Point {
  final int r;
  final int c;
  const Point(this.r, this.c);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Point && other.r == r && other.c == c;

  @override
  int get hashCode => Object.hash(r, c);
}

class _Rng {
  int _seed = DateTime.now().microsecondsSinceEpoch & 0x7fffffff;
  int nextInt(int max) {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed % max;
  }
}

void _shuffle<T>(List<T> list, _Rng rng) {
  for (var i = list.length - 1; i > 0; i--) {
    final j = rng.nextInt(i + 1);
    final tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }
}

class _SelectionPainter extends CustomPainter {
  final double cellSize;
  final List<Point> currentPath;
  final List<List<Point>> foundPaths;
  final Map<String, Color> wordColorMap;
  final List<List<String>> grid;
  final int size;

  _SelectionPainter({
    required this.currentPath,
    required this.foundPaths,
    required this.cellSize,
    required this.wordColorMap,
    required this.grid,
    required this.size,
  });

  String _lettersFromPath(List<Point> path) {
    return path.map((p) => grid[p.r][p.c]).join();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw found words with their respective colors
    for (final path in foundPaths) {
      final word = _lettersFromPath(path);
      final color = wordColorMap[word] ?? Colors.green;
      _drawCapsule(canvas, path, color);
    }
    if (currentPath.isNotEmpty) {
      _drawCapsule(canvas, currentPath, Colors.blue);
    }
  }

  void _drawCapsule(Canvas canvas, List<Point> path, Color color) {
    if (path.isEmpty) return;
    final a = path.first;
    final b = path.last;

    final aCenter =
        Offset(a.c * cellSize + cellSize / 2, a.r * cellSize + cellSize / 2);
    final bCenter =
        Offset(b.c * cellSize + cellSize / 2, b.r * cellSize + cellSize / 2);

    final mid =
        Offset((aCenter.dx + bCenter.dx) / 2, (aCenter.dy + bCenter.dy) / 2);
    final dx = bCenter.dx - aCenter.dx;
    final dy = bCenter.dy - aCenter.dy;
    final angle = math.atan2(dy, dx);
    final length = math.sqrt(dx * dx + dy * dy);

    final thickness = cellSize * 0.8;
    final rect = Rect.fromCenter(
        center: mid, width: length + thickness, height: thickness);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(thickness / 2));

    canvas.save();
    canvas.translate(mid.dx, mid.dy);
    canvas.rotate(angle);
    canvas.translate(-mid.dx, -mid.dy);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;
    canvas.drawRRect(rrect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SelectionPainter oldDelegate) {
    return oldDelegate.cellSize != cellSize ||
        oldDelegate.currentPath != currentPath ||
        !_listEquals(oldDelegate.foundPaths, foundPaths);
  }

  bool _listEquals(List<List<Point>> a, List<List<Point>> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      final la = a[i];
      final lb = b[i];
      if (la.length != lb.length) return false;
      for (var j = 0; j < la.length; j++) {
        if (la[j] != lb[j]) return false;
      }
    }
    return true;
  }
}
