local native_customization_menu = {};

local table_helpers;
local config;
local customization_menu;
local player_status_icon_fix;

local mod_menu_api_package_name = "ModOptionsMenu.ModMenuApi";
local mod_menu = nil;

local native_UI = nil;

local status_icon_mode_descriptions = {
	"Set Status Icon Blinking Mode to Normal.",
	"Set Status Icon Blinking Mode to Always Adjusted.",
	"Set Status Icon Blinking Mode to Adjusted when Visible.",
	"Set Status Icon Blinking Mode to Adjusted when Hidden.",
	"Set Status Icon Blinking Mode to Always Visible.",
	"Set Status Icon Blinking Mode to Always Hidden."
};

local weapon_icon_mode_descriptions = {
	"Set Weapon Icon Blinking Mode to Normal.",
	"Set Weapon Icon Blinking Mode to Always Adjusted.",
};

--no idea how this works but google to the rescue
--can use this to check if the api is available and do an alternative to avoid complaints from users
function native_customization_menu.is_module_available(name)
	if package.loaded[name] then
		return true;
	else
		for _, searcher in ipairs(package.searchers or package.loaders) do
			local loader = searcher(name);

			if type(loader) == 'function' then
				package.preload[name] = loader;
				return true;
			end
		end

		return false;
	end
end

