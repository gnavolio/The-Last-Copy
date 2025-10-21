extends Node
class_name  Settingss

static var collegamenti: Dictionary[String, PackedScene] = {
	"DIB": load("res://Scene/Pianterreno/livello_pianterreno.tscn"),
	"retro" : load("res://Scene/Retro/RetroDib.tscn"),
	"giardini" : load("res://Scene/Esterno/livello_giardini.tscn")
}
static var survey_link := "https://forms.gle/2HuaVru25BER9Wz28"
