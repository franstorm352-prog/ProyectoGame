// =============================================
// o_flecha_cofre  |  Draw GUI Event (Draw_64)
// =============================================

// Validaciones de seguridad: Si no hay controlador o el juego ya repartió todo, no dibujamos la flecha
if (!instance_exists(o_game_controller)) exit;
var _ctrl = o_game_controller;
if (_ctrl.cofres_completados) exit;
if (_ctrl.cofre_activo_idx >= 3) exit;
if (!instance_exists(o_player_mago)) exit;

// Durante la pelea contra el jefe no mostramos la flecha
if (instance_exists(o_jefe)) exit;

// ─── BUSCAR EL COFRE MÁS CERCANO ─────────────────────────────────────────
// Recorremos los 3 cofres para encontrar el que esté cerrado y más cerca de nosotros
var _cofre_objetivo = noone;
var _distancia_minima = 9999999;

for (var _i = 0; _i < 3; _i++) {
    var _cofre_actual = _ctrl.cofre_ids[_i];
    
    // Si el cofre existe y aún no ha sido abierto
    if (instance_exists(_cofre_actual) && !_cofre_actual.abierto) {
        var _distancia_al_jugador = point_distance(o_player_mago.x, o_player_mago.y, _cofre_actual.x, _cofre_actual.y);
        
        // ¿Es este el más cercano hasta ahora?
        if (_distancia_al_jugador < _distancia_minima) {
            _distancia_minima = _distancia_al_jugador;
            _cofre_objetivo = _cofre_actual;
        }
    }
}

// Si todos están abiertos o no encontramos ninguno válido, no dibujamos nada
if (_cofre_objetivo == noone) exit;

// ─── CONVERTIR COORDENADAS DEL MAPA A LA PANTALLA (GUI) ────────────────
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_ancho = camera_get_view_width(view_camera[0]);
var _cam_alto = camera_get_view_height(view_camera[0]);

var _gui_ancho = display_get_gui_width();
var _gui_alto = display_get_gui_height();

// Transpolamos la posición física del cofre a dónde estaría en nuestro monitor
var _cofre_gui_x = (_cofre_objetivo.x - _cam_x) * (_gui_ancho / _cam_ancho);
var _cofre_gui_y = (_cofre_objetivo.y - _cam_y) * (_gui_alto / _cam_alto);

var _centro_pantalla_x = _gui_ancho * 0.5;
var _centro_pantalla_y = _gui_alto * 0.5;

// Si el cofre YA ESTÁ visible en la pantalla del jugador (con un margen de 80px),
// ocultamos la flecha porque el jugador ya puede ver el cofre con sus propios ojos.
var _margen_vision = 80;
if (_cofre_gui_x > _margen_vision && _cofre_gui_x < _gui_ancho - _margen_vision
&&  _cofre_gui_y > _margen_vision && _cofre_gui_y < _gui_alto - _margen_vision) {
    exit;
}

// ─── CALCULAR POSICIÓN DE LA FLECHA EN EL BORDE DE LA PANTALLA ─────────
// Hacia dónde tenemos que apuntar (desde el centro de la pantalla hacia el cofre)
var _angulo_hacia_cofre = point_direction(_centro_pantalla_x, _centro_pantalla_y, _cofre_gui_x, _cofre_gui_y);

// Matemáticas de intersección para "pegar" la flecha al borde de la pantalla
var _padding_borde = 52; // Cuántos píxeles separada del borde real se dibujará
var _dir_x  = lengthdir_x(1, _angulo_hacia_cofre);
var _dir_y  = lengthdir_y(1, _angulo_hacia_cofre);
var _dist_al_borde = 99999;

if (abs(_dir_x) > 0.001) {
    var _borde_x = _padding_borde;                            // borde izquierdo
    if (_dir_x > 0) _borde_x = _gui_ancho - _padding_borde;   // borde derecho
    _dist_al_borde = min(_dist_al_borde, (_borde_x - _centro_pantalla_x) / _dir_x);
}
if (abs(_dir_y) > 0.001) {
    var _borde_y = _padding_borde;                            // borde de arriba
    if (_dir_y > 0) _borde_y = _gui_alto - _padding_borde;    // borde de abajo
    _dist_al_borde = min(_dist_al_borde, (_borde_y - _centro_pantalla_y) / _dir_y);
}

// Posición final exacta donde se dibujará la flecha
var _flecha_x = _centro_pantalla_x + _dir_x * _dist_al_borde;
var _flecha_y = _centro_pantalla_y + _dir_y * _dist_al_borde;

// ─── ANIMACIONES ────────────────────────────────────────────────────────
// Efecto de latido (crece y se achica un poco constantemente)
var _latido = 1.0 + 0.18 * sin(current_time * 0.008);
var _escala_final = 2.2 * _latido;

// s_flecha_guia tiene 16 frames de animación, los pasamos usando el reloj del juego
var _frame_actual = (current_time div 80) mod 16;

// ─── DIBUJAR ────────────────────────────────────────────────────────────

// 1. Fondo oscuro circular detrás de la flecha para que resalte
draw_set_alpha(0.55);
draw_set_color(c_black);
draw_circle(_flecha_x, _flecha_y, 22 * _escala_final * 0.5, false);

// 2. Dibujar la flecha rotada
// NOTA: El sprite original apunta hacia ARRIBA. 
// Por eso le restamos 90 grados al ángulo calculado, para compensarlo visualmente.
var _angulo_dibujo = _angulo_hacia_cofre - 90;

// El origen del sprite está en su centro, así que rota sobre sí mismo
draw_set_alpha(0.95);
draw_sprite_ext(s_flecha_guia, _frame_actual,
                _flecha_x, _flecha_y,
                _escala_final, _escala_final,
                _angulo_dibujo, make_color_rgb(255, 220, 80), 0.95);

// 3. Texto de Distancia
var _distancia_real = point_distance(o_player_mago.x, o_player_mago.y, _cofre_objetivo.x, _cofre_objetivo.y);

// Ponemos el texto un poco "detrás" de la flecha, acercándose al centro de la pantalla
var _texto_x = _flecha_x + lengthdir_x(-40, _angulo_hacia_cofre);
var _texto_y = _flecha_y + lengthdir_y(-40, _angulo_hacia_cofre);

draw_set_alpha(0.9);
draw_set_color(make_color_rgb(255, 240, 120));
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(_texto_x, _texto_y, string(round(_distancia_real)) + "px");

// ─── LIMPIEZA ───────────────────────────────────────────────────────────
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
