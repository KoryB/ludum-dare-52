class_name Arena extends Area2D


signal bug_killed(bug)

export var radius := 800.0
var is_first_frame := true


func _physics_process(_delta: float):
    if not PauseManager.is_paused:
        var bugs = get_tree().get_nodes_in_group("Bug")
        
        for bug in bugs:
            if bug.life > 0 and not overlaps_body(bug):
                bug.kill()
                emit_signal("bug_killed", bug)
