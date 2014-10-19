part of elimination_demo;

class SubtractStep extends EliminationStep {
  final int sourceRow;
  final int targetRow;
  final Rational pivotScaler;
  
  String get description => 'Add $pivotScaler * Row ${sourceRow + 1}'
      ' to Row ${targetRow + 1}.';
  
  static EliminationState performElimination(EliminationState state,
                                             int sourceRow,
                                             int targetRow,
                                             Rational pivotScaler) {
    var result = new Matrix.copy(state.matrix);
    for (var i = 0; i < result.cols; ++i) {
      var cell = result.getCell(targetRow, i);
      cell += pivotScaler * result.getCell(sourceRow, i);
      result.setCell(targetRow, i, cell);
    }
    return new EliminationState(state.pivotColumns, state.forwards, result,
        state.backwardsSteps);
  }
  
  SubtractStep(EliminationState lastState, int sourceRow, int targetRow,
               Rational pivotScaler)
      : sourceRow = sourceRow,
        targetRow = targetRow,
        pivotScaler = pivotScaler,
        super(performElimination(lastState, sourceRow, targetRow,
            pivotScaler));
}
