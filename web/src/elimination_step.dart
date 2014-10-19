part of elimination_demo;

abstract class EliminationStep {
  final EliminationState state;
  
  String get description;
  
  EliminationStep(this.state);
  
  Element toElement() {
    var el = new DivElement();
    var paragraph = new ParagraphElement();
    paragraph.innerHtml = description;
    
    // Generate a table for the matrix
    var matrixTable = new TableElement();
    matrixTable.className = 'matrix';
    for (var row = 0; row < state.matrix.rows; ++row) {
      var rowElement = new TableRowElement();
      for (var col = 0; col < state.matrix.cols; ++col) {
        var cellElement = new TableCellElement();
        cellElement.text = state.matrix.getPrintableValue(row, col);
        rowElement.append(cellElement);
      }
      matrixTable.append(rowElement);
    }
    
    el.append(paragraph);
    el.append(matrixTable);
    return el;
  }
}
