// =============================================
// o_jefe  |  Create Event
// =============================================

enemy_speed = 0.8;

event_inherited();

max_hp = 3000;
hp     = max_hp;

fase          = 1;
attack_timer  = 0;
estado_muerto = false;
muerte_timer  = 0;

sprite_index = s_jefe_fase1;
image_xscale = 2;
image_yscale = 2;

// ── Dash (Fase 1) ─────────────────────────────────────────────────
dash_timer    = 0;
dash_interval = 480; // 8 segundos (60fps)
is_dashing    = false;
dash_dx       = 0;
dash_dy       = 0;
dash_frames   = 0;

// ── Orbes de escudo (Fase 2) ──────────────────────────────────────
orbes_activos     = 0;
fase2_iniciada    = false;
orbes_regen_timer = 0;

// ── Carga de energía (Fase 3) ─────────────────────────────────────
cargando       = false;
carga_timer    = 0;
carga_cooldown = 0; // sube hasta 600 (10s) para iniciar carga
espiral_bursts = 0; // ráfagas pendientes
espiral_timer  = 0; // tiempo entre ráfagas

// ── Núcleo expuesto ───────────────────────────────────────────────
nucleo_expuesto = false;
nucleo_timer    = 0;
