class_name Arena extends Area2D


var is_first_frame := true


func _physics_process(delta: float):
    # I'm guessing the collision system hasn't had a chance to calculate overlaps on the first frame
    if is_first_frame:
        is_first_frame = false
        return
        
    var characters = get_tree().get_nodes_in_group("Character")
    
    for character in characters:
        if not overlaps_body(character):
            character.kill()
