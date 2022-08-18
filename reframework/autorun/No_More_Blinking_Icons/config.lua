local config = {};
local table_helpers;

config.current_config = nil;
config.config_file_name = "No More Blinking Icons/config.json";

config.default_config = {};

function config.init()
	config.default_config = {
		status_icons = {
			player = {
				mode = "Always Adjusted",
				displayed_icon_update_speed = 0.005,
				hidden_icon_update_speed = 0.01
			},

			other_players = {
				mode = "Always Adjusted",
				displayed_icon_update_speed = 0.005,
				hidden_icon_update_speed = 0.01
			},

			servants = {
				mode = "Always Adjusted",
				displayed_icon_update_speed = 0.005,
				hidden_icon_update_speed = 0.01
			},

			otomos = {
				mode = "Always Adjusted",
				displayed_icon_update_speed = 0.005,
				hidden_icon_update_speed = 0.01
			}
		},
		weapon_icons = {
			player = {
				mode = "Adjusted",
				icon_update_speed_multiplier = 0.2
			},

			others = {
				mode = "Adjusted",
				icon_update_speed_multiplier = 0.2
			}
		}
	};
end

function config.load()
	local loaded_config = json.load_file(config.config_file_name);
	if loaded_config ~= nil then
		log.info("[No More Blinking Icons] config.json loaded successfully");
		config.current_config = table_helpers.merge(config.default_config, loaded_config);
	else
		log.error("[No More Blinking Icons] Failed to load config.json");
		config.current_config = table_helpers.deep_copy(config.default_config);
	end
end

function config.save()
	-- save current config to disk, replacing any existing file
	local success = json.dump_file(config.config_file_name, config.current_config);
	if success then
		log.info("[No More Blinking Icons] config.json saved successfully");
	else
		log.error("[No More Blinking Icons] Failed to save config.json");
	end
end

function config.init_module()
	table_helpers = require("No_More_Blinking_Icons.table_helpers");

	config.init();
	config.load();
	config.current_config.version = "2.0";
end

return config;
