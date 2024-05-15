@tool
extends EditorPlugin

var btn_export:Button = null

var P_SETTINGS_DIR = "addons/gd_excelexporter/settings_dir"
var P_EE_PATH = "addons/gd_excelexporter/cmd_path"
	
var DIALOG_SIZE:Vector2i = Vector2i(500,200)

func _enter_tree():
		
	## 项目设置-添加设置
	_add_custom_project_setting(P_SETTINGS_DIR,"res://settings",TYPE_STRING, PROPERTY_HINT_DIR,"配置表所在目录")
	_add_custom_project_setting(P_EE_PATH,"res://addons/GDExcelExporter/ee.exe",TYPE_STRING,PROPERTY_HINT_DIR,"ee命令或者ee.exe路径")
		
	btn_export = Button.new()
	btn_export.icon = load("res://addons/GDExcelExporter/Excel.svg")
	btn_export.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	btn_export.button_down.connect(gen_all)
	btn_export.tooltip_text = "GDExcelExporter导表"
	
	add_tool_menu_item("ExcelExport", gen_all)
	add_control_to_container(CONTAINER_TOOLBAR,btn_export)

func _exit_tree():
	remove_tool_menu_item("ExcelExport")
	remove_control_from_container(CONTAINER_TOOLBAR, btn_export)
	
	for setting in custom_settings:
		_remove_custom_project_setting(setting)

var custom_settings = {}
func _add_custom_project_setting(setting_name: String, default_value, type: int, hint: int=PROPERTY_HINT_NONE, hint_string: String="", basic: bool=true) -> void:
	custom_settings[setting_name] = true
	if ProjectSettings.has_setting(setting_name):
		return
	var setting_info: Dictionary = {
		"name": setting_name,
		"type": type,
		"hint": hint,
		"hint_string": hint_string,
	}

	ProjectSettings.set_setting(setting_name, default_value)
	
	ProjectSettings.add_property_info(setting_info)
	ProjectSettings.set_initial_value(setting_name, default_value)
	ProjectSettings.set_as_basic(setting_name, basic) # 设置为基本设置，非基本设置只能在高级看到
	printt("添加项目配置属性", setting_name)

func _remove_custom_project_setting(name: String):
	if ProjectSettings.has_setting(name):
		ProjectSettings.clear(name)
		ProjectSettings.save()


func gen_all():
	
	var settings_dir_path = ProjectSettings.get_setting(P_SETTINGS_DIR)
	var ee_path = ProjectSettings.get_setting(P_EE_PATH)
	
	
	var settings_abs_path = ProjectSettings.globalize_path(settings_dir_path)
	var ee_abs_path = ProjectSettings.globalize_path(ee_path)
	
	if not DirAccess.dir_exists_absolute(settings_abs_path):
		var warning_box =AcceptDialog.new()
		warning_box.dialog_text = settings_abs_path + " 目录不存在！"
		warning_box.title = "[警告]GDExcelExporter"
		get_editor_interface().get_editor_viewport().add_child(warning_box)
		warning_box.popup_centered(DIALOG_SIZE)
	else:
		
		var warning_box =AcceptDialog.new()
		# 添加到EditorInterface控件节点里才能显示（入树）
		EditorInterface.get_base_control().add_child(warning_box)
		
		warning_box.title = "[导出]GDExcelExporter"
		warning_box.dialog_text = "导出中..." # TODO: 显示不出来，留着吧
		# 弹出到中间
		warning_box.popup_centered(DIALOG_SIZE)
		
		# 等待一帧防止卡住无法弹出
		await get_tree().process_frame
		
		var output = []
		print("=".repeat(10))
		print("导出",settings_abs_path,"下面的所有表")
		
		OS.execute("CMD.exe",["/c",ee_abs_path,"gen-all","--cwd",settings_abs_path],output,true)
		for line in output:
			print(line)
			
		print("导表结束！")
		print("=".repeat(10))
		output.push_front("ee_path_property:"+ee_abs_path)

		warning_box.title = "[导出结束]GDExcelExporter"
		warning_box.dialog_text = "\n".join(output)
		
		await warning_box.confirmed
		warning_box.queue_free() # 得手动销毁节点，不然会一直编辑器树里

		




