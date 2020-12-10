/*
 * core.cpp
 *
 *  Created on: 1 Dec 2020
 *      Author: xasin
 */


#include "core.h"
#include "pins.h"

#include <nvs_flash.h>
#include <driver/gpio.h>

#include <xasin/audio/TXStream.h>
#include <xasin/TrekAudio.h>

#define LOG_LOCAL_LEVEL ESP_LOG_DEBUG
#include <esp_log.h>

using namespace Xasin;

namespace Core {

Audio::TX audio;
MQTT::Handler mqtt;

NeoController::NeoController leds(PIN_NEOPIXEL, RMT_CHANNEL_0, 5);
std::array<NeoController::IndicatorBulb, 4> button_bulbs;

Audio::TXStream mqtt_stream(audio);

char unit_nametag[64] = {};

void get_nametag() {
	nvs_handle_t read_handle;

	uint8_t smacc[6] = {};

	esp_read_mac(smacc, ESP_MAC_WIFI_STA);

	sprintf(unit_nametag, "%02X.%02X.%02X.%02X.%02X.%02X",
		smacc[0], smacc[1], smacc[2],
		smacc[3], smacc[4], smacc[5]);

	size_t nametag_len = sizeof(unit_nametag);

	nvs_open("xasin", NVS_READONLY, &read_handle);
	nvs_get_str(read_handle, "unit_name", unit_nametag, &nametag_len);
	nvs_close(read_handle);
}

void init_gpio() {
	gpio_config_t input_config = {
			uint64_t(1)<<PIN_BTN_STOP | uint64_t(1)<<PIN_BTN_REC | uint64_t(1)<<PIN_BTN_PLAY,
			GPIO_MODE_INPUT,
			GPIO_PULLUP_ENABLE,
			GPIO_PULLDOWN_DISABLE,
			GPIO_INTR_DISABLE
	};

	gpio_config(&input_config);
}

uint8_t get_buttons() {
	return (1-gpio_get_level(PIN_BTN_STOP)) | ((1-gpio_get_level(PIN_BTN_PLAY))<<1) | ((1-gpio_get_level(PIN_BTN_REC))<<2);
}

void core_processing_task(void *args) {
	while(true) {
		xTaskNotifyWait(0, 0, nullptr, portMAX_DELAY);
		audio.largestack_process();
	}
}

void button_fx_tick() {
	// Set up the MQTT Status indicator based on connectivity
	if(mqtt.is_disconnected() == 255)
		button_bulbs[0].set(Material::PURPLE, NeoController::IDLE);
	else if(mqtt.is_disconnected() == 2)
		button_bulbs[0].set(Material::RED, NeoController::FLASH);
	else if(mqtt.is_disconnected() == 1)
		button_bulbs[0].set(Material::AMBER, NeoController::FLASH);
	else
		button_bulbs[0].set(Material::GREEN, NeoController::IDLE);
}

void effects_task(void *args) {
	uint8_t old_buttons = 0;

	while(true) {
		vTaskDelay(25 / portTICK_PERIOD_MS);

		if(get_buttons() > old_buttons) {
			old_buttons = get_buttons();
			char bfr[5];
			itoa(old_buttons, bfr, 2);

			ESP_LOGD("BTNS", "New buttons are: %s", bfr);

			Xasin::Trek::play(Xasin::Trek::KEYPRESS);

			if(old_buttons == 1)
				mqtt.publish_to(std::string("Wuffcorder/") + unit_nametag + "/BTN", "PLAY", 4);
		}
		old_buttons = get_buttons();

		button_fx_tick();

		for(int i=0; i<button_bulbs.size(); i++)
			leds[i+1] = button_bulbs[i].tick();

		uint8_t brightness = 50;
		if(audio.get_volume_estimate() > 0)
			brightness = 255;
		else
			brightness = 255 + 205 * audio.get_volume_estimate()/40;
		leds[0] = NeoController::Color(Material::ORANGE, brightness);

		leds.update();
	}
}

void init_networking() {
	std::string baseMqttTopic("Wuffcorder/");
	baseMqttTopic += unit_nametag;

	if(!Xasin::MQTT::Handler::start_wifi_from_nvs()) {
	}
	if(!mqtt.start_from_nvs(baseMqttTopic + "/State")) {
	}

	ESP_LOGI("Core", "Base MQTT Topic is %s", baseMqttTopic.data());

	mqtt.subscribe_to(baseMqttTopic + "/Audio/In", [](MQTT::MQTT_Packet data) {
		const uint8_t *data_ptr = reinterpret_cast<const uint8_t *>(data.data.data());

		uint8_t num_packets  = *data_ptr;
		size_t packet_length = (data.data.length() - 1) / num_packets;

		mqtt_stream.feed_packets(data_ptr + 1, packet_length, num_packets);
	}, 0);
}

void init() {
	get_nametag();

	init_gpio();

	xTaskCreate(effects_task, "GFX", 3*1024, nullptr, 10, nullptr);

	TaskHandle_t processing_task;
	xTaskCreate(core_processing_task, "LARGE", 32768, nullptr, 10, &processing_task);

    i2s_pin_config_t pin_config = {
    	PIN_AUDIO_TX_BCK,
		PIN_AUDIO_TX_LRCK,
		PIN_AUDIO_TX_DATA,
		I2S_PIN_NO_CHANGE
    };

	audio.init(processing_task, pin_config);
	audio.calculate_volume = true;
	audio.volume_mod = 50;

	for(auto &b : button_bulbs)
		b = NeoController::Bulb::OK;

	init_networking();
	mqtt.set_status("READY");

	mqtt_stream.start(false);

	Xasin::Trek::init(audio);
	Xasin::Trek::play(Xasin::Trek::PROG_DONE);
}

}
