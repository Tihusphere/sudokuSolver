extends VBoxContainer

@export var RowTemplate : Node
@export var NumTemplate : Node
@export var MainBoard : Node
@export var selectedCell = []
@export var SpacerTemplate: Node

var board = boardValues()

var rows = []
var items = [[],[],[],[],[],[],[],[],[]]

var solution = []
var shownSolution = []

func _ready():
	drawBoard()
	
func setValue(num):
	if not selectedCell == []: 
		board[selectedCell[0]][selectedCell[1]] = num
		if not checkValid(board):
			board[selectedCell[0]][selectedCell[1]] = 0
			selectedCell = []
		else:
			items[selectedCell[0]][selectedCell[1]].fill(num)
	if checkGameOver():
		if checkValid(board):
			get_tree().change_scene_to_file('res://scenes/win.tscn')
		else:
			get_tree().change_scene_to_file('res://scenes/lose.tscn')

func removeValue():
	if selectedCell != []:
		board[selectedCell[0]][selectedCell[1]] = 0
		items[selectedCell[0]][selectedCell[1]].clear()
		selectedCell=[]

func checkGameOver():
	for row in board:
		for col in row:
			if col == 0: return false
	return true

func checkValid(brd):
	var foundNums = []
	for row in brd:
		foundNums = []
		for col in row:
			if col != 0 and col in foundNums: 
				return false
			foundNums.append(col)
	for c in range(9):
		foundNums = []
		for r in range(9):
			if brd[r][c] != 0 and brd[r][c] in foundNums: 
				return false
			foundNums.append(brd[r][c])
	for block in findBlocks(brd):
		foundNums = []
		for num in block:
			if num != 0 and num in foundNums: 
				return false
			foundNums.append(num)
	return true
	
func findBlocks(brd):
	var blocks = []
	for r in range(0,9,3):
		for c in range(0,9,3):
			var block = []
			for rr in range(3):
				for cc in range(3):
					block.append(brd[r+rr][c+cc])
			blocks.append(block)
	return blocks

func boardValues():
	var b = []
	for i in range(9):
		b.append([0,0,0,0,0,0,0,0,0])
	return b

func drawBoard():
	for i in range(9):
		if i%3 == 0:
			var spacer = SpacerTemplate.duplicate()
			spacer.visible = true
			MainBoard.add_child(spacer)
		var row = RowTemplate.duplicate()
		row.visible = true
		MainBoard.add_child(row)
		rows.append(row)
		for j in range(9):
			if j%3 == 0:
				var spacer = SpacerTemplate.duplicate()
				spacer.visible = true
				row.add_child(spacer)
			var num = NumTemplate.duplicate()
			num.visible = true
			num.pos = [i,j]
			row.add_child(num)
			items[i].append(num)

func resetBoard(level):
	for n in MainBoard.get_children():
		MainBoard.remove_child(n)
		n.queue_free()
	rows = []
	items = [[],[],[],[],[],[],[],[],[]]
	board = boardValues()
	drawBoard()
	generateGame(level)
	
func generateSolution():
	var brd = boardValues()
	var nums = [1,2,3,4,5,6,7,8,9]
	for r in range(9):
		var ind = randi_range(0,len(nums)-1)
		brd[r][0] = nums[ind]
		nums.pop_at(ind)
	
	var testBrd = [
	 [ 5, 3, 0, 0, 7, 0, 0, 0, 0 ],
	 [ 6, 0, 0, 1, 9, 5, 0, 0, 0 ],
	 [ 0, 9, 8, 0, 0, 0, 0, 6, 0 ],
	 [ 8, 0, 0, 0, 6, 0, 0, 0, 3 ],
	 [ 4, 0, 0, 8, 0, 3, 0, 0, 1 ],
	 [ 7, 0, 0, 0, 2, 0, 0, 0, 6 ],
	 [ 0, 6, 0, 0, 0, 0, 2, 8, 0 ],
	 [ 0, 0, 0, 4, 1, 9, 0, 0, 5 ],
	 [ 0, 0, 0, 0, 8, 0, 0, 7, 9 ]
	]
	print(sudokuSolver(brd))
	return sudokuSolver(brd)

func generateGame(level):
	solution = generateSolution()
	shownSolution = boardValues()
	for r in range(9):
		for c in range(9):
			shownSolution[r][c] = solution[r][c]
	for r in range(9):
		var toKeep = []
		for i in range(4-level):
			var newNum = randi_range(0,8)
			while newNum in toKeep:
				newNum = randi_range(0,8)
			toKeep.append(newNum)
		for c in range(9):
			if c in toKeep: 
				continue
			else:
				shownSolution[r][c] = 0
	drawGame()

func drawGame():
	board = boardValues()
	for r in range(9):
		for c in range(9):
			board[r][c] = shownSolution[r][c]
	for r in range(9):
		for c in range(9):
			if shownSolution[r][c] == 0: continue
			items[r][c].fill(shownSolution[r][c])

func resetGame():
	for n in MainBoard.get_children():
		MainBoard.remove_child(n)
		n.queue_free()
	rows = []
	items = [[],[],[],[],[],[],[],[],[]]
	board = boardValues()
	drawBoard()
	drawGame()

func sudokuSolver(brd):
	var found = false
	for r in brd:
		for c in r:
			if c == 0: found = true
	if found == false: return brd
	else:
		var row = null
		var col = null
		for r in range(9):
			for c in range(9):
				if brd[r][c] == 0 and row == null and col == null:
					row = r
					col = c
					break
		for n in range(1,10):
			brd[row][col] = n
			if checkValid(brd):
				var solved = sudokuSolver(brd)
				if solved: return solved
			brd[row][col] = 0
		return null
