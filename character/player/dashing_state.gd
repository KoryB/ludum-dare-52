class_name PlayerDashingState extends State


var idle_state: State

func set_dependencies(idle_state: State):
    self.idle_state = idle_state
    
    
func on_enter(target):
    target.dash_timer = 0.0
    target.set_scythe_impulse_multiplier(2.0)
     # TODO: Do we want to dash based on target current base_velocity?
    target.target_velocity = target.dash_speed * target.get_local_mouse_position().normalized()
    target.set_facing_direction(target.target_velocity.normalized())
    

func on_leave(target):
    target.set_scythe_impulse_multiplier(1.0)


func pre_update(target, _delta: float) -> State:
    if target.is_attack:
        target.attack()
    
    return self
    
    
func update(target, delta: float) -> State:
    target.dash_timer += delta
    
    return self    


func post_update(target, _delta: float) -> State:
    if target.dash_timer >= target.dash_time:
        return idle_state
        
    return self
