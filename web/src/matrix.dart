part of elimination_demo;

class Matrix {
  final int rows;
  final int cols;
  final List<Rational> values;
  
  Matrix(int rows, int cols)
      : rows = rows,
        cols = cols,
        values = new List.filled(rows * cols, new Rational(0));
  
  Matrix.from(int rows, int cols, Matrix last)
      : rows = rows,
        cols = cols,
        values = new List.filled(rows * cols, new Rational(0)) {
    for (int i = 0; i < last.rows && i < rows; ++i) {
      for (int j = 0; j < last.cols && j < cols; ++j) {
        setCell(i, j, last.getCell(i, j));
      }
    }
  }
  
  Matrix.copy(Matrix last)
      : rows = last.rows,
        cols = last.cols,
        values = new List.from(last.values);
  
  Rational getCell(int row, int col) {
    assert(row >= 0 && col >= 0);
    assert(row < rows);
    assert(col < cols);
    return values[(row * cols) + col];
  }
  
  void setCell(int row, int col, Rational cell) {
    assert(row >= 0 && col >= 0);
    assert(row < rows);
    assert(col < cols);
    values[(row * cols) + col] = cell;
  }
  
  String getPrintableValue(int row, int col) {
    return getCell(row, col).toStringAsPrecision(5);
  }
  
  bool setPrintableValue(int row, int col, String value) {
    try {
      if (value.contains('/')) {
        List<String> comps = value.split('/');
        if (comps.length != 2) {
          return false;
        }
        var num = int.parse(comps.first);
        var den = int.parse(comps.last);
        setCell(row, col, new Rational(num, den));
      } else {
        var num = double.parse(value);
        setCell(row, col, new Rational((num * 10000).round(), 10000));
      }
      return true;
    } catch (_) {
      return false;
    }
  }
  
  String toString() => values.toString();
}
