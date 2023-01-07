class_name BugStunState extends State


var stun_timer := 0.0

var return_state: State

func set_dependencies(return_state: State):
    self.return_state = return_state
    
    
func on_enter(target):
    stun_timer = 0.0
    target.target_velocity = Vector2.ZERO
    
    
func update(target, delta: float):
    stun_timer += delta
    
    if stun_timer > target.stun_time:
        return return_state
        
    return self
