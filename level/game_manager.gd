class_name GameManager extends Node

export var bush_path: NodePath
export var arena_path: NodePath

var arena: Arena
var bush: Bush


func _ready():
    bush = get_node(bush_path)
    arena = get_node(arena_path)
    
    var _on_berry = bush.connect("berry_created", self, "on_berry_created")
    
    
func on_berry_created(berry: Berry):
    berry.connect("harvested", self, "on_berry_harvested")
    berry.connect("eaten", self, "on_berry_eaten")
    
    
func on_berry_harvested(berry: Berry):
    print("Berry harvested!")
    
    
func on_berry_eaten(berry: Berry, bug: Bug):
    print("Berry eaten!")
