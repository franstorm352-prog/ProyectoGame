// =============================================
// o_orbe_escudo  |  Collision con o_att
// Solo proyectiles de ROCAS pueden destruir los orbes.
// =============================================

// Proyectil que no sea Rocas → rebota (se destruye sin dañar)
if (!other.es_roca) {
    with (other) instance_destroy();
    exit;
}

// Es Rocas → recibir daño
hp -= other.dmg;

if (hp <= 0) {
    // Notificar al jefe: un orbe menos
    if (instance_exists(o_jefe)) {
        o_jefe.orbes_activos = max(0, o_jefe.orbes_activos - 1);
    }
    
    // Crear explosión visual
    var _exp = instance_create_layer(x, y, "Instances", o_explosion_escudo_jefe);
    _exp.image_xscale = 2.5; // Hacerla más grande para que coincida con el orbe
    _exp.image_yscale = 2.5;
    _exp.depth = -510;       // Dibujarla encima del jefe y del orbe

    with (other) instance_destroy();
    instance_destroy();
} else {
    with (other) instance_destroy();
}
