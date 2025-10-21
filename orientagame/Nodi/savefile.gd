extends Node
class_name SaveFile
static var collectibles_discovered : Dictionary[String, bool] = {
	"ComputerVecchio" : false, 
	"caffe" : false, 
	"Timbro dell'inizio" : false, 
	"Libro in prestito" : false, 
	"Gameboy" : false, 
	"Rotolo d'oro" : false, 
	"Appunti del mentore" : false, 
	"BlueBull" : false
}

static func discover(oggetto: String):
	print("Hai raccolto ", oggetto, "!")
	collectibles_discovered[oggetto] = true
	
static var combat_current_agent
static var tutorial_done :bool= false

#func _ready() -> void:
	#if Engine.is_editor_hint():
		#tutorial_done= true
