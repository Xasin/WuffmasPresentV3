
#include "freertos/FreeRTOS.h"
#include "esp_wifi.h"
#include "esp_system.h"
#include "esp_event.h"
#include "nvs_flash.h"
#include "driver/gpio.h"

#include "core.h"

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

    Core::init();

    while (true) {
        vTaskDelay(300 / portTICK_PERIOD_MS);
    }
}

