extends Node2D

# Member variables
export (int, "ORANGE", "YELLOW", "PURPLE", "GREEN", "LIME") var hexagonColour = 1
export (int, "COMPUTER", "PLAYER") var controller = 1
export (int, 3) var hexagonNumber = 2

# Constants
const PLAYER_NUMBERS: Dictionary = {0: 9, 1: 0, 2: 1, 3: 2} # number: frame
const COMPUTER_NUMBERS: Dictionary = {0: 19, 1: 10, 2: 11, 3: 12} # number: frame
const START_POSITION: Vector2 = Vector2(410, 180)
const SHIFT_ALONG_ROW: Vector2 = Vector2(48, 28)
const SHIFT_ALONG_COL: Vector2 = Vector2(-48, 28)
const DIRECTION_SET: Dictionary = {"UP": Vector2(0,-1), "DOWN": Vector2(0,1), "LEFT": Vector2(-1,0), "RIGHT": Vector2(1,0), "UP_LEFT": Vector2(-1,-1), "DOWN_RIGHT": Vector2(1,1)}
enum COLOUR_SET {ORANGE, YELLOW}

func _ready() -> void:
	$"Hexagon Sprite".frame = hexagonColour
	
	match controller:
		0: $"Number Sprite".frame = COMPUTER_NUMBERS[hexagonNumber]
		1: $"Number Sprite".frame = PLAYER_NUMBERS[hexagonNumber]

func isHexagonValid(boardArray: Array) -> bool:
	var gridPosition: Vector2 = pixelToGrid()
	
	# CONDITIONS
	# each number must appear exactly 9 times in total
	if (frequencyOf(hexagonNumber, boardArray) >= 9):
		return false
	
	# adjacent yellow hexagons contain different numbers
	for direction in DIRECTION_SET.values():
		if ((hexagonColour == COLOUR_SET.YELLOW) and (hasNeighbour(direction))):
			var neighbour = boardArray[gridPosition.x + direction.x][gridPosition.y + direction.y]
			if ((neighbour != null) and (neighbour.hexagonColour == COLOUR_SET.YELLOW) and (neighbour.hexagonNumber == hexagonNumber)):
				return false
	
	return true

func frequencyOf(value: int, boardArray: Array) -> int:
	var frequency = 0;
	for i in range(boardArray.size()):
		for j in range (boardArray[i].size()):
			if ((boardArray[i][j] != null) and (boardArray[i][j].hexagonNumber == value)):
				frequency += 1
	return frequency

func hasNeighbour(direction: Vector2) -> bool:
	var gridPosition: Vector2 = pixelToGrid()
	var distance = gridPosition + direction
	if (distance.x < 0 or distance.y < 0 or distance.x > 5 or distance.y > 5):
		return false
	return true

func pixelToGrid() -> Vector2:
	var pixelPosition: Vector2 = position
	var gridPosition: Vector2 = Vector2.ZERO
	gridPosition.x = ((SHIFT_ALONG_COL.x * (START_POSITION.y - pixelPosition.y))  +  (SHIFT_ALONG_COL.y * (pixelPosition.x - START_POSITION.x))) / ((SHIFT_ALONG_ROW.x * SHIFT_ALONG_COL.y) - (SHIFT_ALONG_ROW.y * SHIFT_ALONG_COL.x))
	gridPosition.y = ((SHIFT_ALONG_ROW.y * (pixelPosition.x - START_POSITION.x)) + (SHIFT_ALONG_ROW.x * (START_POSITION.y - pixelPosition.y))) / ((SHIFT_ALONG_COL.x * SHIFT_ALONG_ROW.y) - (SHIFT_ALONG_COL.y * SHIFT_ALONG_ROW.x))
	return gridPosition





