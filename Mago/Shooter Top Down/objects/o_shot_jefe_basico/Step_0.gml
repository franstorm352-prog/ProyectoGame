// =============================================
// o_shot_jefe_basico  |  Step Event
// =============================================

// Rota el sprite en la dirección de vuelo (compensando si el sprite fue dibujado hacia arriba)
image_angle = direction - 90;

// Destruir si sale del mapa
if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200) {
    instance_destroy();
}
