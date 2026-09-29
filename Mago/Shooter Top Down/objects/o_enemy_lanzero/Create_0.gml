// =============================================
// o_enemy_lanzero  |  Create Event
// Lanzero: camina hacia el jugador, se detiene a distancia
// y dispara 2 flechas en forma de Y (cerca del jugador).
// =============================================

hp = 50;
enemy_speed = 0.9;
image_xscale = 2;
image_yscale = 2;

// Distancia a la que se detiene y apunta
attack_range  = 450;
shoot_cooldown = 70; // frames entre ataques
shoot_timer   = shoot_cooldown;

// Sprites de caminar / apuntar
walk_sprite = sprite_index;
att_sprite  = s_lanzero_att;

event_inherited();

sprite_mira_derecha = true;   // este sprite mira a la derecha (va después de event_inherited)
ataca_al_tocar = false;       // ataca a distancia
