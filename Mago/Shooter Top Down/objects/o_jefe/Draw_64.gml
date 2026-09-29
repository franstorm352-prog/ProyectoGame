// =============================================
// o_jefe  |  Draw GUI Event (Draw_64)
// =============================================

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Configuración de la barra (Abajo a la derecha)
var _bar_w = 400;
var _bar_h = 24;
var _bar_x = _gw - _bar_w - 40;
var _bar_y = _gh - 60;

// Porcentaje de vida
var _hp_percent = max(0, hp / max_hp);

// 1. Fondo de la barra (Negro/Gris Oscuro)
draw_set_alpha(0.8);
draw_set_color(make_color_rgb(20, 10, 10));
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

// 2. Barra roja de vida
if (_hp_percent > 0) {
    draw_set_alpha(0.9);
    var _hp_color = c_red;
    if (fase == 2) _hp_color = make_color_rgb(255, 100, 0); // Naranja oscuro furioso
    if (fase == 3) _hp_color = make_color_rgb(200, 0, 255); // Morado letal

    draw_set_color(_hp_color);
    draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w * _hp_percent), _bar_y + _bar_h, false);
}

// 3. Borde metálico de la barra
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_rectangle(_bar_x - 2, _bar_y - 2, _bar_x + _bar_w + 2, _bar_y + _bar_h + 2, true);

// 4. Nombre del Jefe y Fase
draw_set_font(-1);
draw_set_halign(fa_right);
draw_set_valign(fa_bottom);

// Sombra del texto
draw_set_color(c_black);
var _text = "MAGO SUPREMO CORRUPTO - FASE " + string(fase);
draw_text(_gw - 40 + 2, _bar_y - 8 + 2, _text);

// Texto principal
draw_set_color(c_white);
if (fase == 2) draw_set_color(c_orange);
if (fase == 3) draw_set_color(c_fuchsia);
draw_text(_gw - 40, _bar_y - 8, _text);

// Limpiar valores de dibujo
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// ─── INDICADOR: CARGANDO (Barra de progreso) ──────────────────────
if (cargando) {
    var _carga_ratio = 1.0 - (carga_timer / 180.0); // Va de 0 a 1
    var _charge_bar_w = 300;
    var _charge_bar_h = 16;
    var _charge_bar_x = _bar_x + (_bar_w - _charge_bar_w) / 2;
    var _charge_bar_y = _bar_y - 30; // Justo arriba de la barra de vida
    
    // Fondo oscuro
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(_charge_bar_x, _charge_bar_y, _charge_bar_x + _charge_bar_w, _charge_bar_y + _charge_bar_h, false);
    
    // Relleno morado que avanza
    draw_set_alpha(0.9);
    draw_set_color(make_color_rgb(180, 0, 255));
    draw_rectangle(_charge_bar_x, _charge_bar_y, _charge_bar_x + (_charge_bar_w * _carga_ratio), _charge_bar_y + _charge_bar_h, false);
    
    // Borde blanco parpadeante
    var _warn_pulse = sin(current_time * 0.015);
    draw_set_alpha(0.7 + 0.3 * _warn_pulse);
    draw_set_color(c_white);
    draw_rectangle(_charge_bar_x - 1, _charge_bar_y - 1, _charge_bar_x + _charge_bar_w + 1, _charge_bar_y + _charge_bar_h + 1, true);
    
    // Texto de aviso encima de la barra
    if (_warn_pulse > 0) {
        draw_set_font(-1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(220, 100, 255));
        draw_text_transformed(_charge_bar_x + _charge_bar_w * 0.5, _charge_bar_y - 14,
                              "CARGANDO ATAQUE FINAL - [C] HIELO PARA INTERRUMPIR", 0.7, 0.7, 0);
    }
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

// ─── INDICADOR: NÚCLEO EXPUESTO ───────────────────────────────────
if (nucleo_expuesto) {
    var _cx_boss = camera_get_view_x(view_camera[0]);
    var _cy_boss = camera_get_view_y(view_camera[0]);
    var _cw_boss = camera_get_view_width(view_camera[0]);
    var _ch_boss = camera_get_view_height(view_camera[0]);
    var _bx = (x - _cx_boss) / _cw_boss * _gw;
    var _by = (y - _cy_boss) / _ch_boss * _gh;

    var _np = abs(sin(current_time * 0.012));
    // Círculo rojo pulsante sobre el jefe
    draw_set_alpha(0.55 + 0.3 * _np);
    draw_set_color(make_color_rgb(255, 40, 40));
    draw_circle(_bx, _by - 35, 32 + 10 * _np, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(255, 160, 160));
    draw_circle(_bx, _by - 35, 12, false);

    // Texto de aviso
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(255, 80, 80));
    draw_text_transformed(_bx, _by - 80, "NUCLEO EXPUESTO  [X] SANGRE x3", 0.9, 0.9, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
