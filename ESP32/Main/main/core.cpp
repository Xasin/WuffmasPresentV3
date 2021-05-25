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
#include <driver/ledc.h>

#include <xasin/audio/TXStream.h>
#include <xasin/TrekAudio.h>

#include <lzrtag/weapon.h>
extern LZRTag::Weapon::Handler wpn_handler;

#define LOG_LOCAL_LEVEL ESP_LOG_DEBUG
#include <esp_log.h>

using namespace Xasin;


namespace Core {

void ph(const char *tag) {
	static uint32_t free_heap = 0;

	if(free_heap == 0) {
		ESP_LOGI("NE::HEAP", "Starting off with %dkB heap!", esp_get_free_heap_size() / 1024);
		free_heap = esp_get_free_heap_size();
	}
	else {
		int32_t current_heap = esp_get_free_heap_size();
		ESP_LOGI("NE::HEAP", "Section %s used %dkB heap (we're down to %dkB)", tag, 
			(free_heap - current_heap)/1024, current_heap / 1024);
		free_heap = current_heap;
	}
}

wuffcorder_status_t state = DISCONNECTED;

Audio::TX audio;
Audio::RX microphone;

#define RX_ENCODED_FRAME_SIZE (((24000/8) * CONFIG_XASAUDIO_RX_FRAMELENGTH) / 1000)
// OpusEncoder * mic_encoder = nullptr;

int mic_skip_count = 0;

MQTT::Handler mqtt;

NeoController::NeoController leds(PIN_NEOPIXEL, RMT_CHANNEL_0, 5);
std::array<NeoController::IndicatorBulb, 4> button_bulbs;

// Audio::TXStream mqtt_stream(audio);

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
void init_dial_pwm() {
	ledc_timer_config_t pwm_config = {};

	pwm_config.speed_mode = LEDC_LOW_SPEED_MODE;
	pwm_config.duty_resolution = LEDC_TIMER_12_BIT;
	pwm_config.timer_num = LEDC_TIMER_0;
	pwm_config.freq_hz = 160;

	ledc_timer_config(&pwm_config);

	ledc_channel_config_t dial_pwm_cfg = {};
	dial_pwm_cfg.gpio_num = PIN_DIAL;
	dial_pwm_cfg.speed_mode = LEDC_LOW_SPEED_MODE;
	dial_pwm_cfg.timer_sel = LEDC_TIMER_0;
	dial_pwm_cfg.channel = LEDC_CHANNEL_0;
	dial_pwm_cfg.intr_type = LEDC_INTR_DISABLE;

	ledc_channel_config(&dial_pwm_cfg);
}

uint8_t get_buttons() {
	return (1-gpio_get_level(PIN_BTN_STOP)) | ((1-gpio_get_level(PIN_BTN_PLAY))<<1) | ((1-gpio_get_level(PIN_BTN_REC))<<2);
}
void set_dial(float amplitude) {
	if(amplitude < 0)
		ledc_set_duty(LEDC_LOW_SPEED_MODE, LEDC_CHANNEL_0, 0);
	else if(amplitude < 1)
		ledc_set_duty(LEDC_LOW_SPEED_MODE, LEDC_CHANNEL_0, 1000 * amplitude);
	else
		ledc_set_duty(LEDC_LOW_SPEED_MODE, LEDC_CHANNEL_0, 1000);

	ledc_update_duty(LEDC_LOW_SPEED_MODE, LEDC_CHANNEL_0);
}

void core_processing_task(void *args) {
	while(true) {
		while((!audio.largestack_process()) && (!microphone.has_new_audio()))
			xTaskNotifyWait(0, 0, nullptr, portMAX_DELAY);

		// audio.largestack_process();

		if(microphone.has_new_audio()) {
			auto data = microphone.get_buffer();
			// if(mic_skip_count == 0) {
			// 	std::array<uint8_t, RX_ENCODED_FRAME_SIZE + 1> mic_buffer = {};

			// 	//size_t pub_length = opus_encode(mic_encoder, data.data(), data.size(), mic_buffer.data(), mic_buffer.size());
			// 	//mqtt.publish_to(std::string("Wuffcorder/") + unit_nametag + "/Audio/Out", mic_buffer.data(), pub_length, 0, false);
			// 	// ESP_LOGV("Audio", "Pubbing %d bytes, that is %d samples", pub_length, data.size());
			// }
			// else
			// 	mic_skip_count--;
		}
	}
}

using namespace NeoController;
typedef const bulb_config_t bulb_template_t;

bulb_template_t BULBS_DISABLED = {bulb_mode_t::HFLASH, Color(Material::RED, 140), 4};

bulb_template_t BULB_PLAY_IDLE = {bulb_mode_t::IDLE, 0x444444, 4};
bulb_template_t BULB_PLAY_WAITING = {bulb_mode_t::HFLASH, Material::GREEN, 6};
bulb_template_t BULB_PLAY_PLAYING = {bulb_mode_t::FLASH, Material::GREEN, 16};
bulb_template_t BULB_PLAY_PAUSED  = {bulb_mode_t::FLASH, Material::GREEN, 12};

bulb_template_t BULB_STOP_IDLE = Bulb::OFF;
bulb_template_t BULB_STOP_PLAYING = {bulb_mode_t::IDLE, Material::RED, 4};

bulb_template_t BULB_REC_IDLE 	= {bulb_mode_t::IDLE, Material::RED, 4};
bulb_template_t BULB_REC_PLAYING = Bulb::OFF;
bulb_template_t BULB_REC_RECORDING = {bulb_mode_t::FLASH, Material::RED, 16};
bulb_template_t BULB_REC_PAUSED  = {bulb_mode_t::FLASH, Material::RED, 12};

void gun_button_fx_tick() {
	button_bulbs[0].set(Material::GREEN, NeoController::IDLE);

	button_bulbs[2] = wpn_handler.can_shoot() ? BULB_PLAY_PLAYING : BULB_STOP_PLAYING;
	button_bulbs[1] = BULB_PLAY_PLAYING;
	button_bulbs[3] = wpn_handler.weapon_equipped() ? BULB_PLAY_PLAYING : BULB_PLAY_WAITING;
}

void button_fx_tick() {
	gun_button_fx_tick();
	return;

	if(mqtt.is_disconnected()) {
		if(state == RECORDING)
			microphone.stop();
		state = DISCONNECTED;
	}

	// Set up the MQTT Status indicator based on connectivity
	if(mqtt.is_disconnected() == 255)
		button_bulbs[0].set(Material::PURPLE, NeoController::IDLE);
	else if(mqtt.is_disconnected() == 2)
		button_bulbs[0].set(Material::RED, NeoController::FLASH);
	else if(state == DISCONNECTED)
		button_bulbs[0].set(Material::AMBER, NeoController::FLASH);
	else
		button_bulbs[0].set(Material::GREEN, NeoController::IDLE);

	// Set up the rest of the buttons based on the current
	// state machine's state.
	switch(state) {
		default:
			button_bulbs[1] = button_bulbs[2] = button_bulbs[3] = BULBS_DISABLED;
			break;

		case IDLE:
		case IDLE_PENDING:
			button_bulbs[1] = state == IDLE ? BULB_PLAY_IDLE : BULB_PLAY_WAITING;
			button_bulbs[2] = BULB_STOP_IDLE;
			button_bulbs[3] = BULB_REC_IDLE;
			break;

		case PLAYING:
			// button_bulbs[1] = mqtt_stream.has_audio() ? BULB_PLAY_PLAYING : BULB_PLAY_PAUSED;
			button_bulbs[2] = BULB_STOP_PLAYING;
			button_bulbs[3] = BULB_REC_PLAYING;
			break;

		case RECORDING:
		case REC_PAUSED:
			button_bulbs[1] = BULB_PLAY_PLAYING;
			button_bulbs[2] = BULB_STOP_PLAYING;
			button_bulbs[3] = state == RECORDING ? BULB_REC_RECORDING : BULB_REC_PAUSED;
		break;
	}
}

void effects_task(void *args) {
	uint8_t old_buttons = 0;

	TickType_t last_btn_change = xTaskGetTickCount();

	while(true) {
		vTaskDelay(25 / portTICK_PERIOD_MS);

		if(get_buttons() != old_buttons) {
			TickType_t btn_press_time = xTaskGetTickCount() - last_btn_change;
			last_btn_change = xTaskGetTickCount();

			auto new_buttons = get_buttons();

			char bfr[5];
			itoa(new_buttons, bfr, 2);
			ESP_LOGD("BTNS", "New buttons are: %s", bfr);

			mic_skip_count = 10;

			//Xasin::Trek::play(Xasin::Trek::KEYPRESS);

			const char * btn_type = "UNDEF";

			if((old_buttons == 0b10) && (btn_press_time >= 2000/portTICK_PERIOD_MS))
				btn_type = "LONGREC";
			else if(old_buttons == 0b1)
				btn_type = "PLAY";
			else if(old_buttons == 0b100)
				btn_type = "STOP";
			else if(old_buttons == 0b10)
				btn_type = "REC";

			mqtt.publish_to(std::string("Wuffcorder/") + unit_nametag + "/BTN", btn_type, strlen(btn_type));
		}
		old_buttons = get_buttons();

		button_fx_tick();

		// if(state == PLAYING)
		// 	set_dial(1 + audio.get_volume_estimate()/40.0);
		// else if(state == RECORDING)
		// 	set_dial(1 + microphone.get_volume_estimate()/40.0);
		// else
		// 	set_dial(0);

		for(int i=0; i<button_bulbs.size(); i++)
			leds[i+1] = button_bulbs[i].tick();

		bool is_active = true; //state == PLAYING || state == RECORDING || state == REC_PAUSED;
		leds[0].merge_overlay(NeoController::Color(Material::ORANGE, is_active ? 200 : 10), 10);

		leds.update();
	}
}

void init_networking() {
	std::string baseMqttTopic("Wuffcorder/");
	baseMqttTopic += unit_nametag;

	if(!Xasin::MQTT::Handler::start_wifi_from_nvs()) {
	}
	if(!mqtt.start_from_nvs(baseMqttTopic + "/HWStatus")) {
	}

	ESP_LOGI("Core", "Base MQTT Topic is %s", baseMqttTopic.data());

	mqtt.subscribe_to(baseMqttTopic + "/Audio/In", [](MQTT::MQTT_Packet data) {
		if(data.data.length() <= 1)
			return;

		const uint8_t *data_ptr = reinterpret_cast<const uint8_t *>(data.data.data());
		uint8_t num_packets  = *data_ptr;
		if(num_packets == 0)
			return;

		size_t packet_length = (data.data.length() - 1) / num_packets;
		if(packet_length == 0)
			return;

		// mqtt_stream.feed_packets(data_ptr + 1, packet_length, num_packets);
	}, 0);

	mqtt.subscribe_to(baseMqttTopic + "/State", [](MQTT::MQTT_Packet data) {
		ESP_LOGI("Core", "Moving to state %s", data.data.data());

		wuffcorder_status_t next_state = DISCONNECTED;
		if(data.data == "IDLE")
			next_state = IDLE;
		else if(data.data == "IDLE_PENDING")
			next_state = IDLE_PENDING;
		else if(data.data == "PLAYING")
			next_state = PLAYING;
		else if(data.data == "RECORDING")
			next_state = RECORDING;
		else if(data.data == "REC_PAUSED")
			next_state = REC_PAUSED;

		if(next_state == state)
			return;

		if(next_state == RECORDING)
			microphone.start();
		if(state == RECORDING)
			microphone.stop();

		state = next_state;
	}, 1);
}

void init() {
	ph("INIT");

	get_nametag();

	init_gpio();
	init_dial_pwm();

	ph("GPIOS");

	xTaskCreate(effects_task, "GFX", 3*1024, nullptr, 10, nullptr);

	ph("FX TASK");

	TaskHandle_t processing_task;
	xTaskCreate(core_processing_task, "LARGE", 32768, nullptr, 4, &processing_task);

	ph("PROCESSING TASK");

    i2s_pin_config_t pin_config = {
    	PIN_AUDIO_TX_BCK,
		PIN_AUDIO_TX_LRCK,
		PIN_AUDIO_TX_DATA,
		I2S_PIN_NO_CHANGE
    };

	audio.init(processing_task, pin_config);
	audio.calculate_volume = true;
	//audio.volume_mod = 50;

	ph("AUDIO TX INIT");

	//mic_encoder = opus_encoder_create(16000, 1, OPUS_APPLICATION_VOIP, nullptr);
	//opus_encoder_ctl(mic_encoder, OPUS_SET_BITRATE(16000));
	//opus_encoder_ctl(mic_encoder, OPUS_SET_COMPLEXITY(1));
	//opus_encoder_ctl(mic_encoder, OPUS_SET_SIGNAL(OPUS_SIGNAL_VOICE));

	ph("RX ENCODER");

	i2s_pin_config_t mic_pin_config = {
			PIN_AUDIO_RX_BCK,
			PIN_AUDIO_RX_LRCK,
			I2S_PIN_NO_CHANGE,
			PIN_AUDIO_RX_DATA,
	};
	microphone.init(processing_task, mic_pin_config);
	microphone.gain = 380;

	ph("RX MIC INIT");

	for(auto &b : button_bulbs)
		b = NeoController::Bulb::OK;

	init_networking();
	mqtt.set_status("READY");

	// mqtt_stream.start(false);

	ph("NETWORKING");

	vTaskDelay(10);

	Xasin::Trek::init(audio);
	Xasin::Trek::play(Xasin::Trek::PROG_DONE);

	ph("INIT DONE");
}

}
