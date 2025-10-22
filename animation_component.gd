# Godot 4.4 — GDScript
@tool
class_name AnimateNode
extends Node

const NOTIFICATION_EDITOR_PROPERTY_CHANGED := Node.Notification.NOTIFICATION_EDITOR_PROPERTY_CHANGED

const P := {
	# CanvasItem (Node2D + Control)
	"pos_x": "position:x",
	"pos_y": "position:y",
	"rot_deg": "rotation_degrees",
	"scale_x": "scale:x",
	"scale_y": "scale:y",
	"pivot_x": "pivot_offset:x",
	"pivot_y": "pivot_offset:y",
	"modulate": "modulate",
	"alpha": "modulate:a",
	"self_modulate": "self_modulate",
	"self_alpha": "self_modulate:a",
	# Node2D-only
	"skew": "skew",
	"gpos_x": "global_position:x",
	"gpos_y": "global_position:y",
	"grot_deg": "global_rotation_degrees",
	"gscale_x": "global_scale:x",
	"gscale_y": "global_scale:y",
	# Control-only
	"size_x": "size:x",
	"size_y": "size:y",
}

const ALL_KEYS: Array[StringName] = [
	&"pos_x", &"pos_y", &"rot_deg",
	&"scale_x", &"scale_y",
	&"pivot_x", &"pivot_y",
	&"modulate", &"alpha", &"self_modulate", &"self_alpha",
	&"skew", &"gpos_x", &"gpos_y", &"grot_deg", &"gscale_x", &"gscale_y",
	&"size_x", &"size_y"
]

enum EditorAction { NONE, RESET_ORDER }

var parent: Node
var tween_data: Dictionary = {}

@export_group("Playback")
@export var play_parallel: bool = true
@export var auto_play_on_ready: bool = false
@export var sequential_order: Array[StringName] = []

@export_group("Editor Utilities")
@export var editor_action: EditorAction = EditorAction.NONE : set = _set_editor_action

# ── Position X
@export_group("Position X")
@export var pos_x_enabled := false
@export var pos_x_to := 0.0
@export var pos_x_duration := 0.5
@export var pos_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var pos_x_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var pos_x_loop := false
@export var pos_x_yoyo := false

# ── Position Y
@export_group("Position Y")
@export var pos_y_enabled := false
@export var pos_y_to := 0.0
@export var pos_y_duration := 0.5
@export var pos_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var pos_y_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var pos_y_loop := false
@export var pos_y_yoyo := false

# ── Rotation (degrees)
@export_group("Rotation (degrees)")
@export var rot_enabled := false
@export var rot_to_degrees := 0.0
@export var rot_duration := 0.5
@export var rot_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var rot_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var rot_loop := false
@export var rot_yoyo := false

# ── Scale X
@export_group("Scale X")
@export var scale_x_enabled := false
@export var scale_x_to := 1.0
@export var scale_x_duration := 0.5
@export var scale_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var scale_x_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var scale_x_loop := false
@export var scale_x_yoyo := false

# ── Scale Y
@export_group("Scale Y")
@export var scale_y_enabled := false
@export var scale_y_to := 1.0
@export var scale_y_duration := 0.5
@export var scale_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var scale_y_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var scale_y_loop := false
@export var scale_y_yoyo := false

# ── Pivot Offset X
@export_group("Pivot Offset X")
@export var pivot_x_enabled := false
@export var pivot_x_to := 0.0
@export var pivot_x_duration := 0.5
@export var pivot_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var pivot_x_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var pivot_x_loop := false
@export var pivot_x_yoyo := false

# ── Pivot Offset Y
@export_group("Pivot Offset Y")
@export var pivot_y_enabled := false
@export var pivot_y_to := 0.0
@export var pivot_y_duration := 0.5
@export var pivot_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var pivot_y_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var pivot_y_loop := false
@export var pivot_y_yoyo := false

