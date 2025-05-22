extends VBoxContainer

@export var row1 : Node
@export var row2 : Node
@export var numTemplate : Node
var rows = [row1, row2]
# Called when the node enters the scene tree for the first time.
func _ready():
	rows = [row1, row2]
	addNums()

func addNums():
	for i in range(2):
		for n in range(5):
			var number = 5*i + n + 1
			if number == 10: continue
			var button = numTemplate.duplicate()
			button.visible = true
			button.text = str(number)
			rows[i].add_child(button)
