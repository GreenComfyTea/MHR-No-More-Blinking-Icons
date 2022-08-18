local customization_menu = {};

local table_helpers;
local config;

customization_menu.is_opened = false;
customization_menu.status = "OK";

customization_menu.window_position = Vector2f.new(480, 200);
customization_menu.window_pivot = Vector2f.new(0, 0);
customization_menu.window_size = Vector2f.new(720, 650);
customization_menu.window_flags = 0x10120;

customization_menu.color_picker_flags = 327680;
customization_menu.decimal_input_flags = 33;

customization_menu.status_icon_modes = {"Normal", "Always Adjusted", "Adjusted when Visible", "Adjusted when Hidden", "Always Visible", "Always Hidden"};
customization_menu.weapon_icon_modes = {"Normal", "Adjusted"};
function customization_menu.init()
end

function customization_menu.draw()
	imgui.set_next_window_pos(customization_menu.window_position, 1 << 3, customization_menu.window_pivot);
	imgui.set_next_window_size(customization_menu.window_size, 1 << 3);

	customization_menu.is_opened = imgui.begin_window(
		"No More Blinking Icons v" .. config.current_config.version, customization_menu.is_opened, customization_menu.window_flags);

	if not customization_menu.is_opened then
		imgui.end_window();
		return;
	end

	local config_changed = false;
	local changed = false;
	local index = 1;

	imgui.text("Status: " .. tostring(customization_menu.status));

	if imgui.tree_node("Status Icons") then
		if imgui.tree_node("Player") then
			changed, index = imgui.combo("Mode",
				table_helpers.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.player.mode),
				customization_menu.status_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.status_icons.player.mode = customization_menu.status_icon_modes[index];
			end

		
			changed, config.current_config.status_icons.player.displayed_icon_update_speed = imgui.drag_float("Displayed Icon Update Speed",
				config.current_config.status_icons.player.displayed_icon_update_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			changed, config.current_config.status_icons.player.hidden_icon_update_speed = imgui.drag_float("Hidden Icon Update Speed",
				config.current_config.status_icons.player.hidden_icon_update_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Other Players") then
			changed, index = imgui.combo("Mode",
				table_helpers.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.other_players.mode),
				customization_menu.status_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.status_icons.other_players.mode = customization_menu.status_icon_modes[index];
			end

		
			changed, config.current_config.status_icons.other_players.displayed_icon_update_speed = imgui.drag_float("Displayed Icon Update Speed",
				config.current_config.status_icons.other_players.displayed_icon_update_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			changed, config.current_config.status_icons.other_players.hidden_icon_update_speed = imgui.drag_float("Hidden Icon Update Speed",
				config.current_config.status_icons.other_players.hidden_icon_update_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Followers") then
			changed, index = imgui.combo("Mode",
				table_helpers.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.servants.mode),
				customization_menu.status_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.status_icons.servants.mode = customization_menu.status_icon_modes[index];
			end
		
			changed, config.current_config.status_icons.servants.displayed_icon_update_speed = imgui.drag_float("Displayed Icon Update Speed",
				config.current_config.status_icons.servants.displayed_icon_update_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			changed, config.current_config.status_icons.servants.hidden_icon_update_speed = imgui.drag_float("Hidden Icon Update Speed",
				config.current_config.status_icons.servants.hidden_icon_update_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Buddies") then
			changed, index = imgui.combo("Mode",
				table_helpers.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.otomos.mode),
				customization_menu.status_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.status_icons.otomos.mode = customization_menu.status_icon_modes[index];
			end
	
			changed, config.current_config.status_icons.otomos.displayed_icon_update_speed = imgui.drag_float("Displayed Icon Update Speed",
				config.current_config.status_icons.otomos.displayed_icon_update_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			changed, config.current_config.status_icons.otomos.hidden_icon_update_speed = imgui.drag_float("Hidden Icon Update Speed",
				config.current_config.status_icons.otomos.hidden_icon_update_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Weapon Icons") then
		if imgui.tree_node("Player") then
			changed, index = imgui.combo("Mode",
				table_helpers.find_index(customization_menu.weapon_icon_modes, config.current_config.weapon_icons.player.mode),
				customization_menu.weapon_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.weapon_icons.player.mode = customization_menu.weapon_icon_modes[index];
			end
		
			changed, config.current_config.weapon_icons.player.icon_update_speed_multiplier = imgui.drag_float("Icon Update Speed Multiplier",
				config.current_config.weapon_icons.player.icon_update_speed_multiplier, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Others") then
			changed, index = imgui.combo("Mode",
				table_helpers.find_index(customization_menu.weapon_icon_modes, config.current_config.weapon_icons.others.mode),
				customization_menu.weapon_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.weapon_icons.others.mode = customization_menu.weapon_icon_modes[index];
			end
		
			changed, config.current_config.weapon_icons.others.icon_update_speed_multiplier = imgui.drag_float("Icon Update Speed Multiplier",
				config.current_config.weapon_icons.others.icon_update_speed_multiplier, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if config_changed then
		config.save();
	end
end

function customization_menu.init_module()
	table_helpers = require("No_More_Blinking_Icons.table_helpers");
	config = require("No_More_Blinking_Icons.config");

	customization_menu.init();
end

return customization_menu;
