part of elimination_demo;

class ExchangeStep extends EliminationStep {
  final int row1;
  final int row2;
  
  String get description => 'Exchange Row ${row1 + 1} and Row ${row2 + 1}.';
  
  static EliminationState performExchange(EliminationState state, int row1,
                                          int row2) {
    var result = new Matrix.copy(state.matrix);
    
    for (var i = 0; i < result.cols; ++i) {
      result.setCell(row2, i, state.matrix.getCell(row1, i));
      result.setCell(row1, i, state.matrix.getCell(row2, i));
    }
    return new EliminationState(state.pivotColumns, state.forwards, result,
        state.backwardsSteps);
  }
  
  ExchangeStep(EliminationState lastState, int row1, int row2)
      : row1 = row1,
        row2 = row2,
        super(performExchange(lastState, row1, row2));
}
