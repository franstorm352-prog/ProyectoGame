// =============================================
// o_jefe  |  Step Event
// =============================================

if (!instance_exists(o_player_mago)) exit;

// ─── MUERTE ───────────────────────────────────────────────────────
if (hp <= 0 && !estado_muerto) {
    estado_muerto = true;
    muerte_timer  = 0;
    cargando      = false;
    nucleo_expuesto = false; // <-- Limpiar el indicador al morir
    image_blend   = c_white;
    // Limpiar orbes y proyectiles
    with (o_orbe_escudo)    instance_destroy();
    with (o_shot_jefe_basico) instance_destroy();
    orbes_activos = 0;
    var _exp = instance_create_layer(x, y, "Instances", o_explosion_final);
    _exp.image_xscale = 3;
    _exp.image_yscale = 3;
}

if (estado_muerto) {
    mask_index  = -1;
    image_blend = c_white;
    if (image_alpha > 0) image_alpha -= 0.02;
    muerte_timer++;
    if (muerte_timer >= 360) {
        ir_a_resultado(true);
        instance_destroy();
    }
    exit;
}

// ─── RALENTIZADO POR HIELO ────────────────────────────────────────
if (slow_timer > 0) {
    slow_timer--;
    if (slow_timer <= 0) enemy_speed = base_speed;
}

// ─── NÚCLEO EXPUESTO: temporizador ────────────────────────────────
if (nucleo_expuesto) {
    nucleo_timer--;
    if (nucleo_timer <= 0) {
        nucleo_expuesto = false;
        image_blend     = c_white;
    }
}

// ─── TRANSICIONES DE FASE ─────────────────────────────────────────
if (hp <= 1000 && fase == 2) {
    fase         = 3;
    sprite_index = s_jefe_fase3;
    base_speed   = 1.4;
    if (slow_timer <= 0) enemy_speed = base_speed;
    // Destruir orbes al pasar a fase 3
    with (o_orbe_escudo) instance_destroy();
    orbes_activos  = 0;
    cargando       = false;
    carga_cooldown = 0;
    stun_timer     = 0;
    image_blend    = c_white;
} else if (hp <= 2000 && fase == 1) {
    fase         = 2;
    sprite_index = s_jefe_fase2;
    base_speed   = 1.1;
    if (slow_timer <= 0) enemy_speed = base_speed;
    // Invocar 3 orbes al entrar en fase 2
    if (!fase2_iniciada) {
        fase2_iniciada    = true;
        orbes_regen_timer = 0;
        for (var _oi = 0; _oi < 3; _oi++) {
            var _orb          = instance_create_layer(x, y, "Instances", o_orbe_escudo);
            _orb.orbita_idx   = _oi;
            _orb.orbita_total = 3;
            orbes_activos++;
        }
    }
}

// ─── DIRECCIÓN Y ESCALA ───────────────────────────────────────────
var _dir    = point_direction(x, y, o_player_mago.x, o_player_mago.y);
var _escala = 4.0;
image_yscale = _escala;

