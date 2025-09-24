extends HBoxContainer

var OFFSET1 :=  "[color=red]".length()
var OFFSET2 := "[/color]".length()

var idx := 0
var pos := 0
var text := ""
var searched := ""

var text_length := 0
func _ready():
	$ID.text = str(idx) + "."
	
	text_length = text.length()
	
	var t := text.to_lower()
	
	var last : int = t.find(searched, 0)
	var offset := 0
	while last != -1:
		text = text.insert(last + offset, "[color=red]")
		offset += OFFSET1
		text = text.insert(last + offset + searched.length(), "[/color]")
		offset += OFFSET2
		last = t.find(searched, last + 1)
	
	$Text.text = text
	$Button.pressed.connect(delete)


func delete():
	get_node("../../../../").ask_delete(self)
