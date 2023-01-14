extends Node2D

# Member variables
export (int, "ORANGE", "YELLOW", "PURPLE", "GREEN", "LIME") var hexagonColour = 1
export (int, "COMPUTER", "PLAYER") var controller = 1
export (int, 3) var hexagonNumber = 2

# Constants
const PLAYER_NUMBERS: Dictionary = {0: 9, 1: 0, 2: 1, 3: 2, 9: 8} # number: frame
const COMPUTER_NUMBERS: Dictionary = {0: 19, 1: 10, 2: 11, 3: 12, 9: 18} # number: frame
const START_POSITION: Vector2 = Vector2(410, 180)
const SHIFT_ALONG_ROW: Vector2 = Vector2(48, 28)
const SHIFT_ALONG_COL: Vector2 = Vector2(-48, 28)
const DIRECTION_SET: Dictionary = {"UP": Vector2(-1,0), "DOWN": Vector2(1,0), "LEFT": Vector2(0,-1), "RIGHT": Vector2(0,1), "UP_LEFT": Vector2(-1,-1), "DOWN_RIGHT": Vector2(1,1)}
const NEIGHBOUR_PAIRS: Dictionary = {"VERTICAL": [DIRECTION_SET.UP, DIRECTION_SET.DOWN], "HORIZONTAL": [DIRECTION_SET.LEFT, DIRECTION_SET.RIGHT], "DIAGONAL": [DIRECTION_SET.UP_LEFT, DIRECTION_SET.DOWN_RIGHT]}
enum COLOUR_SET {ORANGE, YELLOW}

func _ready() -> void:
	$"Hexagon Sprite".frame = hexagonColour
	
	match controller:
		0: $"Number Sprite".frame = COMPUTER_NUMBERS[hexagonNumber]
		1: $"Number Sprite".frame = PLAYER_NUMBERS[hexagonNumber]


# ------------------------------------------------

func hideNumber() -> void:
	$"Number Sprite".hide()

func showNumber() -> void:
	$"Number Sprite".show()


# ------------------------------------------------


func isHexagonValid(boardArray: Array) -> bool:
	var gridPosition: Vector2 = pixelToGrid()

	if (hexagonNumber == 9):
		return false


	# CONDITIONS
	# each number must appear exactly 9 times in total
	if (frequencyOf(hexagonNumber, boardArray) >= 9):
		return false

	# adjacent yellow hexagons contain different numbers
	for direction in DIRECTION_SET.values():
		if ((hexagonColour == COLOUR_SET.YELLOW) and (hasNeighbour(direction))):
			var neighbour: Object = boardArray[gridPosition.x + direction.x][gridPosition.y + direction.y]
			if ((neighbour != null) and (neighbour.hexagonColour == COLOUR_SET.YELLOW) and (neighbour.hexagonNumber == hexagonNumber)):
				return false

	# orange hexagon numbers >= adjacent hexagon numbers (both yellow & orange)
	for direction in DIRECTION_SET.values():
		if ((hexagonColour == COLOUR_SET.ORANGE) and (hasNeighbour(direction))):
			var neighbour: Object = boardArray[gridPosition.x + direction.x][gridPosition.y + direction.y]
			if ((neighbour != null) and (neighbour.hexagonColour == COLOUR_SET.YELLOW) and (neighbour.hexagonNumber > hexagonNumber)):
				return false 
			if ((neighbour != null) and (neighbour.hexagonColour == COLOUR_SET.ORANGE) and (neighbour.hexagonNumber != hexagonNumber)):
				return false 