# ── Color / Alpha
@export_group("Modulate (Color)")
@export var modulate_enabled := false
@export var modulate_to := Color(1, 1, 1, 1)
@export var modulate_duration := 0.5
@export var modulate_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var modulate_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var modulate_loop := false
@export var modulate_yoyo := false

@export_group("Alpha (modulate.a)")
@export var alpha_enabled := false
@export var alpha_to := 1.0
@export var alpha_duration := 0.5
@export var alpha_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var alpha_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var alpha_loop := false
@export var alpha_yoyo := false

@export_group("Self Modulate (Color)")
@export var self_modulate_enabled := false
@export var self_modulate_to := Color(1, 1, 1, 1)
@export var self_modulate_duration := 0.5
@export var self_modulate_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var self_modulate_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var self_modulate_loop := false
@export var self_modulate_yoyo := false

@export_group("Self Alpha (self_modulate.a)")
@export var self_alpha_enabled := false
@export var self_alpha_to := 1.0
@export var self_alpha_duration := 0.5
@export var self_alpha_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var self_alpha_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var self_alpha_loop := false
@export var self_alpha_yoyo := false

# ── Node2D-only
@export_group("Skew (Node2D)")
@export var skew_enabled := false
@export var skew_to := 0.0
@export var skew_duration := 0.5
@export var skew_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var skew_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var skew_loop := false
@export var skew_yoyo := false

@export_group("Global Position X (Node2D)")
@export var gpos_x_enabled := false
@export var gpos_x_to := 0.0
@export var gpos_x_duration := 0.5
@export var gpos_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var gpos_x_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var gpos_x_loop := false
@export var gpos_x_yoyo := false

@export_group("Global Position Y (Node2D)")
@export var gpos_y_enabled := false
@export var gpos_y_to := 0.0
@export var gpos_y_duration := 0.5
@export var gpos_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var gpos_y_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var gpos_y_loop := false
@export var gpos_y_yoyo := false

@export_group("Global Rotation ° (Node2D)")
@export var grot_enabled := false
@export var grot_to_degrees := 0.0
@export var grot_duration := 0.5
@export var grot_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var grot_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var grot_loop := false
@export var grot_yoyo := false

@export_group("Global Scale X (Node2D)")
@export var gscale_x_enabled := false
@export var gscale_x_to := 1.0
@export var gscale_x_duration := 0.5
@export var gscale_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var gscale_x_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var gscale_x_loop := false
@export var gscale_x_yoyo := false

@export_group("Global Scale Y (Node2D)")
@export var gscale_y_enabled := false
@export var gscale_y_to := 1.0
@export var gscale_y_duration := 0.5
@export var gscale_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var gscale_y_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var gscale_y_loop := false
@export var gscale_y_yoyo := false

# ── Control-only
@export_group("Size X (Control)")
@export var size_x_enabled := false
@export var size_x_to := 0.0
@export var size_x_duration := 0.5
@export var size_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var size_x_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var size_x_loop := false
@export var size_x_yoyo := false

@export_group("Size Y (Control)")
@export var size_y_enabled := false
@export var size_y_to := 0.0
@export var size_y_duration := 0.5
@export var size_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var size_y_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export var size_y_loop := false
@export var size_y_yoyo := false


func _enter_tree() -> void:
	# Initialize typed sequential_order safely (works in editor because @tool)
	if sequential_order.is_empty():
		sequential_order.assign(ALL_KEYS)
	_refresh_tween_data()


func _ready() -> void:
	parent = get_parent()
	if parent == null:
		push_warning("AnimateNode has no parent; using self.")
		parent = self
	# Don’t auto-run in the editor even if enabled
	if auto_play_on_ready and not Engine.is_editor_hint():
		play_enabled()
	_refresh_tween_data()


func _notification(what: int) -> void:
	if what == NOTIFICATION_POSTINITIALIZE or what == NOTIFICATION_EDITOR_PROPERTY_CHANGED:
		_refresh_tween_data()