// ─── ATURDIDO ─────────────────────────────────────────────────────
if (stun_timer > 0) {
    stun_timer--;
    image_xscale = -_escala; // Siempre mirar al jugador mientras está aturdido
    // No usar exit; para permitir que otros contadores y el confinamiento funcionen
} else {

    // ─── FASE 3: CARGA DE ENERGÍA ─────────────────────────────────────
    if (fase == 3) {
        if (cargando) {
            carga_timer--;
            enemy_speed  = 0;
            image_xscale = -_escala;
            // Telegraf: tiñe de morado progresivamente
            var _t      = 1.0 - (carga_timer / 180.0);
            image_blend = merge_colour(c_white, make_color_rgb(150, 0, 255), _t);

            if (carga_timer <= 0) {
                // No interrumpida → espiral
                cargando    = false;
                enemy_speed = base_speed;
                image_blend = c_white;
                c_jefe_ataque_espiral();
                carga_cooldown = 0;
            }

            // Confinamiento durante la carga
            var _cx2 = camera_get_view_x(view_camera[0]);
            var _cy2 = camera_get_view_y(view_camera[0]);
            var _cw2 = camera_get_view_width(view_camera[0]);
            var _ch2 = camera_get_view_height(view_camera[0]);
            x = clamp(x, _cx2 + _cw2 * 0.65, _cx2 + _cw2 - 80);
            y = clamp(y, _cy2 + 120, _cy2 + _ch2 - 120);
            // Salta el resto del código de ataque/movimiento porque está cargando
        } else {
            // Acumular cooldown para la próxima carga
            if (!nucleo_expuesto) carga_cooldown++;
            if (carga_cooldown >= 600) {
                cargando       = true;
                carga_timer    = 180;
                carga_cooldown = 0;
                enemy_speed    = 0;
            }
        }
    }

    // ─── FASE 2: REGENERACIÓN DE ORBES ────────────────────────────────
    if (fase == 2 && orbes_activos == 0 && fase2_iniciada) {
        orbes_regen_timer++;
        if (orbes_regen_timer >= 900) { // 15 segundos
            orbes_regen_timer = 0;
            for (var _oi2 = 0; _oi2 < 2; _oi2++) {
                var _orb2          = instance_create_layer(x, y, "Instances", o_orbe_escudo);
                _orb2.orbita_idx   = _oi2;
                _orb2.orbita_total = 2;
                orbes_activos++;
            }
        }
    }

    // ─── MOVIMIENTO ───────────────────────────────────────────────────
    if (!cargando) {
        if (fase == 1) {
            // ── Dash periódico ──────────────────────────────────────────
            if (is_dashing) {
                x           += dash_dx;
                y           += dash_dy;
                dash_frames--;
                image_xscale = (dash_dx > 0) ? _escala : -_escala;
                if (dash_frames <= 0) {
                    is_dashing  = false;
                    dash_timer  = 0;
                    image_blend = c_white;
                }
            } else {
                image_xscale = -_escala;
                var _dy1     = o_player_mago.y - y;
                if (abs(_dy1) > 8) y += sign(_dy1) * enemy_speed;

                dash_timer++;
                // Telegraf: parpadeo rojo los últimos 60 frames antes del dash
                if (dash_timer >= dash_interval - 60) {
                    var _bl = (dash_timer mod 12 < 6);
                    image_blend = _bl ? make_color_rgb(255, 80, 80) : c_white;
                }
                if (dash_timer >= dash_interval) {
                    is_dashing  = true;
                    image_blend = c_white;
                    dash_frames = 25;
                    dash_dx     = lengthdir_x(7, _dir);
                    dash_dy     = lengthdir_y(7, _dir);
                }
            }
        } else {
            // ── Fases 2 y 3: movimiento vertical con animación de ataque ─
            var _atacando = (sprite_index == s_jefe_fase2_att || sprite_index == s_jefe_fase3_att);
            if (_atacando) {
                image_xscale = _escala;
                if (image_index >= image_number - 1) {
                    if (fase == 2) sprite_index = s_jefe_fase2;
                    if (fase == 3) sprite_index = s_jefe_fase3;
                }
            } else {
                image_xscale = -_escala;
                var _dy2     = o_player_mago.y - y;
                if (abs(_dy2) > 8) y += sign(_dy2) * enemy_speed;
            }
        }
    }

    // ─── ATAQUES ──────────────────────────────────────────────────────
    if (!cargando && espiral_bursts == 0) {
        attack_timer++;
        var _attack_max = 120; // Fase 1: 2s
        if (fase == 2) _attack_max = 100;
        if (fase == 3) _attack_max = 85;

        // Telegraf: parpadeo rojo 60 frames antes del ataque (fases 2 y 3)
        if (fase >= 2 && !nucleo_expuesto && attack_timer >= _attack_max - 60) {
            var _ab = (attack_timer mod 10 < 5);
            image_blend = _ab ? make_color_rgb(255, 80, 80) : c_white;
        }

        if (attack_timer >= _attack_max) {
            attack_timer = 0;
            image_blend  = c_white;

            if (fase == 1) {
                // Fan lento de 3 balas (sin animación)
                var _s1 = instance_create_layer(x, y, "Instances", o_shot_jefe_basico);
                _s1.direction = _dir - 15; _s1.speed = 2.5;
                var _s2 = instance_create_layer(x, y, "Instances", o_shot_jefe_basico);
                _s2.direction = _dir;      _s2.speed = 2.5;
                var _s3 = instance_create_layer(x, y, "Instances", o_shot_jefe_basico);
                _s3.direction = _dir + 15; _s3.speed = 2.5;
            } else {
                // Fases 2 y 3: animación + script de ataque
                if (fase == 2) sprite_index = s_jefe_fase2_att;
                if (fase == 3) sprite_index = s_jefe_fase3_att;
                image_index = 0;
                c_jefe_ataque(fase, _dir);
            }
        }
    }

} // Fin de if (stun_timer <= 0)

// ─── CONFINAMIENTO ────────────────────────────────────────────────
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);
x = clamp(x, _cam_x + _cam_w * 0.65, _cam_x + _cam_w - 80);
y = clamp(y, _cam_y + 120,            _cam_y + _cam_h - 120);

// ─── RAFAGAS ESPIRAL (3 OLEADAS ROTATIVAS) ────────────────────────
if (espiral_bursts > 0) {
    espiral_timer--;
    if (espiral_timer <= 0) {
        var _offset = (3 - espiral_bursts) * 15; // Rota 15 grados en cada oleada
        var _total = 12;
        for (var _i = 0; _i < _total; _i++) {
            var _angulo = (_i / _total) * 360 + _offset;
            var _shot   = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction    = _angulo;
            _shot.speed        = 4.5;
            _shot.image_xscale = 1.5;
            _shot.image_yscale = 1.5;
        }
        espiral_bursts--;
        espiral_timer = 25; // 25 frames de separación entre cada oleada
    }
}
