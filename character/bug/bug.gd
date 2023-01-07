class_name Bug extends Character


export var target_switch_time := 1.0
export var move_speed := 150.0
export var stun_time := 1.0 # TODO: Move this to the scythe, based on impulse?

var target: Node2D

var go_to_target_state: BugGoToTargetState
var stun_state: BugStunState

func _ready():
    go_to_target_state = BugGoToTargetState.new()
    stun_state = BugStunState.new()
    
    stun_state.set_dependencies(go_to_target_state) # TODO: Maybe make some stack based go back system in the SM?
    
    state_machine.add_state(go_to_target_state)
    state_machine.add_state(stun_state)
    
    state_machine.enter_state(self, go_to_target_state)


func on_hit():
    state_machine.enter_state(self, stun_state)


func on_die():
    queue_free()
    
    
func choose_new_target():
    var berries = get_tree().get_nodes_in_group("Berry")
    
    if berries.empty():
        target = get_tree().get_nodes_in_group("Player")[0]
        
    else:
        target = berries[randi() % berries.size()]
