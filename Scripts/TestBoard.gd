extends Node2D

const BOARD_SIZE: int = 6
const EMPTY: int = 9
const HEXAGON: Object = preload("res://Scenes/Hexagon.tscn")
enum COLOUR {ORANGE, YELLOW}
enum CONTROLLER {COMPUTER, PLAYER}

const DIRECTIONS: Dictionary = {
	"UP": Vector2(-1,0), "DOWN": Vector2(1,0),
	"LEFT": Vector2(0,-1), "RIGHT": Vector2(0,1),
	"UP_LEFT": Vector2(-1,-1), "DOWN_RIGHT": Vector2(1,1)
}

const PAIRS: Dictionary = {
	"VERTICAL": [DIRECTIONS.UP, DIRECTIONS.DOWN],
	"HORIZONTAL": [DIRECTIONS.LEFT, DIRECTIONS.RIGHT], 
	"DIAGONAL": [DIRECTIONS.UP_LEFT, DIRECTIONS.DOWN_RIGHT]
}

const TEST_BOARD1: Array = [
	["E|Y|P", "E|Y|P", "E|Y|P", "E|Y|P", "E|O|P", "E|Y|P"],
	["E|Y|P", "3|Y|C", "2|Y|C", "E|Y|P", "E|Y|P", "3|Y|C"],
	["1|Y|C", "E|Y|P", "E|Y|P", "E|O|P", "E|Y|P", "1|Y|C"],
	["E|Y|P", "E|O|P", "E|O|P", "0|Y|C", "E|Y|P", "E|Y|P"],
	["E|O|P", "2|Y|C", "E|Y|P", "E|Y|P", "E|Y|P", "E|Y|P"],
	["E|Y|P", "E|Y|P", "E|Y|P", "0|Y|C", "E|Y|P", "E|Y|P"]
]

const TEST_BOARD2: Array = [
	["E|Y|P", "E|Y|P", "E|Y|P", "1|Y|C", "E|O|P", "E|Y|P"],
	["E|Y|P", "E|Y|P", "2|Y|C", "E|Y|P", "E|Y|P", "E|Y|P"],
	["E|Y|P", "E|Y|P", "E|Y|P", "E|O|P", "E|Y|P", "E|Y|P"],
	["E|Y|P", "E|O|P", "E|O|P", "E|Y|P", "E|Y|P", "E|Y|P"],
	["3|O|C", "E|Y|P", "E|Y|P", "E|Y|P", "E|Y|P", "E|Y|P"],
	["E|Y|P", "E|Y|P", "0|Y|C", "E|Y|P", "E|Y|P", "E|Y|P"]
]

# positioning constants
const START_POSITION: Vector2 = Vector2(410, 180)
const SHIFT_ALONG_ROW: Vector2 = Vector2(48, 28)
const SHIFT_ALONG_COL: Vector2 = Vector2(-48, 28)

var numberFrequency: Array = [0, 0, 0, 0] # frequency of 0, 1, 2, 3


# ------------------------------------------------- _READY() FUNCTION -------------------------------------------------
func _ready() -> void:
	var board: Array = TEST_BOARD1
	
	setUpNumberFrequency(board)
	print(solveBoard(board))
	drawBoard(board)
	printArray(board)
	
	# Testinig behaviour
	print(doesEachNumberAppearNineTimes())


# ------------------------------------------------- MAIN FUNCTIONS  -------------------------------------------------
func drawBoard(board: Array) -> void:
	for i in range(BOARD_SIZE):
		for j in range(BOARD_SIZE):
			var number: String = board[i][j].substr(0,1)
			var colour: String = board[i][j].substr(2,1)
			var controller: String = board[i][j].substr(4,1)
			drawHexagon(number, colour, Vector2(i,j), controller)


func printArray(board: Array) -> void:
	print("+-------+-------+-------+-------+-------+-------+")
	for i in range(BOARD_SIZE):
		print("| " + board[i][0] + " | " + board[i][1] + " | " + board[i][2] + " | " + board[i][3] + " | " + board[i][4] + " | " + board[i][5] + " |")
		print("+-------+-------+-------+-------+-------+-------+")


func solveBoard(board: Array) -> bool:
	for i in range(BOARD_SIZE):
		for j in range(BOARD_SIZE):
			var number: String = board[i][j].substr(0,1)
			var colour: String = board[i][j].substr(2,1)
			var controller: String = board[i][j].substr(4,1)
			if (number == "E" and controller == "P"):
				for n in range(4):
					# For debugging
