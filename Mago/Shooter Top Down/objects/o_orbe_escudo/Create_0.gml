// =============================================
// o_orbe_escudo  |  Create Event
// Usa s_fireball como sprite temporal — reemplázalo después.
// =============================================

hp           = 30;
orbita_idx   = 0;   // índice del orbe dentro del grupo (0, 1, 2...)
orbita_total = 3;   // total de orbes en el grupo actual
orbita_radio = 100; // distancia al jefe en píxeles

// Visual: escalar el sprite y teñirlo de morado
image_xscale = 2.5;
image_yscale = 2.5;
image_blend  = make_color_rgb(180, 80, 255); // morado mágico
image_speed  = 0.5; // animación más lenta
depth        = -500; // dibuja por encima del jefe
