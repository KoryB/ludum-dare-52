class_name Player extends Character


export var move_speed := 150.0
export var dash_distance := 200.0
export var dash_time := 0.3

onready var dash_speed := dash_distance / dash_time

enum State {
    Idle,
    Moving,
    Dashing,
    Shielding,
    ShieldDashing,
    Attack1,
    Attack2,
    Attack3
}

var is_left := false
var is_right := false
var is_up := false
var is_down := false

var is_dash := false
var is_attack := false
var is_shield := false

var current_state = State.Idle

var dash_timer := 0.0

var state_machine := StateMachine.new()
var idle_state := PlayerIdleState.new()
var dashing_state := PlayerDashingState.new()


func _ready():
    idle_state.set_dependencies(dashing_state)
    dashing_state.set_dependencies(idle_state)

    state_machine.add_state(idle_state)
    state_machine.add_state(dashing_state)
    
    state_machine.set_initial_state(idle_state)


func _physics_process(delta: float):
    handle_input()
    state_machine.pre_update(self, delta)
    state_machine.update(self, delta)
    state_machine.post_update(self, delta)
    
    
func handle_input():
    is_left = Input.is_action_pressed("player_left")
    is_right = Input.is_action_pressed("player_right")
    
    is_up = Input.is_action_pressed("player_up")
    is_down = Input.is_action_pressed("player_down")
        
    is_dash = Input.is_action_just_pressed("player_dash")
    is_attack = Input.is_action_just_pressed("player_attack")        
    is_shield = Input.is_action_pressed("player_shield")
    
    
func do_update(delta: float):
    update_physics(delta)
    

func can_dash():
    return true
