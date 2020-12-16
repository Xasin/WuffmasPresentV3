/*
 * pins.h
 *
 *  Created on: 1 Dec 2020
 *      Author: xasin
 */

#ifndef MAIN_PINS_H_
#define MAIN_PINS_H_

// #define DEBUG_DSKORDER

#ifdef DEBUG_DSKORDER

#define PIN_AUDIO_TX_DATA GPIO_NUM_12
#define PIN_AUDIO_TX_LRCK GPIO_NUM_13
#define PIN_AUDIO_TX_BCK  GPIO_NUM_14

#define PIN_NEOPIXEL	  GPIO_NUM_23

#define PIN_BTN_REC 	  GPIO_NUM_27
#define PIN_BTN_PLAY      GPIO_NUM_33
#define PIN_BTN_STOP      GPIO_NUM_32

#else

#define PIN_AUDIO_TX_DATA GPIO_NUM_25
#define PIN_AUDIO_TX_LRCK GPIO_NUM_23
#define PIN_AUDIO_TX_BCK  GPIO_NUM_22

#define PIN_NEOPIXEL  GPIO_NUM_15

#define PIN_BTN_REC   GPIO_NUM_4
#define PIN_BTN_PLAY  GPIO_NUM_2
#define PIN_BTN_STOP  GPIO_NUM_5

#define PIN_DIAL	  GPIO_NUM_13
#define LEDC_DIAL_TIMER LEDC_TIMER_0

#endif


#endif /* MAIN_PINS_H_ */
