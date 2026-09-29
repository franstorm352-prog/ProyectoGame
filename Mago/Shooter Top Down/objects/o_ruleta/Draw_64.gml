// =============================================
// o_ruleta  |  Draw GUI Event (Draw_64)
// Marco brillante que salta entre los slots del inventario
// =============================================

if (!instance_exists(o_player_mago)) exit;

// Posición del slot que se está mostrando (usa las medidas del inventario del jugador)
var _slot = runas_slot[indice];
var _tam  = o_player_mago.slot_size;
var _sx   = o_player_mago.inv_x + _slot * (_tam + o_player_mago.slot_pad);
var _sy   = o_player_mago.inv_y;

// Mientras gira (o espera a entregar la runa): marco brillante con la runa transparente
if (!reward_applied)
{
    draw_set_alpha(0.5);
    draw_set_color(make_color_rgb(170, 120, 255));
    draw_rectangle(_sx, _sy, _sx + _tam, _sy + _tam, false);

    draw_sprite_ext(runas_spr[indice], 0, _sx + _tam * 0.5, _sy + _tam * 0.5, 1, 1, 0, c_white, 0.7);

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(255, 220, 255));
    draw_rectangle(_sx - 2, _sy - 2, _sx + _tam + 2, _sy + _tam + 2, true);
}

// Mensaje cuando ya se entregó la runa
if (reward_applied && runa_nombre_ganada != "")
{
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(255, 240, 80)); // Letras doradas
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed(display_get_gui_width() * 0.5, 60, "¡Runa de " + runa_nombre_ganada + " obtenida!", 2, 2, 0);
}

// Volver los valores de dibujo a los de siempre
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
