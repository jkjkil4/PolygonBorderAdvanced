// 得到视野x
function viewX(_id = 0) { return camera_get_view_x(view_camera[_id]); }
// 得到视野y
function viewY(_id = 0) { return camera_get_view_y(view_camera[_id]); }
// 得到视野宽度
function viewW(_id = 0) { return camera_get_view_width(view_camera[_id]); }
// 得到视野高度
function viewH(_id = 0) { return camera_get_view_height(view_camera[_id]); }