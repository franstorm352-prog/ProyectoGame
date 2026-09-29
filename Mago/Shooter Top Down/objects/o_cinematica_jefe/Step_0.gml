// =============================================
// o_cinematica_jefe  |  Step Event
// =============================================
if (!instance_exists(o_player_mago)) exit;

var _cam = view_camera[0];
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);

var _base_x = clamp(o_player_mago.x - (_cam_w / 2), 0, room_width - _cam_w);
var _base_y = clamp(o_player_mago.y - (_cam_h / 2), 0, room_height - _cam_h);

var _shake_x = irandom_range(-shake_amount, shake_amount);
var _shake_y = irandom_range(-shake_amount, shake_amount);

camera_set_view_pos(_cam, _base_x + _shake_x, _base_y + _shake_y);
