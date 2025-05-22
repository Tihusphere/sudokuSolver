extends Button

@export var pos = []
@export var Board : Node
@export var override : String
func _on_pressed():
	Board.selectedCell = pos

func fill(num):
	self.add_theme_stylebox_override("normal",load(override))
	self.text = str(num)

func clear():
	self.remove_theme_stylebox_override("normal")
	self.text = ''