# Editor button handler (safe, non-recursive)
func _set_editor_action(value: EditorAction) -> void:
	if value == EditorAction.RESET_ORDER:
		sequential_order.assign(ALL_KEYS)  # keeps Array[StringName] typing
		set_deferred("editor_action", EditorAction.NONE)


func play_enabled() -> Tween:
	var t: Tween = parent.create_tween()
	t.set_parallel(play_parallel)

	_refresh_tween_data()
	var requires_loop := false

	if play_parallel:
		for key in ALL_KEYS:
			if _add_track_key(t, key, tween_data):
				requires_loop = true
	else:
		for key in sequential_order:
			if _add_track_key(t, key, tween_data):
				requires_loop = true

	if requires_loop:
		t.set_loops()

	t.play()
	return t


func _add_track_key(t: Tween, key: StringName, data_source: Dictionary) -> bool:
	if not data_source.has(key):
		return false

	var data: Dictionary = data_source[key]
	if not data.get("enabled", false):
		return false

	if data.get("requires_node2d", false) and not (parent is Node2D):
		return false

	if data.get("requires_control", false) and not (parent is Control):
		return false

	var track_loop := data.get("loop", false)
	var track_yoyo := data.get("yoyo", false)
	var property_path: String = data.get("property", "")
	if property_path.is_empty():
		return false

	_tween_property(
		t,
		property_path,
		data.get("to"),
		data.get("duration", 0.5),
		data.get("trans", Tween.TRANS_LINEAR),
		data.get("ease", Tween.EASE_IN_OUT),
		track_yoyo
	)
	return track_loop


func _refresh_tween_data() -> void:
	tween_data = {
		&"pos_x": _make_track_entry(pos_x_enabled, P.pos_x, pos_x_to, pos_x_duration, pos_x_trans, pos_x_ease, pos_x_loop, pos_x_yoyo),
		&"pos_y": _make_track_entry(pos_y_enabled, P.pos_y, pos_y_to, pos_y_duration, pos_y_trans, pos_y_ease, pos_y_loop, pos_y_yoyo),
		&"rot_deg": _make_track_entry(rot_enabled, P.rot_deg, rot_to_degrees, rot_duration, rot_trans, rot_ease, rot_loop, rot_yoyo),
		&"scale_x": _make_track_entry(scale_x_enabled, P.scale_x, scale_x_to, scale_x_duration, scale_x_trans, scale_x_ease, scale_x_loop, scale_x_yoyo),
		&"scale_y": _make_track_entry(scale_y_enabled, P.scale_y, scale_y_to, scale_y_duration, scale_y_trans, scale_y_ease, scale_y_loop, scale_y_yoyo),
		&"pivot_x": _make_track_entry(pivot_x_enabled, P.pivot_x, pivot_x_to, pivot_x_duration, pivot_x_trans, pivot_x_ease, pivot_x_loop, pivot_x_yoyo),
		&"pivot_y": _make_track_entry(pivot_y_enabled, P.pivot_y, pivot_y_to, pivot_y_duration, pivot_y_trans, pivot_y_ease, pivot_y_loop, pivot_y_yoyo),
		&"modulate": _make_track_entry(modulate_enabled, P.modulate, modulate_to, modulate_duration, modulate_trans, modulate_ease, modulate_loop, modulate_yoyo),
		&"alpha": _make_track_entry(alpha_enabled, P.alpha, alpha_to, alpha_duration, alpha_trans, alpha_ease, alpha_loop, alpha_yoyo),
		&"self_modulate": _make_track_entry(self_modulate_enabled, P.self_modulate, self_modulate_to, self_modulate_duration, self_modulate_trans, self_modulate_ease, self_modulate_loop, self_modulate_yoyo),
		&"self_alpha": _make_track_entry(self_alpha_enabled, P.self_alpha, self_alpha_to, self_alpha_duration, self_alpha_trans, self_alpha_ease, self_alpha_loop, self_alpha_yoyo),
		&"skew": _make_track_entry(skew_enabled, P.skew, skew_to, skew_duration, skew_trans, skew_ease, skew_loop, skew_yoyo, true),
		&"gpos_x": _make_track_entry(gpos_x_enabled, P.gpos_x, gpos_x_to, gpos_x_duration, gpos_x_trans, gpos_x_ease, gpos_x_loop, gpos_x_yoyo, true),
		&"gpos_y": _make_track_entry(gpos_y_enabled, P.gpos_y, gpos_y_to, gpos_y_duration, gpos_y_trans, gpos_y_ease, gpos_y_loop, gpos_y_yoyo, true),
		&"grot_deg": _make_track_entry(grot_enabled, P.grot_deg, grot_to_degrees, grot_duration, grot_trans, grot_ease, grot_loop, grot_yoyo, true),
		&"gscale_x": _make_track_entry(gscale_x_enabled, P.gscale_x, gscale_x_to, gscale_x_duration, gscale_x_trans, gscale_x_ease, gscale_x_loop, gscale_x_yoyo, true),
		&"gscale_y": _make_track_entry(gscale_y_enabled, P.gscale_y, gscale_y_to, gscale_y_duration, gscale_y_trans, gscale_y_ease, gscale_y_loop, gscale_y_yoyo, true),
		&"size_x": _make_track_entry(size_x_enabled, P.size_x, size_x_to, size_x_duration, size_x_trans, size_x_ease, size_x_loop, size_x_yoyo, false, true),
		&"size_y": _make_track_entry(size_y_enabled, P.size_y, size_y_to, size_y_duration, size_y_trans, size_y_ease, size_y_loop, size_y_yoyo, false, true),
	}


