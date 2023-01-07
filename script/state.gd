class_name State


func on_enter(target):
    pass
    
func on_leave(target):
    pass
    
func pre_update(target, delta: float) -> State:
    return self
    
func update(target, delta: float) -> State:
    return self
    
func post_update(target, delta: float) -> State:
    return self
