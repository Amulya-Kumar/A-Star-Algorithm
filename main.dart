class Pair {
  int xCord; // Property
  int yCord;

  Pair({this.xCord, this.yCord});

  void setValue(int x, int y) {
    this.xCord = x;
    this.yCord = y;
  }
}

class Fpair {
  double fValue;
  Pair pair = new Pair();

  void setValue(double x, Pair sPair) {
    this.fValue = x;
    pair.setValue(sPair.xCord, sPair.yCord);
  }
}

class Cell {
  int parentXCord;
  int parentYCord;

  double fValue;
  double gValue;
  double hValue;

  Cell(
      {this.parentXCord,
      this.parentYCord,
      this.fValue,
      this.gValue,
      this.hValue});
}

bool isValid(int row, int col) {
  return (row >= 0) && (row < 5) && (col >= 0) && (col < 5);
}

bool isUnBlocked(List<List<int>> grid, int row, int col) {
  if (grid[row][col] == 0)
    return true;
  else
    return false;
}

bool isDestination(int row, int col, Pair dest) {
  if (row == dest.xCord && col == dest.yCord)
    return true;
  else
    return false;
}

double calculateHValue(int row, int col, Pair dest) {
  double xValue = row.toDouble() - dest.xCord;
  double yValue = col.toDouble() - dest.yCord;
  double hValue = xValue.abs() + yValue.abs();
  return hValue;
}

void tracePath(List<List<Cell>> cellDetails, Pair dest) {
  print("The path is: ");
  int row = dest.xCord;
  int col = dest.yCord;

  List<Pair> path = new List<Pair>();

  while (!(cellDetails[row][col].parentXCord == row &&
      cellDetails[row][col].parentYCord == col)) {
    var tempPair = new Pair();
    tempPair.setValue(row, col);
    path.insert(0, tempPair);

    int tempRow = cellDetails[row][col].parentXCord;
    int tempCol = cellDetails[row][col].parentYCord;
    row = tempRow;
    col = tempCol;
  }

  var ntempPair = new Pair();
  ntempPair.setValue(row, col);
  path.insert(0, ntempPair);

  while (path.isNotEmpty) {
    Pair p = path[0];
    path.removeAt(0);
    print("--> (${p.xCord}, ${p.yCord})");
  }
}

