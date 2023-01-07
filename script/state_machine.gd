class_name StateMachine


var current_state: State
var states := []


func add_state(state: State):
    states.append(state)
    
    if current_state == null:
        current_state = state
        

func set_initial_state(state: State):
    current_state = state
    

func pre_update(target, delta: float):
    var new_state = current_state.pre_update(target, delta)
    
    handle_new_state(target, new_state)
    

func update(target, delta: float):
    var new_state = current_state.update(target, delta)
    
    handle_new_state(target, new_state)
    

func post_update(target, delta: float):
    var new_state = current_state.post_update(target, delta)
    
    handle_new_state(target, new_state)
    

func handle_new_state(target, new_state: State):
    if new_state != current_state:
        current_state.on_leave(target)
        new_state.on_enter(target)
        
        current_state = new_state
