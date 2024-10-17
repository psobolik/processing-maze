import mazeLib.*;

static final int HOME = 36;

static final int _margin = 10;

static final int _rowCount = 15;
static final int _colCount = 15;

static final int _rowIndexMax = _rowCount - 1;
static final int _colIndexMax = _colCount - 1;

private CellGrid _maze;
private Player _player;

private float _cellWidth;
private float _cellHeight;

private float _mazeWidth;
private float _mazeHeight;
private final color _mazeBackgroundColor = color(210);
private final color _mazeBorderColor = color(0);
private final int _mazeBorderWidth = 4;

private PShape _goal;
private final int _goalInset = 10;
private final int _goalStrokeWidth = 1;

private final color _goalStrokeColor = color(255, 255, 64);
private final color _goalFillColor = color(255, 0, 0);

private final color _mazeWallColor = color(20, 55, 20);
private final int _mazeWallWidth = 2;

private final color _mazeGridColor = color(255);
private final int _mazeGridWidth = 1;

private final color _playerStrokeColor = color(25, 0, 0);
private final color _playerFillColor = color(255, 255, 0);

private boolean _winFlag = false;
private final color _winTextColor1 = color(0, 408, 612, 85);
private final color _winTextColor2 = color(0, 408, 612, 170);
private final color _winTextColor3 = color(0, 408, 612);

private Generator _generator = new Generator();

void setup() {
  size(800, 800);

  _cellWidth = (width - _margin - _margin) / _colCount;
  _cellHeight = (height - _margin - _margin) / _rowCount;

  _mazeWidth = _cellWidth * _colCount;
  _mazeHeight = _cellHeight * _rowCount;

  _maze = _generator.generateMaze(_rowCount, _colCount);

  float playerSize = min(_cellWidth, _cellHeight);
  _player = new Player(playerSize, _playerStrokeColor, _playerFillColor);

  _goal = loadShape("star-fill.svg");
  _goal.disableStyle();
}
void draw() {
  if (_winFlag) {
    drawWinScreen();
  } else {
    drawPlayScreen();
  }
}
void drawPlayScreen() {
  background(128);
  drawMaze();
  drawGoal();
  drawPlayer();
  checkForWin();
}
void drawWinScreen() {
  float center = _mazeWidth / 2;
  float y = _mazeHeight / 4;

  background(0);
  textSize(128);
  textAlign(CENTER);
  fill(_winTextColor1);
  text("You won!", center, y);
  fill(_winTextColor2);
  text("You won!", center, (y * 3) / 2);
  fill(_winTextColor3);
  text("You won!", center, (y * 4) / 2);
  textSize(24);
  text("Press Esc to quit", center, _mazeHeight - 30);
  text("or any other key to play a different maze.", center, _mazeHeight);
}
void checkForWin() {
  Coordinates playerCoordinates = _player.getCoordinates();
  _winFlag = playerCoordinates.getCol() == _colIndexMax && playerCoordinates.getRow() == _rowIndexMax;
}
void keyPressed() {
  if (_winFlag) {
    _player.setCoordinates(0, 0);
    _player.setHeading(Direction.North);
    _winFlag = false;
    _maze = _generator.generateMaze(_rowCount, _colCount);
    return;
  }
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        _player.setHeading(Direction.North);
        if (getCell(_player.getCoordinates()).get(Direction.North) instanceof CellPassage) {
          _player.moveForward();
          drawPlayer();
        }
        break;
      case DOWN:
        _player.setHeading(Direction.South);
        if (getCell(_player.getCoordinates()).get(Direction.South) instanceof CellPassage) {
          _player.moveBackward();
          drawPlayer();
        }
        break;
      case LEFT:
        _player.setHeading(Direction.West);
        if (getCell(_player.getCoordinates()).get(Direction.West) instanceof CellPassage) {
          _player.moveLeft();
          drawPlayer();
        }
        break;
      case RIGHT:
        _player.setHeading(Direction.East);
        if (getCell(_player.getCoordinates()).get(Direction.East) instanceof CellPassage) {
          _player.moveRight();
          drawPlayer();
        }
        break;
      case HOME:
        _player.setHeading(Direction.North);
        _player.setCoordinates(0, 0);
        drawPlayer();
    }
  }
}

int getPlayerRow() {
  return _rowCount - 1 - _player.getRow();
}

int getPlayerCol() {
  return _player.getCol();
}

void drawGoal() {
  float xOffset = (_colCount - 1) * _cellWidth + _margin;
  float yOffset = _margin;
  push();
  strokeWeight(_goalStrokeWidth);
  stroke(_goalStrokeColor);
  fill(_goalFillColor);
  shapeMode(CORNER);
  shape(_goal,
    xOffset + _goalInset,
    yOffset + _goalInset,
    _cellWidth - _goalInset - _goalInset,
    _cellHeight - _goalInset - _goalInset);
  pop();
}

void drawPlayer() {
  float yOffset = (getPlayerRow() * _cellHeight);
  float xOffset = (getPlayerCol() * _cellWidth);

  _player.draw(xOffset + (_cellWidth / 2) + _margin, yOffset + (_cellHeight / 2) + _margin);
}

void drawEdge(float x1, float y1, float x2, float y2, color strokeColor, int strokeWeight) {
  push();
  strokeCap(ROUND);
  stroke(strokeColor);
  fill(strokeColor);
  strokeWeight(strokeWeight);
  line(x1, y1, x2, y2);
  pop();
}

void drawCellWalls(int row, int col) {
  row = _rowCount - 1 - row;

  float t = _mazeHeight - ((row + 1) * _cellHeight);
  float b = t + _cellHeight;
  float l = col * _cellWidth;
  float r = l + _cellWidth;

  Cell cell = getCell(row, col);

  if (cell.get(Direction.North) instanceof CellWall) {
    drawEdge(l, t, r, t, _mazeWallColor, _mazeWallWidth);
  }

  if (cell.get(Direction.East) instanceof CellWall) {
    drawEdge(r, t, r, b, _mazeWallColor, _mazeWallWidth);
  }
}

void drawCell(int row, int col) {
  row = _rowCount - 1 - row;

  float t = row * _cellHeight;
  float b = t + _cellHeight;
  float c = t + _cellHeight / 2;

  float l = col * _cellWidth;
  float r = l + _cellWidth;
  float m = l + _cellWidth / 2;

  drawEdge(l,c, r,c, _mazeGridColor, _mazeGridWidth);
  drawEdge(m,t, m,b, _mazeGridColor, _mazeGridWidth);
}

Cell getCell(Coordinates coordinates) {
  return _maze.get(coordinates);
}

Cell getCell(int row, int col) {
  return getCell(new Coordinates(row, col));
}

void drawMazeCells() {
  for (int row = 0; row < _rowCount; ++row) {
    for (int col = 0; col < _colCount; ++col) {
      drawCell(row, col);
    }
  }
}

void drawMazeWalls() {
  for (int row = 0; row < _rowCount; ++row) {
    for (int col = 0; col < _colCount; ++col) {
      drawCellWalls(row, col);
    }
  }
}

void drawMazeBackground() {
  noStroke();
  fill(_mazeBackgroundColor);
  rect(0, 0, _mazeWidth, _mazeHeight);

  drawMazeCells();

  noFill();
  stroke(_mazeBorderColor);
  strokeWeight(_mazeBorderWidth);
  rect(0, 0, _mazeWidth, _mazeHeight);
}

void drawMaze() {
  push();
  translate(_margin, _margin);
  drawMazeBackground();
  drawMazeWalls();
  pop();
}
