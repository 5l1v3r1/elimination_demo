part of elimination_demo;

class EliminationState {
  final List<int> pivotColumns;
  final bool forwards;
  final int backwardsSteps;
  final Matrix matrix;
  
  EliminationState(this.pivotColumns, this.forwards, this.matrix,
                   this.backwardsSteps);
  
  EliminationState.start(this.matrix)
      : forwards = true,
        backwardsSteps = 0,
        pivotColumns = [];
  
  EliminationState addPivot(int pivot) {
    var newList = new List.from(pivotColumns);
    newList.add(pivot);
    return new EliminationState(newList, forwards, matrix, backwardsSteps);
  }
  
  EliminationState addBackwardsStep() {
    return new EliminationState(pivotColumns, forwards, matrix,
        backwardsSteps + 1);
  }
  
  EliminationStep nextStep() {
    if (forwards) {
      var result = _nextForwardsStep();
      if (result != null) {
        return result;
      } else {
        var backwards = new EliminationState(pivotColumns, false, matrix, 0);
        return backwards._startBackwardsStep();
      }
    } else {
      return _nextBackwardsStep();
    }
  }
  
  EliminationStep _nextForwardsStep() {
    // Attempt to continue with the current pivot
    var continued = _continueElimination();
    if (continued != null) {
      return continued;
    }
    // Locate the next pivot column
    var pivotRow = pivotColumns.length;
    var nextPivotColumn = 0;
    if (pivotColumns.length > 0) {
      nextPivotColumn = pivotColumns.last + 1;
    }
    var foundPivot = -1;
    var foundRow = -1;
    for (var i = nextPivotColumn; i < matrix.cols; ++i) {
      // Locate the highest non-zero row in this column
      foundRow = nonzeroRowBelow(pivotRow - 1, i);
      if (foundRow >= 0) {
        foundPivot = i;
        break;
      }
    }
    if (foundPivot < 0) {
      return null;
    }
    var pivotAdded = this.addPivot(foundPivot);
    if (foundRow > pivotRow) { 
      return new ExchangeStep(pivotAdded, foundRow, pivotRow);
    } else {
      return pivotAdded.nextStep();
    }
  }
  
  EliminationStep _continueElimination() {
    if (pivotColumns.length == 0) {
      return null;
    }
    var pivotColumn = pivotColumns.last;
    var pivotRow = pivotColumns.length - 1;
    var targetRow = nonzeroRowBelow(pivotRow, pivotColumn);
    if (targetRow < 0) {
      return null;
    }
    var valueToCut = matrix.getCell(targetRow, pivotColumn);
    var pivotValue = matrix.getCell(pivotRow, pivotColumn);
    var scale = -valueToCut / pivotValue;
    return new SubtractStep(this, pivotRow, targetRow, scale);
  }
  
  EliminationStep _nextBackwardsStep() {
    // Attempt to continue backwards
    var continued = _continueBackwards();
    if (continued != null) {
      return continued;
    }
    // Begin a new backwards step
    return addBackwardsStep()._startBackwardsStep();
  }
  
  EliminationStep _startBackwardsStep() {
    // Check if we're done
    if (backwardsSteps >= pivotColumns.length) {
      return null;
    }
    var pivotRow = pivotColumns.length - (backwardsSteps + 1);
    var pivotColumn = pivotColumns[pivotColumns.length - (backwardsSteps + 1)];
    var pivot = matrix.getCell(pivotRow, pivotColumn);
    if (pivot == new Rational(1)) {
      return nextStep();
    } else {
      return new ScaleStep(this, pivotRow, new Rational(1) / pivot);
    }
  }
  
  EliminationStep _continueBackwards() {
    var pivotRow = pivotColumns.length - (backwardsSteps + 1);
    var pivotColumn = pivotColumns[pivotColumns.length - (backwardsSteps + 1)];
    var targetRow = nonzeroRowAbove(pivotRow, pivotColumn);
    if (targetRow < 0) {
      return null;
    }
    Rational addValue = -matrix.getCell(targetRow, pivotColumn);
    return new SubtractStep(this, pivotRow, targetRow, addValue);
  }
  
  int nonzeroRowBelow(int row, int column) {
    for (var j = row + 1; j < matrix.rows; ++j) {
      if (matrix.getCell(j, column) != new Rational(0)) {
        return j;
      }
    }
    return -1;
  }
  
  int nonzeroRowAbove(int row, int column) {
    for (var j = row - 1; j >= 0; --j) {
      if (matrix.getCell(j, column) != new Rational(0)) {
        return j;
      }
    }
    return -1;
  }
}
