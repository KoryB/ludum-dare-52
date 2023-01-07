class_name State


func on_enter(_target):
    pass
    
func on_leave(_target):
    pass
    
func pre_update(_target, _delta: float) -> State:
    return self
    
func update(_target, _delta: float) -> State:
    return self
    
func post_update(_target, _delta: float) -> State:
    return self
