// Barra de vida en esquina inferior izquierda

var _bar_x    = 20;
var _bar_y    = display_get_gui_height() - 46;
var _bar_w    = 200;
var _bar_h    = 22;
var _hp_ratio = clamp(hp / 100, 0, 1);

// Fondo oscuro semitransparente
draw_set_alpha(0.55);
draw_set_color(c_black);
draw_rectangle(_bar_x - 3, _bar_y - 18, _bar_x + _bar_w + 3, _bar_y + _bar_h + 3, false);
draw_set_alpha(1);

// Etiqueta "HP"
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
draw_text(_bar_x, _bar_y - 1, "HP  " + string(hp) + " / 100");

// Fondo de la barra (rojo oscuro)
draw_set_color(make_color_rgb(80, 15, 15));
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

// Relleno que va de rojo (0% HP) a verde (100% HP)
var _r = lerp(220, 40,  _hp_ratio);
var _g = lerp(30,  200, _hp_ratio);
var _b = 20;
draw_set_color(make_color_rgb(_r, _g, _b));
if (_hp_ratio > 0)
{
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * _hp_ratio, _bar_y + _bar_h, false);
}

// Borde exterior
draw_set_color(make_color_rgb(200, 200, 200));
draw_rectangle(_bar_x - 1, _bar_y - 1, _bar_x + _bar_w + 1, _bar_y + _bar_h + 1, true);

// ─── INVENTARIO DE RUNAS (Arriba a la Izquierda) ─────────
// (inv_x, inv_y, slot_size y slot_pad se definen en el Create)
var _runas_has   = [has_fire,       has_rocks,       has_blood,       has_ice      ];
var _runas_spr   = [s_pow_fire,     s_pow_rocks,     s_pow_blood,     s_pow_ice    ];
var _runas_nivel = [powLevel_fire,  powLevel_rocks,  powLevel_blood,  powLevel_ice ];
var _nivel_max   = 3;
var _label_h     = 16; // altura de la etiqueta de nivel debajo del slot

