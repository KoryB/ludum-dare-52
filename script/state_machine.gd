class_name StateMachine


var state: State
var states := []


func add_state(state: State):
    states.append(state)
    
    if state == null:
        state = state
        

func set_state(new_state: State):
    state = new_state
        

func pre_update(target, delta: float):
    var new_state = state.pre_update(target, delta)
    
    enter_state(target, new_state)
    

func update(target, delta: float):
    var new_state = state.update(target, delta)
    
    enter_state(target, new_state)
    

func post_update(target, delta: float):
    var new_state = state.post_update(target, delta)
    
    enter_state(target, new_state)
    

func enter_state(target, new_state: State):
    assert(new_state != null, "Trying to enter a null state, check your return values!")

    if new_state != state:
        if state != null:
            state.on_leave(target)
        
        new_state.on_enter(target)
        set_state(new_state)
