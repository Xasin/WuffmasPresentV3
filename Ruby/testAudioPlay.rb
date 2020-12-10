


require_relative 'OpusStream.rb'
require_relative 'CassetteSource.rb'

require 'mqtt/sub_handler.rb'

$mqtt = MQTT::SubHandler.new('mqtt://JUNNpEz4Z33vMbGZbB5l6cujsQebJaVjVxU81h2QaWcKXGAW8t72ts9L6cKGauNV@mqtt.flespi.io');


test_opus_manager = Xasin::OpusStream::Output.new do |data|
	$mqtt.publish_to "Wuffcorder/84.CC.A8.0A.33.98/Audio/In", data unless data.nil?
end

cassette = Xasin::OpusStream::CassetteSource.new();
test_opus_manager << cassette;


source = Xasin::OpusStream::FileSource.new('The Beatles - Here Comes The Sun.mp3')
#source.volume = 0.4
source.pause

$mqtt.subscribe_to "Wuffcorder/84.CC.A8.0A.33.98/BTN" do
	if source.state == :paused
		source.resume
	elsif
		source.state == :playing
		source.pause
	end
end

cassette << source

Thread.stop()
