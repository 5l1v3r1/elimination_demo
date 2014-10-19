part of elimination_demo;

class ScaleStep extends EliminationStep {
  final int row;
  final Rational scale;
  
  String get description => 'Scale Row ${row + 1} by $scale';
  
  static EliminationState performScale(EliminationState state, int row,
                                       Rational scale) {
    var result = new Matrix.copy(state.matrix);
    for (var i = 0; i < result.cols; ++i) {
      result.setCell(row, i, result.getCell(row, i) * scale);
    }
    return new EliminationState(state.pivotColumns, state.forwards, result,
        state.backwardsSteps);
  }
  
  ScaleStep(EliminationState lastState, int row, Rational scale)
      : row = row,
        scale = scale,
        super(performScale(lastState, row, scale));
}