func _make_track_entry(
	enabled: bool,
	property_path: String,
	to_value: Variant,
	duration: float,
	trans: Tween.TransitionType,
	ease: Tween.EaseType,
	loop: bool,
	yoyo: bool,
	requires_node2d: bool = false,
	requires_control: bool = false
) -> Dictionary:
	return {
		"enabled": enabled,
		"property": property_path,
		"to": to_value,
		"duration": duration,
		"trans": trans,
		"ease": ease,
		"loop": loop,
		"yoyo": yoyo,
		"requires_node2d": requires_node2d,
		"requires_control": requires_control,
	}


func _make_track_branch(t: Tween) -> Tween:
        var branch: Tween
        if play_parallel:
                branch = t.parallel()
        else:
                branch = t.sequence()
                branch.set_parallel(false)
        return branch


func _tween_property(t: Tween, property_path: String, to_value: Variant, duration: float, trans: Tween.TransitionType, ease: Tween.EaseType, yoyo: bool) -> void:
        var branch: Tween = _make_track_branch(t)
        var from_value := _get_property_value(property_path)

        var forward: Tween = branch.tween_property(parent, property_path, to_value, duration)
        forward.from(from_value)
        forward.set_trans(trans)
        forward.set_ease(ease)

        if yoyo:
                var backward: Tween = branch.tween_property(parent, property_path, from_value, duration)
                backward.set_trans(trans)
                backward.set_ease(ease)


func _get_property_value(property_path: String) -> Variant:
	if property_path.find(":") != -1:
		return parent.get_indexed(property_path)
	return parent.get(property_path)


# Editor-time validation messages
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	# Unknown keys
	var unknown: Array[StringName] = []
	for key in sequential_order:
		if not ALL_KEYS.has(key):
			unknown.append(key)
	if not unknown.is_empty():
		warnings.append("sequential_order contains unknown keys: %s" % [unknown])

	# Duplicates
        var seen: Dictionary = {}
	var dups: Array[StringName] = []
	for key in sequential_order:
		if seen.has(key):
			dups.append(key)
		else:
			seen[key] = true
	if not dups.is_empty():
		warnings.append("sequential_order contains duplicate keys: %s" % [dups])

	return warnings