void aStarSearch(List<List<int>> grid, Pair src, Pair dest) {
  if (isValid(src.xCord, src.yCord) == false) {
    print("Source is invalid");
    return;
  }

  if (isValid(dest.xCord, dest.yCord) == false) {
    print("Destination is invalid");
    return;
  }

  if (isDestination(src.xCord, src.yCord, dest) == true) {
    print("We are already at the destination");
    return;
  }

  var closedList = new List.generate(
      5, (_) => new List<bool>.filled(5, false, growable: true));
  var cellDetails = new List<List<Cell>>.generate(5, (i) => new List<Cell>(5));

  int i, j;

  for (i = 0; i < 5; i++) {
    for (j = 0; j < 5; j++) {
      Cell tempCell = new Cell();
      tempCell.fValue = double.infinity;
      tempCell.gValue = double.infinity;
      tempCell.hValue = double.infinity;
      tempCell.parentXCord = -1;
      tempCell.parentYCord = -1;

      cellDetails[i][j] = tempCell;
    }
  }

  i = src.xCord;
  j = src.yCord;

  cellDetails[i][j].fValue = 0.0;
  cellDetails[i][j].gValue = 0.0;
  cellDetails[i][j].hValue = 0.0;
  cellDetails[i][j].parentXCord = i;
  cellDetails[i][j].parentYCord = j;

  List<Fpair> openList = new List<Fpair>();

  var tempPair = new Pair();
  tempPair.setValue(i, j);
  var tempFpair = new Fpair();
  tempFpair.setValue(0.0, tempPair);

  openList.insert(0, tempFpair);

  bool foundDest = false;

  while (openList.isNotEmpty) {
    Fpair p = openList[0];

    openList.remove(openList[0]);

    i = p.pair.xCord;
    j = p.pair.yCord;

    closedList[i][j] = true;

    double gNew, hNew, fNew;
    if (isValid(i - 1, j)) {
      if (isDestination(i - 1, j, dest)) {
        cellDetails[i - 1][j].parentXCord = i;
        cellDetails[i - 1][j].parentYCord = j;
        print("Destination is found");
        tracePath(cellDetails, dest);
        foundDest = true;
        return;
      } else if (closedList[i - 1][j] == false &&
          isUnBlocked(grid, i - 1, j) == true) {
        gNew = cellDetails[i][j].gValue + 1.0;
        hNew = calculateHValue(i - 1, j, dest);
        fNew = gNew + hNew;

        if (cellDetails[i - 1][j].fValue == double.infinity ||
            cellDetails[i - 1][j].fValue > fNew) {
          var tempPair = new Pair();
          tempPair.setValue(i - 1, j);
          var tempFpair = new Fpair();
          tempFpair.setValue(fNew, tempPair);
          openList.insert(0, tempFpair);

          cellDetails[i - 1][j].fValue = fNew;
          cellDetails[i - 1][j].gValue = gNew;
          cellDetails[i - 1][j].hValue = hNew;
          cellDetails[i - 1][j].parentXCord = i;
          cellDetails[i - 1][j].parentYCord = j;
        }
      }
    }

    if (isValid(i, j - 1)) {
      if (isDestination(i, j - 1, dest)) {
        cellDetails[i][j - 1].parentXCord = i;
        cellDetails[i][j - 1].parentYCord = j;
        print("Destination is found");
        tracePath(cellDetails, dest);
        foundDest = true;
        return;
      } else if (closedList[i][j - 1] == false && isUnBlocked(grid, i, j - 1)) {
        gNew = cellDetails[i][j].gValue + 1.0;
        hNew = calculateHValue(i, j - 1, dest);
        fNew = gNew + hNew;

        if (cellDetails[i][j - 1].fValue == double.infinity ||
            cellDetails[i][j - 1].fValue > fNew) {
          var tempPair = new Pair();
          tempPair.setValue(i, j - 1);
          var tempFpair = new Fpair();
          tempFpair.setValue(fNew, tempPair);
          openList.insert(0, tempFpair);

          cellDetails[i][j - 1].fValue = fNew;
          cellDetails[i][j - 1].gValue = gNew;
          cellDetails[i][j - 1].hValue = hNew;
          cellDetails[i][j - 1].parentXCord = i;
          cellDetails[i][j - 1].parentYCord = j;
        }
      }
    }

    if (isValid(i + 1, j)) {
      if (isDestination(i + 1, j, dest)) {
        cellDetails[i + 1][j].parentXCord = i;
        cellDetails[i + 1][j].parentYCord = j;
        print("Destination is found");
        tracePath(cellDetails, dest);
        foundDest = true;
        return;
      } else if (closedList[i + 1][j] == false && isUnBlocked(grid, i + 1, j)) {
        gNew = cellDetails[i][j].gValue + 1.0;
        hNew = calculateHValue(i + 1, j, dest);
        fNew = gNew + hNew;

        if (cellDetails[i + 1][j].fValue == double.infinity ||
            cellDetails[i + 1][j].fValue > fNew) {
          var tempPair = new Pair();
          tempPair.setValue(i + 1, j);
          var tempFpair = new Fpair();
          tempFpair.setValue(fNew, tempPair);
          openList.insert(0, tempFpair);

          cellDetails[i + 1][j].fValue = fNew;
          cellDetails[i + 1][j].gValue = gNew;
          cellDetails[i + 1][j].hValue = hNew;
          cellDetails[i + 1][j].parentXCord = i;
          cellDetails[i + 1][j].parentYCord = j;
        }
      }
    }

    if (isValid(i, j + 1)) {
      if (isDestination(i, j + 1, dest)) {
        cellDetails[i][j + 1].parentXCord = i;
        cellDetails[i][j + 1].parentYCord = j;
        print("Destination is found");
        tracePath(cellDetails, dest);
        foundDest = true;
        return;
      } else if (closedList[i][j + 1] == false && isUnBlocked(grid, i, j + 1)) {
        gNew = cellDetails[i][j].gValue + 1.0;
        hNew = calculateHValue(i, j + 1, dest);
        fNew = gNew + hNew;

        if (cellDetails[i][j + 1].fValue == double.infinity ||
            cellDetails[i][j + 1].fValue > fNew) {
          var tempPair = new Pair();
          tempPair.setValue(i, j + 1);
          var tempFpair = new Fpair();
          tempFpair.setValue(fNew, tempPair);
          openList.insert(0, tempFpair);

          cellDetails[i][j + 1].fValue = fNew;
          cellDetails[i][j + 1].gValue = gNew;
          cellDetails[i][j + 1].hValue = hNew;
          cellDetails[i][j + 1].parentXCord = i;
          cellDetails[i][j + 1].parentYCord = j;
        }
      }
    }
  }
  if (foundDest == false) print("failed to find destination");

  return;
}

main() {
  var grid =
      new List.generate(5, (_) => new List<int>.filled(5, 0, growable: true));

  grid[0][2] = 1;
  grid[1][2] = 1;
  grid[2][2] = 1;

  print(grid);

  var src = new Pair(); // Creating Object
  src.setValue(1, 1);

  var dest = new Pair(); // Creating Object
  dest.setValue(0, 4);

  aStarSearch(grid, src, dest);
}

