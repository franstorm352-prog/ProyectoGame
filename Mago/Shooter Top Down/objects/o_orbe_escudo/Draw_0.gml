// =============================================
// o_orbe_escudo  |  Draw Event
// Orbe morado pulsante — sin sprite, todo con draw_circle.
// Para reemplazar por sprite: quitar este evento y asignar spriteId en el .yy
// =============================================

var _pulse = 0.5 + 0.5 * sin(current_time * 0.005);

// Resplandor exterior semitransparente
draw_set_alpha(0.25 + 0.15 * _pulse);
draw_set_color(make_color_rgb(200, 100, 255));
draw_circle(x, y, 26 + 5 * _pulse, false);

// Núcleo interior sólido
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(140, 50, 240));
draw_circle(x, y, 14, false);

// Borde brillante
draw_set_alpha(1);
draw_set_color(make_color_rgb(220, 170, 255));
draw_circle(x, y, 14, true);

// Resetear
draw_set_alpha(1);
draw_set_color(c_white);
