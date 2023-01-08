class_name BugGoToTargetState extends State


var target_switch_timer := 0.0


func on_enter(target):
    target_switch_timer = 0.0


func pre_update(target, delta: float) -> State:
    if !is_instance_valid(target.target):
        target.choose_new_target()
        
    target_switch_timer += delta
        
    return self


func update(target, _delta: float) -> State:
    var dir = (target.target.global_position - target.global_position).normalized()
    target.target_velocity = target.move_speed * dir
    
    if target_switch_timer >= target.target_switch_time:
        if target.target is Player:
            target.choose_new_target()
    
    return self

