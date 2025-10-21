import 'package:boby/ui/screens/letters_soup/widgets/words.dart';
import 'package:flutter/material.dart';

class LettersSoup extends StatefulWidget {
  const LettersSoup({super.key});

  @override
  State<LettersSoup> createState() => _LettersSoupState();
}

class _LettersSoupState extends State<LettersSoup> {
  static const int size = 6;
  late List<String> words;
  late String topicTitle;
  late List<List<String>> grid;
  final Set<String> foundWords = {};
  final Set<Point> foundCells = {}; 
  Point? start;
  Point? end;
  List<Point> selectionPath = [];
  final _Rng _rng = _Rng();

  @override
  void initState() {
    super.initState();
    _selectRandomCategory();
    grid = _generateGrid(size, words);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              topicTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildWordList(),
            const SizedBox(height: 12),
            Expanded(child: _buildGrid()),
            const SizedBox(height: 8),
            _buildControls(),
          ],
        ),
      );
  }

  Widget _buildWordList() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: words
          .map((w) => Chip(
                label: Text(
                  w,
                  style: TextStyle(
                    decoration: foundWords.contains(w)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                backgroundColor:
                    foundWords.contains(w) ? Colors.green.shade200 : null,
              ))
          .toList(),
    );
  }

  Widget _buildGrid() {
    final gridWidth = MediaQuery.of(context).size.width - 20; // 10px margin each side
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
          final sRev = String.fromCharCodes(s.runes.toList().reversed);
          String? matched;
          if (words.contains(s)) matched = s;
          if (words.contains(sRev)) matched = sRev;
          setState(() {
            if (matched != null) {
              foundWords.add(matched);
              foundCells.addAll(selectionPath);
            }
            start = null;
            end = null;
            selectionPath = [];
          });
        },
        child: SizedBox(
          width: gridWidth,
          height: gridWidth,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size,
            ),
            itemCount: size * size,
            itemBuilder: (context, index) {
              final r = index ~/ size;
              final c = index % size;
              final p = Point(r, c);
              final inFound = foundCells.contains(p);
              final inSelection = selectionPath.contains(p);
              return InkWell(
                onTap: () => _onCellTap(p),
                child: Container(
                  decoration: BoxDecoration(
                    color: inFound
                        ? Colors.green.shade300
                        : inSelection
                            ? Colors.blue.shade300
                            : Colors.grey.shade200,
                    border: Border.all(color: Colors.black12),
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
              );
            },
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
          child: const Text('New Puzzle'),
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
      start = null;
      end = null;
      selectionPath = [];
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
        final sRev = String.fromCharCodes(s.runes.toList().reversed);
        String? matched;
        if (words.contains(s)) matched = s;
        if (words.contains(sRev)) matched = sRev;
        if (matched != null) {
          foundWords.add(matched);
          foundCells.addAll(path);
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

  void _selectRandomCategory() {
    final list = Words.words;
    if (list.isEmpty) {
      topicTitle = 'Words';
      words = const [];
      return;
    }
    final idx = _rng.nextInt(list.length);
    final item = list[idx];
    topicTitle = (item['title'] ?? 'Words').toString();
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
    words = selected;
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
    if (!((dr == 0 && dc != 0) || (dr != 0 && dc == 0) || (dr != 0 && dc != 0 && (b.r - a.r).abs() == (b.c - a.c).abs()))) {
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
    final grid = List.generate(n, (_) => List.generate(n, (_) => ''));
    final rng = _Rng();
    final dirs = [
      const Offset(1, 0),
      const Offset(-1, 0),
      const Offset(0, 1),
      const Offset(0, -1),
      const Offset(1, 1),
      const Offset(-1, -1),
      const Offset(1, -1),
      const Offset(-1, 1),
    ];

    for (final w in words) {
      var placed = false;
      var attempts = 0;
      while (!placed && attempts < 200) {
        attempts++;
        final dir = dirs[rng.nextInt(dirs.length)];
        final sr = rng.nextInt(n);
        final sc = rng.nextInt(n);
        if (_canPlace(grid, w, sr, sc, dir)) {
          _place(grid, w, sr, sc, dir);
          placed = true;
        }
      }
    }

    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if (grid[r][c].isEmpty) {
          grid[r][c] = _randomLetter(rng);
        }
      }
    }
    return grid;
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