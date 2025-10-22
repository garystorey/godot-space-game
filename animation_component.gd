# Godot 4.4 — GDScript
@tool
class_name AnimateNode
extends Node

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

# ── Position Y
@export_group("Position Y")
@export var pos_y_enabled := false
@export var pos_y_to := 0.0
@export var pos_y_duration := 0.5
@export var pos_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var pos_y_ease: Tween.EaseType = Tween.EASE_IN_OUT

# ── Rotation (degrees)
@export_group("Rotation (degrees)")
@export var rot_enabled := false
@export var rot_to_degrees := 0.0
@export var rot_duration := 0.5
@export var rot_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var rot_ease: Tween.EaseType = Tween.EASE_IN_OUT

# ── Scale X
@export_group("Scale X")
@export var scale_x_enabled := false
@export var scale_x_to := 1.0
@export var scale_x_duration := 0.5
@export var scale_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var scale_x_ease: Tween.EaseType = Tween.EASE_IN_OUT

# ── Scale Y
@export_group("Scale Y")
@export var scale_y_enabled := false
@export var scale_y_to := 1.0
@export var scale_y_duration := 0.5
@export var scale_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var scale_y_ease: Tween.EaseType = Tween.EASE_IN_OUT

# ── Pivot Offset X
@export_group("Pivot Offset X")
@export var pivot_x_enabled := false
@export var pivot_x_to := 0.0
@export var pivot_x_duration := 0.5
@export var pivot_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var pivot_x_ease: Tween.EaseType = Tween.EASE_IN_OUT

# ── Pivot Offset Y
@export_group("Pivot Offset Y")
@export var pivot_y_enabled := false
@export var pivot_y_to := 0.0
@export var pivot_y_duration := 0.5
@export var pivot_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var pivot_y_ease: Tween.EaseType = Tween.EASE_IN_OUT

# ── Color / Alpha
@export_group("Modulate (Color)")
@export var modulate_enabled := false
@export var modulate_to := Color(1, 1, 1, 1)
@export var modulate_duration := 0.5
@export var modulate_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var modulate_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Alpha (modulate.a)")
@export var alpha_enabled := false
@export var alpha_to := 1.0
@export var alpha_duration := 0.5
@export var alpha_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var alpha_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Self Modulate (Color)")
@export var self_modulate_enabled := false
@export var self_modulate_to := Color(1, 1, 1, 1)
@export var self_modulate_duration := 0.5
@export var self_modulate_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var self_modulate_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Self Alpha (self_modulate.a)")
@export var self_alpha_enabled := false
@export var self_alpha_to := 1.0
@export var self_alpha_duration := 0.5
@export var self_alpha_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var self_alpha_ease: Tween.EaseType = Tween.EASE_IN_OUT

# ── Node2D-only
@export_group("Skew (Node2D)")
@export var skew_enabled := false
@export var skew_to := 0.0
@export var skew_duration := 0.5
@export var skew_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var skew_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Global Position X (Node2D)")
@export var gpos_x_enabled := false
@export var gpos_x_to := 0.0
@export var gpos_x_duration := 0.5
@export var gpos_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var gpos_x_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Global Position Y (Node2D)")
@export var gpos_y_enabled := false
@export var gpos_y_to := 0.0
@export var gpos_y_duration := 0.5
@export var gpos_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var gpos_y_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Global Rotation ° (Node2D)")
@export var grot_enabled := false
@export var grot_to_degrees := 0.0
@export var grot_duration := 0.5
@export var grot_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var grot_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Global Scale X (Node2D)")
@export var gscale_x_enabled := false
@export var gscale_x_to := 1.0
@export var gscale_x_duration := 0.5
@export var gscale_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var gscale_x_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Global Scale Y (Node2D)")
@export var gscale_y_enabled := false
@export var gscale_y_to := 1.0
@export var gscale_y_duration := 0.5
@export var gscale_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var gscale_y_ease: Tween.EaseType = Tween.EASE_IN_OUT

# ── Control-only
@export_group("Size X (Control)")
@export var size_x_enabled := false
@export var size_x_to := 0.0
@export var size_x_duration := 0.5
@export var size_x_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var size_x_ease: Tween.EaseType = Tween.EASE_IN_OUT

@export_group("Size Y (Control)")
@export var size_y_enabled := false
@export var size_y_to := 0.0
@export var size_y_duration := 0.5
@export var size_y_trans: Tween.TransitionType = Tween.TRANS_SINE
@export var size_y_ease: Tween.EaseType = Tween.EASE_IN_OUT


func _enter_tree() -> void:
	# Initialize typed sequential_order safely (works in editor because @tool)
	if sequential_order.is_empty():
		sequential_order.assign(ALL_KEYS)


func _ready() -> void:
	parent = get_parent()
	if parent == null:
		push_warning("AnimateNode has no parent; using self.")
		parent = self
	# Don’t auto-run in the editor even if enabled
	if auto_play_on_ready and not Engine.is_editor_hint():
		play_enabled()


# Editor button handler (safe, non-recursive)
func _set_editor_action(value: EditorAction) -> void:
	if value == EditorAction.RESET_ORDER:
		sequential_order.assign(ALL_KEYS)  # keeps Array[StringName] typing
		set_deferred("editor_action", EditorAction.NONE)