#					print(String(n) + " [" + String(i) + " ," + String(j) + "]")
					
					if (checkValue(n, colour, Vector2(i,j), board)):
						# For debugging
#						print(String(n) + " is accepted")
						
						board[i][j] = String(n) + "|" + colour + "|P"
						numberFrequency[n] += 1
						
						# For debugging
#						drawBoard(board)
#						yield(get_tree().create_timer(0.5), "timeout")
						
						if (solveBoard(board)):
							return true
						board[i][j] = "E|" + colour + "|P"
						numberFrequency[n] -= 1
				#fixNeighbourPair(Vector2(i,j), board)
				#return false
	print("Solution Found")
	return true


# ------------------------------------------------- RULES OF THE GAME -------------------------------------------------
func checkValue(number: int, colour: String, gridPosition: Vector2, board: Array) -> bool:
	# Each number must appear exactly 9 times in total
	if (numberFrequency[number] >= 9):
		return false
	
	# Adjacent yellow hexagons contain different numbers
	if (colour == "Y"):
		for direction in DIRECTIONS.values():
			if(hasNeighbour(gridPosition, direction, board)):
				var neighbourNumber: int = int(board[gridPosition.x + direction.x][gridPosition.y + direction.y].substr(0,1))
				if (number == neighbourNumber):
					#print("Failed adjacent yellow check")
					return false
	
	# orange hexagon number >= all adjacent hexagon numbers (may be yellow or orange)
	for direction in DIRECTIONS.values():
		if(hasNeighbour(gridPosition, direction, board)):
			var neighbourNumber: int = int(board[gridPosition.x + direction.x][gridPosition.y + direction.y].substr(0,1))
			var neighbourColour: String = board[gridPosition.x + direction.x][gridPosition.y + direction.y].substr(2,1)
			
			if (colour == "O" and neighbourColour == "Y" and not(number >= neighbourNumber)):
				#print("Failed O-Y adjacent check")
				return false
			
			if (colour == "Y" and neighbourColour == "O" and not(number <= neighbourNumber)):
				#print("Failed Y-O adjacent check")
				return false
			
			if (colour == "O" and neighbourColour == "O" and not(number == neighbourNumber)):
				#print("Failed O-O adjacent check")
				return false
	
	# sum conditions updated
	for direction in DIRECTIONS.values():
		if (hasCreatedNeighbourPair(gridPosition, direction, board)):
			var neighbourSumColour: String = board[gridPosition.x + direction.x][gridPosition.y + direction.y].substr(2,1)
			var neighbourSumNumber: int = int(board[gridPosition.x + direction.x][gridPosition.y + direction.y].substr(0,1))
			var otherNeighbourNumber: int = int(board[gridPosition.x + 2*direction.x][gridPosition.y + 2*direction.y].substr(0,1))

			# orange hexagon number == sum of opposite neighbour pair hexagon numbers (may be yellow or orange)
			if ((neighbourSumColour == "O") and (number + otherNeighbourNumber != neighbourSumNumber)):
				#print("Failed Orange sum")
				return false

			# yellow hexagon number != sum of opposite neighbour pair hexagon numbers (may be yellow or orange)
			if ((neighbourSumColour == "Y") and (number + otherNeighbourNumber == neighbourSumNumber)):
				#print("Failed Yellow sum")
				return false
	
	return true


# ------------------------------------------------- UNIT TESTS -------------------------------------------------
func doesEachNumberAppearNineTimes() -> bool:
	var errorCounter: int = 0
	for i in range(numberFrequency.size()):
		if (numberFrequency[i] != 9):
			print("TEST FAILED: " + String(i) + " does not occur 9 times -- (" + String(numberFrequency[i]) + "/9)")
			errorCounter += 1
	if (errorCounter > 0):
		return false
	print("TEST PASSED: Each number appears 9 times")
	return true



