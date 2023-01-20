extends Node2D

const BOARD_SIZE: int = 6




var random: Object = RandomNumberGenerator.new() 
var possibleNumbers: Array = [0, 1, 2, 3]
var numberFrequency: Array = [0, 0, 0, 0] # frequency of 0, 1, 2, 3
var possibleColours: Array = ["O", "Y"]



# ------------------------------------------------- MAIN FUNCTIONS  -------------------------------------------------
func generateBoard():
	var board: Array = []
	random.randomize()
	for i in range(BOARD_SIZE):
		board.append([])
		for j in range(BOARD_SIZE):
			board[i].append()
			possibleNumbers.shuffle()
			var colour: String = possibleColours[rand_range(0, possibleColours.size())]
			for k in range(possibleNumbers.size()):
				var number: int = possibleNumbers[k]
				if (true):
					pass
				
				
			
			













# ---------------------------------------------- HELPER FUNCTIONS  -----------------------------------------------
