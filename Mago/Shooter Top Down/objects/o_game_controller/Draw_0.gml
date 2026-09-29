// DEBUG OVERLAY — eliminar en build final
// El sprite se dibuja en coordenadas del mundo, siguiendo a la cámara.
// Se posiciona 220px (destroy_buffer) antes del borde superior-izquierdo
// de la cámara para que las zonas coincidan pixel-perfect con el sistema.
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);

// Origen del sprite = esquina del límite de destrucción (cam - destroy_buffer)
draw_sprite(s_spawn_overlay, 0, _cam_x - destroy_buffer, _cam_y - destroy_buffer);