# ---------------------------------------------- HELPER FUNCTIONS  -----------------------------------------------
func drawHexagon(number: String, colour: String, gridPosition: Vector2, controller: String) -> void:
	var hexagon: Object = HEXAGON.instance()
	
	if (number == "E"):
		hexagon.hexagonNumber = EMPTY
		hexagon.hideNumber()
	else:
		hexagon.hexagonNumber = int(number)
	
	match colour:
		"Y": hexagon.hexagonColour = COLOUR.YELLOW
		"O": hexagon.hexagonColour = COLOUR.ORANGE
	
	hexagon.position = gridToPixel(gridPosition)
	
	match controller:
		"C": hexagon.controller = CONTROLLER.COMPUTER
		"P": hexagon.controller = CONTROLLER.PLAYER
	
	add_child(hexagon)


func gridToPixel(gridPosition: Vector2) -> Vector2:
	var pixelPosition: Vector2 = START_POSITION + (gridPosition.x * SHIFT_ALONG_COL) + (gridPosition.y * SHIFT_ALONG_ROW)
	return pixelPosition


#func hasNeighbourPair(gridPosition: Vector2, pair: Array, board: Array) -> bool:
#	if (hasNeighbour(gridPosition, pair[0], board) and hasNeighbour(gridPosition, pair[1], board)):
#		return true
#	return false

func hasCreatedNeighbourPair(gridPosition: Vector2, direction: Vector2, board: Array) -> bool:
	if (hasNeighbour(gridPosition, direction, board) and hasNeighbour(gridPosition, 2*direction, board)):
		return true
	return false


func hasNeighbour(gridPosition: Vector2, direction: Vector2, board: Array) -> bool:
	var distance = gridPosition + direction
	if (distance.x < 0 or distance.y < 0 or distance.x > 5 or distance.y > 5):
		return false
	
	var neighbourNumber = board[distance.x][distance.y].substr(0,1)
	if (neighbourNumber == "E"):
		return false
	
	return true


func setUpNumberFrequency(board: Array) -> void:
	for i in range(6):
		for j in range(6):
			var number: String = board[i][j].substr(0,1)
			if (number != "E"):
				numberFrequency[int(number)] += 1


func fixNeighbourPair(gridPosition: Vector2, board: Array):
	var testBoard: Array = board
	var number: int = int(testBoard[gridPosition.x][gridPosition.y].substr(0,1))
	var colour: String = testBoard[gridPosition.x][gridPosition.y].substr(2,1)
	
	for direction in DIRECTIONS.values():
		if (hasCreatedNeighbourPair(gridPosition, direction, board)):
			var neighbourSumColour: String = testBoard[gridPosition.x + direction.x][gridPosition.y + direction.y].substr(2,1)
			var neighbourSumNumber: int = int(testBoard[gridPosition.x + direction.x][gridPosition.y + direction.y].substr(0,1))
			var otherNeighbourColour: String = testBoard[gridPosition.x + 2*direction.x][gridPosition.y + 2*direction.y].substr(2,1)
			var otherNeighbourNumber: int = int(testBoard[gridPosition.x + 2*direction.x][gridPosition.y + 2*direction.y].substr(0,1))
	
			# orange hexagon number == sum of opposite neighbour pair hexagon numbers (may be yellow or orange)
			if ((neighbourSumColour == "O") and (number + otherNeighbourNumber != neighbourSumNumber)):
				for n in range(4):
					testBoard[gridPosition.x][gridPosition.y] = String(n) + "|" + colour + "|P"
					var newNumber: int = int(testBoard[gridPosition.x][gridPosition.y].substr(0,1))
					
					testBoard[gridPosition.x + 2*direction.x][gridPosition.y + 2*direction.y] = String(neighbourSumNumber - n) + "|" + otherNeighbourColour + "|P"
					var newNeighbourNumber: int = int(testBoard[gridPosition.x + 2*direction.x][gridPosition.y + 2*direction.y].substr(0,1))
					
					if (checkValue(newNumber, colour, gridPosition, testBoard) and checkValue(newNeighbourNumber, otherNeighbourColour, gridPosition + direction, testBoard)):
						board[gridPosition.x][gridPosition.y] = String(newNumber) + "|" + colour + "|P"
						board[gridPosition.x + 2*direction.x][gridPosition.y + 2*direction.y] = String(newNeighbourNumber) + "|" + otherNeighbourColour + "|P"
						break
						#return true
	
			# yellow hexagon number != sum of opposite neighbour pair hexagon numbers (may be yellow or orange)
			if ((neighbourSumColour == "Y") and (number + otherNeighbourNumber == neighbourSumNumber)):
				print("Failed Yellow sum")
	#return false



