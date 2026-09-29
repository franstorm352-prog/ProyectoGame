// Mientras explota no se mueve ni muere por HP: la animación debe terminar
if (state == "explode") exit;

event_inherited(); // muerte, slow, stun, movimiento y volteo
