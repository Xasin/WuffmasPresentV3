/*
 * core.h
 *
 *  Created on: 1 Dec 2020
 *      Author: xasin
 */

#ifndef MAIN_CORE_H_
#define MAIN_CORE_H_

#include <xasin/audio.h>
#include <xasin/mqtt.h>
#include <xasin/neocontroller.h>

#include <array>

namespace Core {

enum wuffcorder_status_t {
	DISCONNECTED,
	IDLE,
	IDLE_PENDING,
	PLAYING,
	RECORDING,
	REC_PAUSED
};

extern wuffcorder_status_t state;

extern Xasin::Audio::TX 		audio;
extern Xasin::Audio::RX			microphone;

extern Xasin::MQTT::Handler		mqtt;
extern Xasin::NeoController::NeoController leds;

extern std::array<Xasin::NeoController::IndicatorBulb, 4> button_bulbs;

void ph(const char *tag = "");

void set_dial(float level);
uint8_t get_buttons();

void init();

}


#endif /* MAIN_CORE_H_ */
