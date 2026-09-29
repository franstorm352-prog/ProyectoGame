// --- Movimiento horizontal ---
if (keyboard_check(vk_right)) hSpeed =  speedMax;
if (keyboard_check(vk_left))  hSpeed = -speedMax;
if (!keyboard_check(vk_right) and !keyboard_check(vk_left)) hSpeed = 0;
if (keyboard_check(vk_right)  and  keyboard_check(vk_left)) hSpeed = 0;

// (Sin restricción horizontal: el jugador se mueve libre en su zona)

// --- Movimiento vertical ---
if (keyboard_check(vk_up))   vSpeed = -speedMax;
if (keyboard_check(vk_down)) vSpeed =  speedMax;
if (!keyboard_check(vk_up) and !keyboard_check(vk_down)) vSpeed = 0;
if (keyboard_check(vk_up)  and  keyboard_check(vk_down)) vSpeed = 0;

// --- Animación según dirección ---
if (hSpeed > 0)
{
	image_xscale = 1;
	sprite_index = s_player_right;
	estado = "Side";
}
else if (hSpeed < 0)
{
	image_xscale = -1;
	sprite_index = s_player_right; // mismo sprite, volteado
	estado = "Side";
}
else if (vSpeed < 0)
{
	sprite_index = s_player_up;
	estado = "Up";
}
else if (vSpeed > 0)
{
	sprite_index = s_player_down;
	estado = "Down";
}
else
{
	// Sin movimiento → idle según la última dirección
	if (estado == "Up")   sprite_index = s_Idle_up;
	if (estado == "Down") sprite_index = s_Idle_down;
	if (estado == "Side") sprite_index = s_Idle_right;
}

// --- Mover y mantener dentro del room ---
x += hSpeed;
y += vSpeed;
x = clamp(x, 16, room_width  - 16);
y = clamp(y, 16, room_height - 16);

// --- Cámara y límites ---
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);

if (instance_exists(o_jefe)) {
    // PELEA CON JEFE: cámara 100% fija, no se mueve ni en X ni en Y.
    // El jugador se mueve libre en la zona azul izquierda.
    var _cam_x_fija = camera_get_view_x(view_camera[0]);
    var _cam_y_fija = camera_get_view_y(view_camera[0]);
    camera_set_view_pos(view_camera[0], _cam_x_fija, _cam_y_fija);
    
    // Limitar al jugador dentro de la zona izquierda (el 50% izquierdo)
    // Para que no cruce al lado del jefe
    var _zona_izq   = _cam_x_fija + 24;              // borde izquierdo
    var _zona_der   = _cam_x_fija + _cam_w * 0.50;   // frontera con el jefe
    var _zona_top   = _cam_y_fija + 24;              // borde superior
    var _zona_bot   = _cam_y_fija + _cam_h - 24;     // borde inferior
    x = clamp(x, _zona_izq, _zona_der);
    y = clamp(y, _zona_top, _zona_bot);
} else {
    // Comportamiento normal: cámara sigue al jugador en X e Y
    var _cam_x = clamp(x - _cam_w / 2, 0, room_width  - _cam_w);
    var _cam_y = clamp(y - _cam_h / 2, 0, room_height - _cam_h);
    camera_set_view_pos(view_camera[0], _cam_x, _cam_y);
}

// --- Parpadeo mientras dure la invulnerabilidad ---
if (hit_timer > 0)
{
    hit_timer--;
    image_alpha = (hit_timer mod 12 < 6) ? 0.25 : 1.0; // alterna cada 6 frames
}
else
{
    image_alpha = 1.0;
}

// --- Reducción del Global Cooldown ---
if (global_cd > 0) global_cd--;

// --- Disparo automático al enemigo más cercano ---
if (hp > 0)
{
	var _enemy = instance_nearest(x, y, o_enemy_body);
	var _target_valid = false;
	
	if (_enemy != noone) {
	    _target_valid = true;
	    // Si el enemigo más cercano es el jefe y está muriendo, dejar de disparar
	    if (_enemy.object_index == o_jefe && _enemy.estado_muerto) {
	        _target_valid = false;
	    }
	}

	if (_target_valid)
	{
		var _dirAtaque = point_direction(x, y, _enemy.x, _enemy.y);

		if (has_fire and canShoot_fire)
		{
			c_weapon_standard(powLevel_fire, _dirAtaque);
		}
		if (instance_exists(o_jefe)) {
		    // ── MODO JEFE: Rocas/Sangre/Hielo son manuales y usan Global Cooldown ────────────
		    if (global_cd <= 0) {
		        var _shot_fired = false;
		        if (has_rocks and canShoot_rocks and keyboard_check(ord("Z"))) {
		            c_weapon_rocks(powLevel_rocks, _dirAtaque);
		            _shot_fired = true;
		        }
		        else if (has_blood and canShoot_blood and keyboard_check(ord("X"))) {
		            c_weapon_blood(powLevel_blood, _dirAtaque);
		            _shot_fired = true;
		        }
		        else if (has_ice and canShoot_ice and keyboard_check(ord("C"))) {
		            c_weapon_ice(powLevel_ice, _dirAtaque);
		            _shot_fired = true;
		        }
		        
		        if (_shot_fired) {
		            global_cd = global_cd_max; // Aplicar cooldown a todas
		        }
		    }
		} else {
		    // ── MODO NORMAL: todo automático ──────────────────────────
		    if (has_rocks and canShoot_rocks) c_weapon_rocks(powLevel_rocks, _dirAtaque);
		    if (has_blood and canShoot_blood) c_weapon_blood(powLevel_blood, _dirAtaque);
		    if (has_ice   and canShoot_ice)   c_weapon_ice(powLevel_ice,   _dirAtaque);
		}
	}
}