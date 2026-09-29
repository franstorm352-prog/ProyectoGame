// =============================================
// o_enemy_venom  |  Create Event
// Venom Enemy: se mueve lentamente y periódicamente
// invoca charcos de veneno (o_dano_area_venom)
// en posiciones aleatorias DENTRO del viewport del jugador.
// Cada charco quita 1 HP por tick (máximo 8 HP total por charco).
// =============================================

hp = 45;
enemy_speed = 1.2;
image_xscale = 2;
image_yscale = 2;

// Temporizador para invocar charcos de veneno en pantalla
summon_cooldown = 180; // 3 segundos entre invocaciones
summon_timer    = summon_cooldown;

event_inherited();

sprite_mira_derecha = true;   // este sprite mira a la derecha (va después de event_inherited)
ataca_al_tocar = false;       // ataca a distancia
