



require_relative 'Wuffcorder.rb'

require_relative 'CassetteSource.rb'

require 'mqtt/sub_handler.rb'

$mqtt = MQTT::SubHandler.new('mqtt://192.168.178.230');

$wuffcorders = {
	wuff: 	Wuff::WuffCorder.new($mqtt, "84.CC.A8.0A.33.98"),
	durg:		Wuff::WuffCorder.new($mqtt, "84.CC.A8.0A.34.4C")
}

$wuffcorders[:wuff].default_rec_dir = "/var/wuffcorder/recordings"
$wuffcorders[:durg].default_rec_dir = "/var/wuffcorder/recordings"

$wuffcorders[:wuff].on_record_done { |fname| $wuffcorders[:durg] << fname }
$wuffcorders[:durg].on_record_done { |fname| $wuffcorders[:wuff] << fname }

Thread.stop()
