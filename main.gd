extends Control

const ELEMENT := preload("res://element.tscn")
const FILE_PATH := "user://text_database.txt"
const SEP := "\n|\n"

var text := ""
var text_normalized := ""

func _ready():
	load_file()
	$VBoxContainer/Add.pressed.connect(add_text)
	$VBoxContainer/Search.pressed.connect(search)
	$Delete/VBoxContainer/HBoxContainer/Yes.pressed.connect(confirm_delete)
	$Delete/VBoxContainer/HBoxContainer/No.pressed.connect($Delete.hide)
	
	$Delete.hide()

func set_text(t: String):
	text = t
	text_normalized = t.to_lower()

func load_file():
	if FileAccess.file_exists(FILE_PATH):
		text = FileAccess.get_file_as_string(FILE_PATH)
		text_normalized = text.to_lower()

func save_file():
	var f := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	f.store_string(text)

var to_delete = null
func confirm_delete():
	delete(to_delete.pos, to_delete.text_length)
	to_delete.queue_free()
	$Delete.hide()

func ask_delete(obj):
	to_delete = obj
	$Delete.show()

func delete(pos: int, s: int):
	set_text(text.erase(pos, s + SEP.length()))
	save_file()

func add_element(idx: int, pos: int, length: int, searched: String):
	var e := ELEMENT.instantiate()
	e.idx = idx
	e.pos = pos
	e.text = text.substr(pos, length)
	e.searched = searched
	$VBoxContainer/ScrollContainer/VBoxContainer.add_child(e)

func search():
	var to_search : String = $VBoxContainer/TextSearch.text.to_lower()
	if to_search.strip_edges() == "":
		return
	
	for child in $VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	
	
	var pos := 0
	var i := 0
	for element in text_normalized.split(SEP):
		if element.contains(to_search):
			i += 1
			add_element(i, pos, element.length(), to_search)
		pos += SEP.length() + element.length()


func add_text():
	set_text(text + $VBoxContainer/TextAdd.text + SEP)
	$VBoxContainer/TextAdd.clear()
	save_file()
