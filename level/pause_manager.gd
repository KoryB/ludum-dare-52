extends Node


var is_paused := false


func _physics_process(_delta: float):
    if Input.is_action_just_pressed("menu"):
        is_paused = not is_paused