for (var _i = 0; _i < 4; _i++) {
    var _sx = inv_x + _i * (slot_size + slot_pad);
    var _sy = inv_y;

    // Dibujar fondo del slot
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, false);

    // Borde oscurecido si no la tiene, brillante si la tiene
    draw_set_alpha(0.9);
    if (_runas_has[_i]) draw_set_color(make_color_rgb(220, 170, 255));
    else draw_set_color(make_color_rgb(80, 80, 100));
    draw_rectangle(_sx, _sy, _sx + slot_size, _sy + slot_size, true);

    // Dibujar runa si la tiene
    if (_runas_has[_i]) {
        var _spr = _runas_spr[_i];

        // Centro del slot
        var _cx = _sx + slot_size * 0.5;
        var _cy = _sy + slot_size * 0.5;

        // Los sprites son de 32x32 y tienen el origen en el centro, encajan perfecto en 44x44
        draw_sprite(_spr, 0, _cx, _cy);
    }

    // ── Etiqueta de nivel debajo del slot ────────────────
    var _lx = _sx;
    var _ly = _sy + slot_size + 2;

    // Fondo de la etiqueta
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_rectangle(_lx, _ly, _lx + slot_size, _ly + _label_h, false);

    // Borde igual al del slot
    draw_set_alpha(0.9);
    if (_runas_has[_i]) draw_set_color(make_color_rgb(220, 170, 255));
    else draw_set_color(make_color_rgb(80, 80, 100));
    draw_rectangle(_lx, _ly, _lx + slot_size, _ly + _label_h, true);

    // Texto "Nv X/3" — escala reducida para no saturar
    draw_set_alpha(1);
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (_runas_has[_i]) draw_set_color(make_color_rgb(220, 170, 255));
    else draw_set_color(make_color_rgb(120, 120, 140));
    draw_text_transformed(_lx + slot_size * 0.5, _ly + _label_h * 0.5,
              "Nv " + string(_runas_nivel[_i]) + "/" + string(_nivel_max),
              0.65, 0.65, 0);

    // ── Tecla + barra de cooldown (solo ante el jefe) ─────────────
    if (instance_exists(o_jefe) && _runas_has[_i] && _i > 0) {
        var _teclas = ["", "Z", "X", "C"];
        var _tecla  = _teclas[_i];
        var _shoots = [canShoot_fire, canShoot_rocks, canShoot_blood, canShoot_ice];
        var _alarms = [alarm[0], alarm[1], alarm[2], alarm[3]];
        var _reloads = [reloadSpeed_fire, reloadSpeed_rocks, reloadSpeed_blood, reloadSpeed_ice];

        // Ratio de recarga (0=vacío, 1=listo)
        var _cd_ratio = 1.0;
        var _is_on_gcd = (global_cd > 0);
        
        if (_is_on_gcd) {
            _cd_ratio = 1.0 - (global_cd / global_cd_max);
        } else if (_shoots[_i] == 0 && _alarms[_i] > 0) {
            _cd_ratio = 1.0 - (_alarms[_i] / _reloads[_i]);
        }
        
        var _listo = (_shoots[_i] == 1 && !_is_on_gcd);

        // Barra de cooldown
        var _bar_ky = _ly + _label_h + 2;
        var _bar_kh = 5;
        draw_set_alpha(0.6);
        draw_set_color(c_black);
        draw_rectangle(_lx, _bar_ky, _lx + slot_size, _bar_ky + _bar_kh, false);
        draw_set_alpha(0.9);
        if (_listo) {
            draw_set_color(make_color_rgb(220, 170, 255));
        } else if (_is_on_gcd) {
            draw_set_color(make_color_rgb(180, 80, 80)); // Rojo oscuro para el Global CD
        } else {
            draw_set_color(make_color_rgb(120, 80, 160));
        }
        draw_rectangle(_lx, _bar_ky, _lx + slot_size * _cd_ratio, _bar_ky + _bar_kh, false);

        // Etiqueta de tecla
        var _key_y = _bar_ky + _bar_kh + 1;
        var _key_h = 12;
        draw_set_alpha(0.7);
        draw_set_color(c_black);
        draw_rectangle(_lx, _key_y, _lx + slot_size, _key_y + _key_h, false);
        draw_set_alpha(1);
        
        if (_listo) {
            draw_set_color(make_color_rgb(255, 220, 100));
        } else if (_is_on_gcd) {
            draw_set_color(make_color_rgb(150, 100, 100)); // Texto apagado
        } else {
            draw_set_color(make_color_rgb(140, 120, 80));
        }
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(_lx + slot_size * 0.5, _key_y + _key_h * 0.5,
                              "[" + _tecla + "]", 0.65, 0.65, 0);
    }
}

// ─── TIMER DE PARTIDA (Arriba a la Derecha) ──────────────
if (instance_exists(o_game_controller)) {
    var _frames = o_game_controller.timer_frames;
    var _total_segundos = floor(_frames / 60); // Asumiendo 60 FPS
    var _minutos = floor(_total_segundos / 60);
    var _segundos = _total_segundos mod 60;
    
    // Formatear a "MM:SS"
    var _str_min = string(_minutos);
    if (_minutos < 10) _str_min = "0" + _str_min;
    var _str_seg = string(_segundos);
    if (_segundos < 10) _str_seg = "0" + _str_seg;
    var _str_tiempo = _str_min + ":" + _str_seg;
    
    var _gw = display_get_gui_width();
    var _tx = _gw - 20;
    var _ty = 20;
    
    draw_set_font(-1);
    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    
    // Sombra del texto
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_text(_tx + 2, _ty + 2, _str_tiempo);
    
    // Texto brillante
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(255, 240, 180)); // Dorado suave
    draw_text(_tx, _ty, _str_tiempo);
}

// Resetear estado de dibujo
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
