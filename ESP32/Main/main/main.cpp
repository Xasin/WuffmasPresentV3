
#include "freertos/FreeRTOS.h"
#include "esp_wifi.h"
#include "esp_system.h"
#include "esp_event.h"
#include "nvs_flash.h"
#include "driver/gpio.h"

#include "core.h"

#include <lzrtag/weapon.h>
#include <lzrtag/weapon/shot_weapon.h>

#include <lzrtag/weapon/beam_weapon.h>

#include <lzrtag/weapon/SFX/RELOADING/collection.h>

#include <lzrtag/weapon/SFX/SCALPEL-V9/start/collection.h>
#include <lzrtag/weapon/SFX/SCALPEL-V9/loop/collection.h>
#include <lzrtag/weapon/SFX/SCALPEL-V9/end/collection.h>

static const LZRTag::Weapon::beam_weapon_config scalpel_cfg = {
    6000, 0, 1500,
    encoded_audio_Large_EnergyGun_reload_3,
    collection_SCALPEL_V9_start, collection_SCALPEL_V9_loop, collection_SCALPEL_V9_end
};

#include <lzrtag/weapon/SFX/COLIBRI M2/collection.h>

static const LZRTag::Weapon::shot_weapon_config colibri_config = {
    12, 24,
    1000, 4000,
    encoded_audio_RELOADING_3_Laser_pistol_heavy_3,
    collection_COLIBRI_M2,
    170, 2, 150, true
};

#include <lzrtag/weapon/SFX/FN-001-WHIP/collection.h>
#include <lzrtag/weapon/SFX/DP-116-STEELFINGER/collection.h>
#include <lzrtag/weapon/SFX/SW-554M1/collection.h>

#include <lzrtag/weapon/SFX/NICO-6/collection.h>
#include <lzrtag/weapon/SFX/NICO-6/charge/collection.h>

static const LZRTag::Weapon::shot_weapon_config whip_config = {
    32, 128,

    2500, 3500,

    encoded_audio_RELOADING_3_Assault_rifle_med_1,
    collection_FN_001_WHIP,

    130, 0, 0, false
};
static const LZRTag::Weapon::shot_weapon_config steelfinger_config = {
    32, 128,

    2500, 3500,

    encoded_audio_RELOADING_3_Laser_rifle_heavy_1,
    collection_DP_116_STEELFINGER,

    250, 0, 0, false
};
static const LZRTag::Weapon::shot_weapon_config sw_554_config = {
    4, 128,

    2500, 3500,

    encoded_audio_RELOADING_3_Sniper_rifle_light_1,
    collection_SW_554M1,

    1000, 0, 0, true
};

static const LZRTag::Weapon::heavy_weapon_config nico_6_config = {
    50, 200,

    3500, 3500,

    encoded_audio_RELOADING_2_large_2,
    collection_NICO_6_charge,
    collection_NICO_6,

    1300, 350
};

LZRTag::Weapon::Handler wpn_handler(Core::audio);

esp_err_t event_handler(void *ctx, system_event_t *event)
{

	Xasin::MQTT::Handler::try_wifi_reconnect(event);
	Core::mqtt.wifi_handler(event);

    return ESP_OK;
}

extern "C"
void app_main(void)
{
    nvs_flash_init();
    tcpip_adapter_init();
    ESP_ERROR_CHECK( esp_event_loop_init(event_handler, NULL) );

	heap_caps_print_heap_info(MALLOC_CAP_DEFAULT);

	Xasin::MQTT::Handler::set_nvs_wifi("TP-LINK_84CDC2\0", "f36eebda48\0");
//	 Xasin::MQTT::Handler::set_nvs_uri("mqtt://JUNNpEz4Z33vMbGZbB5l6cujsQebJaVjVxU81h2QaWcKXGAW8t72ts9L6cKGauNV@mqtt.flespi.io");
	Xasin::MQTT::Handler::set_nvs_uri("mqtt://xaseiresh.hopto.org");
    Core::init();

    Core::audio.volume_mod = 50;

    std::vector<LZRTag::Weapon::BaseWeapon *> weapons = {
        new LZRTag::Weapon::HeavyWeapon(wpn_handler, nico_6_config),
        new LZRTag::Weapon::ShotWeapon(wpn_handler, whip_config),
        new LZRTag::Weapon::ShotWeapon(wpn_handler, colibri_config),
        new LZRTag::Weapon::ShotWeapon(wpn_handler, steelfinger_config),
        new LZRTag::Weapon::BeamWeapon(wpn_handler, scalpel_cfg),
        new LZRTag::Weapon::ShotWeapon(wpn_handler, sw_554_config)
    };

    wpn_handler.start_thread();

    int wpn = 0;
    wpn_handler.set_weapon(weapons[0]);

    while (true) {
        vTaskDelay(30 / portTICK_PERIOD_MS);

        Core::set_dial(0.5F * weapons[wpn]->get_clip_ammo() / float(weapons[wpn]->get_max_clip_ammo()));

        wpn_handler.update_btn(Core::get_buttons() & 0b100);
        if(Core::get_buttons() & 0b1)
            wpn_handler.tempt_reload();
    
        if(Core::get_buttons() & 0b10) {
            wpn = (wpn+1) % weapons.size();

            wpn_handler.set_weapon(weapons[wpn]);
            while(Core::get_buttons() & 0b10)
                vTaskDelay(30);
        }
    }
}
