class_name PlayerDashingState extends State


var idle_state: State

func set_dependencies(idle_state: State):
    self.idle_state = idle_state
    
    
func on_enter(target):
    target.dash_timer = 0.0
    target.target_velocity = target.dash_speed * target.get_local_mouse_position().normalized()


func pre_update(target, delta: float) -> State:
    target.dash_timer += delta
    
    return self


func post_update(target, _delta: float) -> State:
    if target.dash_timer >= target.dash_time:
        return idle_state
        
    return self