#		# yellow hexagon numbers <= adjacent orange hexagon numbers
#		if ((hexagonColour == COLOUR_SET.YELLOW) and (hasNeighbour(direction))):
#			var neighbour: Object = boardArray[gridPosition.x + direction.x][gridPosition.y + direction.y]
#			if ((neighbour != null) and (neighbour.hexagonColour == COLOUR_SET.ORANGE) and (hexagonNumber > neighbour.hexagonNumber)):
#				return false 
#
#	# opposite pair of neighbours sum
	for pair in NEIGHBOUR_PAIRS.values():
		if (hasCreatedNeighbourPair(boardArray, pair)):
			var hexagonToCheck: Object = boardArray[gridPosition.x + pair[0].x][gridPosition.y + pair[0].y]
			var otherNeighbour: Object = boardArray[gridPosition.x + (2*pair[0].x)][gridPosition.y + (2*pair[0].y)]
			
			# opposite pair of neighbours of an orange hexagon must sum to the orange hehxagon number
			if ((hexagonToCheck.hexagonColour == COLOUR_SET.ORANGE) and (otherNeighbour.hexagonNumber + hexagonNumber != hexagonToCheck.hexagonNumber)):
				return false
			
			# opposite pair of neighbours of a yellow hexagon must not sum to the yellow hehxagon number
			if ((hexagonToCheck.hexagonColour == COLOUR_SET.YELLOW) and (otherNeighbour.hexagonNumber + hexagonNumber == hexagonToCheck.hexagonNumber)):
				return false

#	for pair in NEIGHBOUR_PAIRS.values():
#		if (hasNeighbourPair(pair)):
#			var neighbour0 = boardArray[gridPosition.x + pair[0].x][gridPosition.y + pair[0].y]
#			var neighbour1 = boardArray[gridPosition.x + pair[1].x][gridPosition.y + pair[1].y]
#			if ((neighbour0 != null) and (neighbour1 != null)):
#				# opposite pair of neighbours of an orange hexagon must sum to the orange hehxagon number
#				if ((hexagonColour == COLOUR_SET.ORANGE) and (neighbour0.hexagonNumber + neighbour1.hexagonNumber != hexagonNumber)):
#					return false
#				# opposite pair of neighbours of a yellow hexagon must not sum to the yellow hehxagon number
#				if ((hexagonColour == COLOUR_SET.YELLOW) and (neighbour0.hexagonNumber + neighbour1.hexagonNumber == hexagonNumber)):
#					return false
	
	return true

func frequencyOf(value: int, boardArray: Array) -> int:
	var frequency = 0;
	for i in range(boardArray.size()):
		for j in range (boardArray[i].size()):
			if ((boardArray[i][j] != null) and (boardArray[i][j].hexagonNumber == value)):
				frequency += 1
	return frequency

func hasCreatedNeighbourPair(boardArray: Array, pair: Array) -> bool:
	# pair[0] = UP, LEFT or UP_LEFT
	if (hasNeighbour(pair[0])):
		var gridPosition: Vector2 = pixelToGrid()
		var neighbour: Object = boardArray[gridPosition.x + pair[0].x][gridPosition.y + pair[0].y]
		if (neighbour.hasNeighbour(pair[0])):
			return true
	return false

func hasNeighbourPair(pair: Array) -> bool:
	if (hasNeighbour(pair[0]) and hasNeighbour(pair[1])):
		return true
	return false

func hasNeighbour(direction: Vector2) -> bool:
	var gridPosition: Vector2 = pixelToGrid()
	var distance = gridPosition + direction
	if (distance.x < 0 or distance.y < 0 or distance.x > 5 or distance.y > 5):
		return false
	return true

func pixelToGrid() -> Vector2:
	var pixelPosition: Vector2 = position
	var gridPosition: Vector2 = Vector2.ZERO
	gridPosition.x = ((SHIFT_ALONG_ROW.x * (START_POSITION.y - pixelPosition.y))  +  (SHIFT_ALONG_ROW.y * (pixelPosition.x - START_POSITION.x))) / ((SHIFT_ALONG_COL.x * SHIFT_ALONG_ROW.y) - (SHIFT_ALONG_COL.y * SHIFT_ALONG_ROW.x))
	gridPosition.y = ((SHIFT_ALONG_COL.y * (pixelPosition.x - START_POSITION.x)) + (SHIFT_ALONG_COL.x * (START_POSITION.y - pixelPosition.y))) / ((SHIFT_ALONG_ROW.x * SHIFT_ALONG_COL.y) - (SHIFT_ALONG_ROW.y * SHIFT_ALONG_COL.x))
	return gridPosition
