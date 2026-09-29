// =============================================
// o_cinematica_jefe  |  Draw GUI Event (Draw_64)
// =============================================
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2;

// Fondo MORADO intenso parpadeante
var _pulse = 0.5 + 0.5 * abs(sin(current_time * 0.005));
draw_set_alpha(0.4 + _pulse * 0.3); // Mínimo 0.4, máximo 0.7
draw_set_color(make_color_rgb(120, 0, 180)); // Morado brillante
draw_rectangle(0, 0, _gw, _gh, false);

// Logo de invocación en el centro (se anima solo con image_index / image_speed)
var _scale = 4.0 + 0.5 * _pulse; // Escala base gigante x4, late con el pulso
draw_sprite_ext(sprite_index, image_index, _cx, _cy, _scale, _scale, 0, c_white, 1.0);

draw_set_alpha(1.0);
draw_set_color(c_white);
