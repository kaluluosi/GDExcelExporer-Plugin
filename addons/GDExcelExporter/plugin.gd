tool
extends EditorPlugin

var settings_dir_property = {
	"name": "GDExcelExporter/SettingsDir",
	"type": TYPE_STRING,
	"hint": PROPERTY_HINT_DIR,
	"hint_string": "配置表所在目录"
}
var	ee_path_property = {
		"name": "GDExcelExporter/cmd_path",
		"type":TYPE_STRING,
		"hint": PROPERTY_HINT_DIR,
		"hint_string":"ee命令或者ee.exe路径"
	}

func _enter_tree():
	if not ProjectSettings.has_setting(settings_dir_property.name):
		ProjectSettings.set_setting(settings_dir_property.name, "res://Settings")
		ProjectSettings.add_property_info(settings_dir_property)
		ProjectSettings.set_initial_value(settings_dir_property.name, "res://Settings")
	
	if not ProjectSettings.has_setting(ee_path_property.name):
		ProjectSettings.set_setting(ee_path_property.name, "ee")
		ProjectSettings.add_property_info(ee_path_property)
		ProjectSettings.set_initial_value(ee_path_property.name, "ee")
	
	add_tool_menu_item("ExcelExport", self, "gen_all")

func _exit_tree():
	remove_tool_menu_item("ExcelExport")

func gen_all(ud):
	
	var settings_path = ProjectSettings[settings_dir_property.name]
	var ee_path = ProjectSettings[ee_path_property.name]
	var settings_abs_path = ProjectSettings.globalize_path(settings_path)
	
	var dir = Directory.new()
	if not dir.dir_exists(settings_path):
		var warning_box =AcceptDialog.new()
		warning_box.dialog_text = settings_path + " 目录不存在！"
		warning_box.window_title = "警告！GDExcelExporter"
		get_editor_interface().get_editor_viewport().add_child(warning_box)
		warning_box.popup_centered(Vector2(100,100))
	else:
		var warning_box =AcceptDialog.new()
		warning_box.dialog_text = settings_path + "导出中..."
		warning_box.window_title = "GDExcelExporter"
		get_editor_interface().get_editor_viewport().add_child(warning_box)
		warning_box.popup_centered()
		yield(get_tree(),"physics_frame")

		var output = []
		print("=".repeat(10))
		print("导出",settings_abs_path,"下面的所有表")
		OS.execute(ee_path,["gen-all","--cwd",settings_abs_path],true,output)
		for line in output:
			print(line)
			
		print("导表结束！")
		print("=".repeat(10))
		
		warning_box.dialog_text = "导出结束!"
		
		yield(warning_box,"confirmed")
		warning_box.queue_free() # 得手动销毁，不然会一直编辑器树里
		
		get_editor_interface().get_resource_filesystem().scan()
