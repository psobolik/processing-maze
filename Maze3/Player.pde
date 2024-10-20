class Player {
    private final float _halfHeight;
    private final float _height;

    private Coordinates _coordinates;
    private Direction _heading = Direction.North;

    private final float _playerScale = 0.65;
    private color _strokeColor = color(0);
    private color _fillColor = color(255, 255, 255);

    public Player(float height, color strokeColor, color fillColor) {
        this(height, 0, 0, strokeColor, fillColor);
    }

    public Player(float height, int col, int row, color strokeColor, color fillColor) {
        this(height, new Coordinates(col, row), strokeColor, fillColor);
    }

    public Player(float height, Coordinates coordinates, color strokeColor, color fillColor) {
        _strokeColor = strokeColor;
        _fillColor = fillColor;
        _halfHeight = height / 2;
        _height = height;
        _coordinates = coordinates;
    }

    public Direction getHeading() { return _heading; }
    public void setHeading(Direction heading) {
        if (heading != _heading) {
            _heading = heading;
        }
    }
    public Coordinates getCoordinates() { return _coordinates; }
    public void setCoordinates(Coordinates coordinates) { _coordinates = coordinates; }
    public void setCoordinates(int col, int row) { setCol(col); setRow(row); }

    public int getCol() { return _coordinates.getCol(); }
    public void setCol(int col) { _coordinates.setCol(col); }

    public int getRow() { return _coordinates.getRow(); }
    public void setRow(int row) { _coordinates.setRow(row); }

    public float getHalfHeight() { return _halfHeight; }
    public float getHeight() { return _height; }

    private void move(Coordinates direction) {
        _coordinates = _coordinates.plus(direction);
    }

    public void moveForward() {
        move(Coordinates.Companion.getUp());
    }

    public void moveRight() {
        move(Coordinates.Companion.getRight());
    }

    public void moveBackward() {
        move(Coordinates.Companion.getDown());
    }

    public void moveLeft() {
        move(Coordinates.Companion.getLeft());
    }


    private float getAngle(Direction heading) {
        float angle = 0;
        float r = (float)Math.PI / 180;
        switch (heading) {
            case East:
                angle = 90 * r;
                break;
            case South:
                angle = 180 * r;
                break;
            case West:
                angle = 270 * r;
                break;
        }
        return angle;
    }

    public void draw(float xOffset, float yOffset) {
        translate(xOffset, yOffset);
        scale(_playerScale);
        rotate(getAngle(_heading));
        push();
        stroke(_strokeColor);
        fill(_fillColor);
        triangle(0,-_halfHeight, -(_halfHeight - 2),_halfHeight, (_halfHeight - 2),_halfHeight);
        pop();
    }
}
