local this = {};

local utils;
local config;

local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;
local os = os;
local ValueType = ValueType;
local package = package;

this.is_opened = false;
this.status = "OK";

this.window_position = Vector2f.new(480, 200);
this.window_pivot = Vector2f.new(0, 0);
this.window_size = Vector2f.new(720, 650);
this.window_flags = 0x10120;

this.color_picker_flags = 327680;
this.decimal_input_flags = 33;

this.status_icon_modes = {"Normal", "Always Adjusted", "Adjusted when Visible", "Adjusted when Hidden", "Always Visible", "Always Hidden"};

this.player_weapon_icon_modes = {"Normal", "Always Adjusted", "Adjusted when Visible", "Adjusted when Weapon Icon Visible", "Adjusted when Discovered Icon Visible",
							"Adjusted when Ready Icon Visible", "Adjusted when Hidden", "Always Visible Weapon Icon", "Always Visible Discovered Icon",
							"Always Visible Ready Icon", "Always Hidden"};

this.others_weapon_icon_modes = {"Normal", "Always Adjusted", "Adjusted when Visible", "Adjusted when Weapon Icon Visible", "Adjusted when Discovered Icon Visible",
							"Adjusted when Host Icon Visible", "Adjusted when Hidden", "Always Visible Weapon Icon", "Always Visible Discovered Icon",
							"Always Visible Host Icon", "Always Hidden"};

function this.init()
end

function this.draw()
	imgui.set_next_window_pos(this.window_position, 1 << 3, this.window_pivot);
	imgui.set_next_window_size(this.window_size, 1 << 3);

	this.is_opened = imgui.begin_window(
		"No More Blinking Icons v" .. config.current_config.version, this.is_opened, this.window_flags);

	if not this.is_opened then
		imgui.end_window();
		return;
	end

	local config_changed = false;
	local changed = false;
	local index = 1;

	if imgui.button("Reset Config") then
		config.reset();
		config_changed = true;
	end

	imgui.same_line();
	imgui.text("Status: " .. tostring(this.status));

	changed, config.current_config.enabled = imgui.checkbox("Enabled", config.current_config.enabled);
	config_changed = config_changed or changed;

	if imgui.tree_node("Status Icons") then
		if imgui.tree_node("Player") then
			changed, index = imgui.combo("Mode",
				utils.table.find_index(this.status_icon_modes, config.current_config.status_icons.player.mode),
				this.status_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.status_icons.player.mode = this.status_icon_modes[index];
			end

		
			changed, config.current_config.status_icons.player.displayed_icon_timer_speed = imgui.drag_float("Displayed Icon Timer Speed",
				config.current_config.status_icons.player.displayed_icon_timer_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			changed, config.current_config.status_icons.player.hidden_icon_timer_speed = imgui.drag_float("Hidden Icon Timer Speed",
				config.current_config.status_icons.player.hidden_icon_timer_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Other Players") then
			changed, index = imgui.combo("Mode",
				utils.table.find_index(this.status_icon_modes, config.current_config.status_icons.other_players.mode),
				this.status_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.status_icons.other_players.mode = this.status_icon_modes[index];
			end

		
			changed, config.current_config.status_icons.other_players.displayed_icon_timer_speed = imgui.drag_float("Displayed Icon Timer Speed",
				config.current_config.status_icons.other_players.displayed_icon_timer_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			changed, config.current_config.status_icons.other_players.hidden_icon_timer_speed = imgui.drag_float("Hidden Icon Timer Speed",
				config.current_config.status_icons.other_players.hidden_icon_timer_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Followers") then
			changed, index = imgui.combo("Mode",
				utils.table.find_index(this.status_icon_modes, config.current_config.status_icons.servants.mode),
				this.status_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.status_icons.servants.mode = this.status_icon_modes[index];
			end
		
			changed, config.current_config.status_icons.servants.displayed_icon_timer_speed = imgui.drag_float("Displayed Icon Timer Speed",
				config.current_config.status_icons.servants.displayed_icon_timer_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			changed, config.current_config.status_icons.servants.hidden_icon_timer_speed = imgui.drag_float("Hidden Icon Timer Speed",
				config.current_config.status_icons.servants.hidden_icon_timer_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Buddies") then
			changed, index = imgui.combo("Mode",
				utils.table.find_index(this.status_icon_modes, config.current_config.status_icons.otomos.mode),
				this.status_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.status_icons.otomos.mode = this.status_icon_modes[index];
			end
	
			changed, config.current_config.status_icons.otomos.displayed_icon_timer_speed = imgui.drag_float("Displayed Icon Timer Speed",
				config.current_config.status_icons.otomos.displayed_icon_timer_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			changed, config.current_config.status_icons.otomos.hidden_icon_timer_speed = imgui.drag_float("Hidden Icon Timer Speed",
				config.current_config.status_icons.otomos.hidden_icon_timer_speed, 0.0001, 0, 1, "%.4f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Weapon Icons") then
		if imgui.tree_node("Player") then
			changed, index = imgui.combo("Mode",
				utils.table.find_index(this.player_weapon_icon_modes, config.current_config.weapon_icons.player.mode),
				this.player_weapon_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.weapon_icons.player.mode = this.player_weapon_icon_modes[index];
			end
		
			changed, config.current_config.weapon_icons.player.weapon_icon_frame_speed = imgui.drag_float("Weapon Icon Frame Speed",
				config.current_config.weapon_icons.player.weapon_icon_frame_speed, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			changed, config.current_config.weapon_icons.player.discovered_icon_frame_speed = imgui.drag_float("Discovered Icon Frame Speed",
				config.current_config.weapon_icons.player.discovered_icon_frame_speed, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			changed, config.current_config.weapon_icons.player.ready_icon_frame_speed = imgui.drag_float("Ready Icon Frame Speed",
				config.current_config.weapon_icons.player.ready_icon_frame_speed, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			changed, config.current_config.weapon_icons.player.hidden_icon_frame_speed = imgui.drag_float("Hidden Icon Frame Speed",
				config.current_config.weapon_icons.player.hidden_icon_frame_speed, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;


			imgui.tree_pop();
		end

		if imgui.tree_node("Others") then
			changed, index = imgui.combo("Mode",
				utils.table.find_index(this.others_weapon_icon_modes, config.current_config.weapon_icons.others.mode),
				this.others_weapon_icon_modes);
			config_changed = config_changed or changed;

			if changed then
				config.current_config.weapon_icons.others.mode = this.others_weapon_icon_modes[index];
			end
		
			changed, config.current_config.weapon_icons.others.weapon_icon_frame_speed = imgui.drag_float("Weapon Icon Frame Speed",
				config.current_config.weapon_icons.others.weapon_icon_frame_speed, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			changed, config.current_config.weapon_icons.others.discovered_icon_frame_speed = imgui.drag_float("Discovered Icon Frame Speed",
				config.current_config.weapon_icons.others.discovered_icon_frame_speed, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			changed, config.current_config.weapon_icons.others.host_icon_frame_speed = imgui.drag_float("Host Icon Frame Speed",
				config.current_config.weapon_icons.others.host_icon_frame_speed, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			changed, config.current_config.weapon_icons.others.hidden_icon_frame_speed = imgui.drag_float("Hidden Icon Frame Speed",
				config.current_config.weapon_icons.others.hidden_icon_frame_speed, 0.001, 0, 2, "%.3f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if config_changed then
		config.save();
	end
end

function this.init_module()
	utils = require("No_More_Blinking_Icons.utils");
	config = require("No_More_Blinking_Icons.config");

	this.init();
end

return this;
