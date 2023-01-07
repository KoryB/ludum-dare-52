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


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
    handle_input()
    pre_update(delta)
    do_update(delta)
    post_update(delta)
    
    
func handle_input():
    is_left = Input.is_action_pressed("player_left")
    is_right = Input.is_action_pressed("player_right")
    
    is_up = Input.is_action_pressed("player_up")
    is_down = Input.is_action_pressed("player_down")
        
    is_dash = Input.is_action_just_pressed("player_dash")
    is_attack = Input.is_action_just_pressed("player_attack")        
    is_shield = Input.is_action_pressed("player_shield")
    

func pre_update(delta: float):
    if current_state == State.Idle or current_state == State.Moving:
        var dir := Vector2(0, 0)
        
        if is_left:
            dir += Vector2.LEFT
        
        if is_right:
            dir += Vector2.RIGHT
            
        if is_up:
            dir += Vector2.UP
            
        if is_down:
            dir += Vector2.DOWN
        
        if is_dash and can_dash():
            enter_dash()
        elif dir.is_equal_approx(Vector2(0, 0)):
            current_state = State.Idle
            target_velocity = Vector2(0, 0)
        else:
            current_state = State.Moving
            dir = dir.normalized()
            target_velocity = move_speed * dir
            
    elif current_state == State.Dashing:
        dash_timer += delta
    
    
func do_update(delta: float):
    if is_attack:
        apply_impulse(Vector2.UP * 10000)
    update_physics(delta)
    
    
func post_update(_delta: float):
    if current_state == State.Dashing:
        if dash_timer >= dash_time:
            leave_dash()
            current_state = State.Moving
    

func can_dash():
    return true
    

func enter_dash():
    current_state = State.Dashing
    dash_timer = 0.0
    target_velocity = dash_speed * get_local_mouse_position().normalized()
    
    
func leave_dash():
    dash_timer = 0.0
