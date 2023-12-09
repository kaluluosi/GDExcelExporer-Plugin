@tool
extends EditorPlugin

var btn_export:Button = null


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
	
var _dialog_size:Vector2i = Vector2i(500,200)

func _enter_tree():
	
	if not ProjectSettings.has_setting(settings_dir_property.name):
		ProjectSettings.add_property_info(settings_dir_property)
		ProjectSettings.set_initial_value(settings_dir_property.name, "res://settings")
		ProjectSettings.set_setting(settings_dir_property.name, "res://settings")
	
	if not ProjectSettings.has_setting(ee_path_property.name):
		ProjectSettings.add_property_info(ee_path_property)
		ProjectSettings.set_initial_value(settings_dir_property.name, "ee")
		ProjectSettings.set_setting(ee_path_property.name, "res://addons/GDExcelExporter/ee.exe")
		
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
	

func gen_all():
	
	var settings_dir_path = ProjectSettings.get_setting(settings_dir_property.name)
	var ee_path = ProjectSettings.get_setting(ee_path_property.name)
	
	
	var settings_abs_path = ProjectSettings.globalize_path(settings_dir_path)
	var ee_abs_path = ProjectSettings.globalize_path(ee_path)
	
	if not DirAccess.dir_exists_absolute(settings_abs_path):
		var warning_box =AcceptDialog.new()
		warning_box.dialog_text = settings_abs_path + " 目录不存在！"
		warning_box.title = "[警告]GDExcelExporter"
		get_editor_interface().get_editor_viewport().add_child(warning_box)
		warning_box.popup_centered(_dialog_size)
	else:
		
		var warning_box =AcceptDialog.new()
		# 添加到EditorInterface控件节点里才能显示（入树）
		EditorInterface.get_base_control().add_child(warning_box)
		
		warning_box.title = "[导出]GDExcelExporter"
		warning_box.dialog_text = "导出中..." # TODO: 显示不出来，留着吧
		# 弹出到中间
		warning_box.popup_centered(_dialog_size)
		
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
		
		# 触发godot扫描文件改动以重新导入
		# XXX: 并没有达到我想要的效果，这里触发的扫描不会重新加载导出的gd脚本
		# XXX: 目前没有办法在编辑器里面重新载入脚本，但是你可以在脚本编辑器中随便保存一下Godot会识别到导出脚本有更新
		var resource_fs = get_editor_interface().get_resource_filesystem()
		resource_fs.scan()
