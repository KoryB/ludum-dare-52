class_name PlayerIdleState extends State

var dashing_state: State

func set_dependencies(dashing_state: State):
    self.dashing_state = dashing_state


func pre_update(target, _delta: float) -> State:
    var dir := Vector2(0, 0)
    
    if target.is_left:
        dir += Vector2.LEFT
    
    if target.is_right:
        dir += Vector2.RIGHT
        
    if target.is_up:
        dir += Vector2.UP
        
    if target.is_down:
        dir += Vector2.DOWN
    
    if target.is_dash and target.can_dash():
        return self.dashing_state
    elif dir.is_equal_approx(Vector2(0, 0)):
        target.target_velocity = Vector2(0, 0)
    else:
        target.target_velocity = target.move_speed * dir.normalized()
    
    if target.is_attack and target.can_attack():
        target.set_scythe_position( # TODO: We may want this on the `attack` function, unsure
            target.scythe_distance * 
            target.get_local_mouse_position().normalized())
        target.attack()
        
    return self
