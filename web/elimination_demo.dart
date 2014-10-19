library elimination_demo;

import 'dart:html';
import 'dart:math';
import 'package:rational/rational.dart';

part 'src/matrix.dart';
part 'src/elimination_state.dart';
part 'src/elimination_step.dart';
part 'src/exchange_step.dart';
part 'src/scale_step.dart';
part 'src/subtract_step.dart';

Matrix inputMatrix;

void main() {
  inputMatrix = new Matrix(2, 2);
  layoutMatrix();
  
  querySelector('#add-row-button').onClick.listen((_) {
    modifyDimensions(1, 0);
  });
  querySelector('#remove-row-button').onClick.listen((_) {
    modifyDimensions(-1, 0);
  });
  querySelector('#add-column-button').onClick.listen((_) {
    modifyDimensions(0, 1);
  });
  querySelector('#remove-column-button').onClick.listen((_) {
    modifyDimensions(0, -1);
  });
  
  querySelector('#eliminate-button').onClick.listen((_) {
    eliminate();
  });
}

void layoutMatrix() {
  var element = querySelector('#input-matrix');
  element.innerHtml = '';
  for (var row = 0; row < inputMatrix.rows; ++row) {
    var rowElement = new TableRowElement();
    for (var col = 0; col < inputMatrix.cols; ++col) {
      var dataElement = new TableCellElement();
      var input = new InputElement();
      
      input.value = inputMatrix.getPrintableValue(row, col);
      input.className = 'cell-input';
      
      input.onChange.listen((_) {
        inputMatrix.setPrintableValue(row, col, input.value);
        input.value = inputMatrix.getPrintableValue(row, col);
      });
      
      dataElement.append(input);
      rowElement.append(dataElement);
    }
    element.append(rowElement);
  }
}

void modifyDimensions(int rows, int cols) {
  inputMatrix = new Matrix.from(max(1, inputMatrix.rows + rows),
      max(1, inputMatrix.cols + cols), inputMatrix);
  layoutMatrix();
}

void eliminate() {
  var container = querySelector('#steps-output');
  container.innerHtml = '';
  EliminationState start = new EliminationState.start(inputMatrix);
  EliminationStep step = start.nextStep();
  while (step != null) {
    container.append(step.toElement());
    step = step.state.nextStep();
  }
  var endParagraph = new ParagraphElement();
  endParagraph.innerHtml = 'Completed elimination into reduced row echelon'
      ' form.';
  container.append(endParagraph);
}