function native_customization_menu.draw()
	local changed = false;
	local config_changed = false;
	local new_value = 0;
	local index = 0; 

	mod_menu.Label("Created by: <COL RED>GreenComfyTea</COL>", "",
		"Donate: <COL RED>https://streamelements.com/greencomfytea/tip</COL>\nBuy me a tea: <COL RED>https://ko-fi.com/greencomfytea</COL>\nSometimes I stream: <COL RED>twitch.tv/greencomfytea</COL>");
	mod_menu.Label("Version: <COL RED>" .. config.current_config.version .. "</COL>", "",
		"Donate: <COL RED>https://streamelements.com/greencomfytea/tip</COL>\nBuy me a tea: <COL RED>https://ko-fi.com/greencomfytea</COL>\nSometimes I stream: <COL RED>twitch.tv/greencomfytea</COL>");

	--imgui.text("Status: " .. tostring(customization_menu.status));

	if true then
		mod_menu.Header("Status Icons - Player");

		changed, index = mod_menu.Options("Mode",
			table_helpers.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.player.mode),
			customization_menu.status_icon_modes,
			status_icon_mode_descriptions,
			"Adjust Player Status Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.player.mode = customization_menu.status_icon_modes[index];
		end
		
		changed, new_value = mod_menu.FloatSlider("Displayed Icon Update Speed (x10)",
			config.current_config.status_icons.player.displayed_icon_update_speed * 10, 0, 10, "Adjust Icon Update Speed when it's displayed.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.player.displayed_icon_update_speed = new_value / 10;
		end

		changed, new_value = mod_menu.FloatSlider("Hidden Icon Update Speed (x10)",
			config.current_config.status_icons.player.hidden_icon_update_speed * 10, 0, 10, "Adjust Icon Update Speed when it's hidden.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.player.hidden_icon_update_speed  = new_value / 10;
		end
	end

	if true then
		mod_menu.Header("Status Icons - Other Players");

		changed, index = mod_menu.Options("Mode",
			table_helpers.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.other_players.mode),
			customization_menu.status_icon_modes,
			status_icon_mode_descriptions,
			"Adjust Other Player Status Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.other_players.mode = customization_menu.status_icon_modes[index];
		end
		
		changed, new_value = mod_menu.FloatSlider("Displayed Icon Update Speed (x10)",
			config.current_config.status_icons.other_players.displayed_icon_update_speed * 10, 0, 10, "Adjust Icon Update Speed when it's displayed.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.other_players.displayed_icon_update_speed = new_value / 10;
		end

		changed, new_value = mod_menu.FloatSlider("Hidden Icon Update Speed (x10)",
			config.current_config.status_icons.other_players.hidden_icon_update_speed * 10, 0, 10, "Adjust Icon Update Speed when it's hidden.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.other_players.hidden_icon_update_speed  = new_value / 10;
		end
	end

	if true then
		mod_menu.Header("Status Icons - Followers");

		changed, index = mod_menu.Options("Mode",
			table_helpers.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.servants.mode),
			customization_menu.status_icon_modes,
			status_icon_mode_descriptions,
			"Adjust Follower Status Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.servants.mode = customization_menu.status_icon_modes[index];
		end
		
		changed, new_value = mod_menu.FloatSlider("Displayed Icon Update Speed (x10)",
			config.current_config.status_icons.servants.displayed_icon_update_speed * 10, 0, 10, "Adjust Icon Update Speed when it's displayed.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.servants.displayed_icon_update_speed = new_value / 10;
		end

		changed, new_value = mod_menu.FloatSlider("Hidden Icon Update Speed (x10)",
			config.current_config.status_icons.servants.hidden_icon_update_speed * 10, 0, 10, "Adjust Icon Update Speed when it's hidden.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.servants.hidden_icon_update_speed  = new_value / 10;
		end
	end

	if true then
		mod_menu.Header("Status Icons - Buddies");

		changed, index = mod_menu.Options("Mode",
			table_helpers.find_index(customization_menu.status_icon_modes, config.current_config.status_icons.otomos.mode),
			customization_menu.status_icon_modes,
			status_icon_mode_descriptions,
			"Adjust Buddy Status Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.otomos.mode = customization_menu.status_icon_modes[index];
		end
		
		changed, new_value = mod_menu.FloatSlider("Displayed Icon Update Speed (x10)",
			config.current_config.status_icons.otomos.displayed_icon_update_speed * 10, 0, 10, "Adjust Icon Update Speed when it's displayed.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.otomos.displayed_icon_update_speed = new_value / 10;
		end

		changed, new_value = mod_menu.FloatSlider("Hidden Icon Update Speed (x10)",
			config.current_config.status_icons.otomos.hidden_icon_update_speed * 10, 0, 10, "Adjust Icon Update Speed when it's hidden.\nDisplayed value is 10 times bigger than the real one.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.status_icons.otomos.hidden_icon_update_speed  = new_value / 10;
		end
	end

	if true then
		mod_menu.Header("Weapon Icons - Player");

		changed, index = mod_menu.Options("Mode",
		table_helpers.find_index(customization_menu.weapon_icon_modes, config.current_config.weapon_icons.player.mode),
			customization_menu.weapon_icon_modes,
			weapon_icon_mode_descriptions,
			"Adjust Player Weapon Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.weapon_icons.player.mode = customization_menu.weapon_icon_modes[index];
		end
		
		changed, config.current_config.weapon_icons.player.icon_update_speed_multiplier = mod_menu.FloatSlider("Icon Update Speed Multiplier",
			config.current_config.weapon_icons.player.icon_update_speed_multiplier, 0, 2, "Adjust Icon Update Speed Multiplier.");
		config_changed = config_changed or changed;
	end

	if true then
		mod_menu.Header("Weapon Icons - Others");

		changed, index = mod_menu.Options("Mode",
		table_helpers.find_index(customization_menu.weapon_icon_modes, config.current_config.weapon_icons.others.mode),
			customization_menu.weapon_icon_modes,
			weapon_icon_mode_descriptions,
			"Adjust Other Weapon Icon Blinking Mode.");
		config_changed = config_changed or changed;

		if changed then
			config.current_config.weapon_icons.others.mode = customization_menu.weapon_icon_modes[index];
		end
		
		changed, config.current_config.weapon_icons.others.icon_update_speed_multiplier = mod_menu.FloatSlider("Icon Update Speed Multiplier",
			config.current_config.weapon_icons.others.icon_update_speed_multiplier, 0, 2, "Adjust Icon Update Speed Multiplier.");
		config_changed = config_changed or changed;
	end

	if config_changed then
		config.save();
	end
end

function native_customization_menu.on_reset_all_settings()
	config.current_config = table_helpers.deep_copy(config.default_config);
end

function native_customization_menu.init_module()
	table_helpers = require("No_More_Blinking_Icons.table_helpers");
	config = require("No_More_Blinking_Icons.config");
	customization_menu = require("No_More_Blinking_Icons.customization_menu");
	player_status_icon_fix = require("No_More_Blinking_Icons.player_status_icon_fix");

	if native_customization_menu.is_module_available(mod_menu_api_package_name) then
		mod_menu = require(mod_menu_api_package_name);
	end

	if mod_menu == nil then
		log.info("[No More Blinking Icons] No mod_menu_api API package found. You may need to download it or something.");
		return;
	end

	native_UI = mod_menu.OnMenu(
		"No More Blinking Icons",
		"Fixes insane status and weapon icon blinking. No more epilepsy.",
		native_customization_menu.draw
	);

	native_UI.OnResetAllSettings = native_customization_menu.on_reset_all_settings;

end

return native_customization_menu;
