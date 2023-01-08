class_name Player extends Character


const FrameDown := 0
const FrameUp := 1
const FrameLeft := 2
const FrameRight := 3


export var move_speed := 300.0
export var dash_distance := 300.0
export var dash_time := 0.3

onready var dash_speed := dash_distance / dash_time
onready var scythe_distance: float = $ScythePosition.position.length()
onready var initial_scythe_position = $ScythePosition.position

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

var idle_state := PlayerIdleState.new()
var dashing_state := PlayerDashingState.new()


func _ready():
    idle_state.set_dependencies(dashing_state)
    dashing_state.set_dependencies(idle_state)

    state_machine.add_state(idle_state)
    state_machine.add_state(dashing_state)
    
    state_machine.set_state(idle_state)


# Recall, _physics_process gets call on this object twice. 
# Once for the definition in Character, once for here
# So we just define `do_physics_process` to only call once
func do_physics_process(delta: float):
    handle_input()
    .do_physics_process(delta)
    set_frame()
    
    
func handle_input():
    is_left = Input.is_action_pressed("player_left")
    is_right = Input.is_action_pressed("player_right")
    
    is_up = Input.is_action_pressed("player_up")
    is_down = Input.is_action_pressed("player_down")
        
    is_dash = Input.is_action_just_pressed("player_dash")
    is_attack = Input.is_action_just_pressed("player_attack")        
    is_shield = Input.is_action_pressed("player_shield")
    

func can_dash() -> bool:
    return true
    
    
func set_scythe_impulse_multiplier(multiplier: float):
    $ScythePosition/Scythe1.impulse_multiplier = multiplier
    

func set_scythe_position(pos: Vector2):
    $ScythePosition.position = pos
    $ScythePosition.rotation = initial_scythe_position.angle_to(pos)
    
    
func can_attack() -> bool:
    return $ScythePosition/Scythe1.can_attack()
    
    
func attack():
    var to_mouse = get_local_mouse_position().normalized()
    
    set_facing_direction(to_mouse)
    set_scythe_position(scythe_distance * to_mouse)
    $ScythePosition/Scythe1.attack()
    
    
func set_facing_direction(dir: Vector2):
    if not $ScythePosition/Scythe1.is_attacking():
        facing_direction = dir
        
        
func set_frame():
    var angle = facing_direction.angle()
    var frame = FrameLeft
    
    if angle <= (PI / 4) and angle >= (-PI / 4):
        frame = FrameRight
    elif angle <= 3.1 * PI / 4 and angle >= PI / 4:
        frame = FrameUp
    elif angle >= -3.1 * PI / 4 and angle <= -PI / 4:
        frame = FrameDown

    $AnimatedSprite.frame = frame
