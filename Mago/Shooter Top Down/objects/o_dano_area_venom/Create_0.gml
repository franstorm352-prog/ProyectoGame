// =============================================
// o_dano_area_venom  |  Create Event
// Charco de veneno invocado por o_enemy_venom.
// Permanece en el suelo durante lifetime frames.
// Cada tick_interval frames aplica 1 HP de daño al jugador
// si está encima, hasta un máximo de max_damage_total HP.
// =============================================

// Duración del charco en frames (5 segundos a 60fps)
lifetime      = 300;

// Cuántos frames entre cada tick de daño (30 = 0.5 seg)
tick_interval = 30;
tick_timer    = tick_interval;

// Máximo daño que puede infligir este charco (8 HP)
max_damage_total  = 8;
damage_dealt      = 0; // contador de daño acumulado

// Daño por tick
dmg_per_tick = 1;

// Imagen semitransparente (efecto de área)
image_alpha = 0.7;

// depth positivo para que quede por debajo de enemigos y jugador
depth = 10;