func play_enabled() -> Tween:
	var t: Tween = parent.create_tween()
	t.set_parallel(play_parallel)

	if play_parallel:
		for key in ALL_KEYS:
			_add_track_key(t, key)
	else:
		for key in sequential_order:
			_add_track_key(t, key)

	t.play()
	return t


func _add_track_key(t: Tween, key: StringName) -> void:
	match key:
		&"pos_x":
			if pos_x_enabled:
				var tw = t.tween_property(parent, P.pos_x, pos_x_to, pos_x_duration)
				tw.set_trans(pos_x_trans); tw.set_ease(pos_x_ease)
		&"pos_y":
			if pos_y_enabled:
				var tw = t.tween_property(parent, P.pos_y, pos_y_to, pos_y_duration)
				tw.set_trans(pos_y_trans); tw.set_ease(pos_y_ease)
		&"rot_deg":
			if rot_enabled:
				var tw = t.tween_property(parent, P.rot_deg, rot_to_degrees, rot_duration)
				tw.set_trans(rot_trans); tw.set_ease(rot_ease)
		&"scale_x":
			if scale_x_enabled:
				var tw = t.tween_property(parent, P.scale_x, scale_x_to, scale_x_duration)
				tw.set_trans(scale_x_trans); tw.set_ease(scale_x_ease)
		&"scale_y":
			if scale_y_enabled:
				var tw = t.tween_property(parent, P.scale_y, scale_y_to, scale_y_duration)
				tw.set_trans(scale_y_trans); tw.set_ease(scale_y_ease)
		&"pivot_x":
			if pivot_x_enabled:
				var tw = t.tween_property(parent, P.pivot_x, pivot_x_to, pivot_x_duration)
				tw.set_trans(pivot_x_trans); tw.set_ease(pivot_x_ease)
		&"pivot_y":
			if pivot_y_enabled:
				var tw = t.tween_property(parent, P.pivot_y, pivot_y_to, pivot_y_duration)
				tw.set_trans(pivot_y_trans); tw.set_ease(pivot_y_ease)
		&"modulate":
			if modulate_enabled:
				var tw = t.tween_property(parent, P.modulate, modulate_to, modulate_duration)
				tw.set_trans(modulate_trans); tw.set_ease(modulate_ease)
		&"alpha":
			if alpha_enabled:
				var tw = t.tween_property(parent, P.alpha, alpha_to, alpha_duration)
				tw.set_trans(alpha_trans); tw.set_ease(alpha_ease)
		&"self_modulate":
			if self_modulate_enabled:
				var tw = t.tween_property(parent, P.self_modulate, self_modulate_to, self_modulate_duration)
				tw.set_trans(self_modulate_trans); tw.set_ease(self_modulate_ease)
		&"self_alpha":
			if self_alpha_enabled:
				var tw = t.tween_property(parent, P.self_alpha, self_alpha_to, self_alpha_duration)
				tw.set_trans(self_alpha_trans); tw.set_ease(self_alpha_ease)
		&"skew":
			if skew_enabled and parent is Node2D:
				var tw = t.tween_property(parent, P.skew, skew_to, skew_duration)
				tw.set_trans(skew_trans); tw.set_ease(skew_ease)
		&"gpos_x":
			if gpos_x_enabled and parent is Node2D:
				var tw = t.tween_property(parent, P.gpos_x, gpos_x_to, gpos_x_duration)
				tw.set_trans(gpos_x_trans); tw.set_ease(gpos_x_ease)
		&"gpos_y":
			if gpos_y_enabled and parent is Node2D:
				var tw = t.tween_property(parent, P.gpos_y, gpos_y_to, gpos_y_duration)
				tw.set_trans(gpos_y_trans); tw.set_ease(gpos_y_ease)
		&"grot_deg":
			if grot_enabled and parent is Node2D:
				var tw = t.tween_property(parent, P.grot_deg, grot_to_degrees, grot_duration)
				tw.set_trans(grot_trans); tw.set_ease(grot_ease)
		&"gscale_x":
			if gscale_x_enabled and parent is Node2D:
				var tw = t.tween_property(parent, P.gscale_x, gscale_x_to, gscale_x_duration)
				tw.set_trans(gscale_x_trans); tw.set_ease(gscale_x_ease)  # ✅ fixed
		&"gscale_y":
			if gscale_y_enabled and parent is Node2D:
				var tw = t.tween_property(parent, P.gscale_y, gscale_y_to, gscale_y_duration)
				tw.set_trans(gscale_y_trans); tw.set_ease(gscale_y_ease)
		&"size_x":
			if size_x_enabled and parent is Control:
				var tw = t.tween_property(parent, P.size_x, size_x_to, size_x_duration)
				tw.set_trans(size_x_trans); tw.set_ease(size_x_ease)
		&"size_y":
			if size_y_enabled and parent is Control:
				var tw = t.tween_property(parent, P.size_y, size_y_to, size_y_duration)
				tw.set_trans(size_y_trans); tw.set_ease(size_y_ease)
		_:
			pass


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
	var seen := {}
	var dups: Array[StringName] = []
	for key in sequential_order:
		if seen.has(key):
			dups.append(key)
		else:
			seen[key] = true
	if not dups.is_empty():
		warnings.append("sequential_order contains duplicate keys: %s" % [dups])

	return warnings
