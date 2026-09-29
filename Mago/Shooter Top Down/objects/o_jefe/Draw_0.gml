// =============================================
// o_jefe  |  Draw Event
// =============================================

draw_self();

// Si el jefe está aturdido por el hielo, dibujar la animación encima
if (stun_timer > 0) {
    var _escala = 4.0; // Misma escala que el jefe
    var _frame = (current_time div 100) mod 8; // s_aturdido_congelacion tiene 8 frames
    
    // Se dibuja un poco más arriba para que quede sobre su cabeza
    draw_sprite_ext(s_aturdido_congelacion, _frame, x, y - 60, _escala, _escala, 0, c_white, 0.9);
}
