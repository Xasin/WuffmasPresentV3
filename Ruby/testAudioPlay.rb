


require_relative 'Wuffcorder.rb'

require_relative 'CassetteSource.rb'

require 'mqtt/sub_handler.rb'

$mqtt = MQTT::SubHandler.new('mqtt://JUNNpEz4Z33vMbGZbB5l6cujsQebJaVjVxU81h2QaWcKXGAW8t72ts9L6cKGauNV@mqtt.flespi.io');

$wuff = Wuff::WuffCorder.new($mqtt, "84.CC.A8.0A.33.98");


cassette = Xasin::OpusStream::CassetteSource.new();
$wuff.audio_stream << cassette;

$wuff.state = :IDLE_PENDING;

source = Xasin::OpusStream::FileSource.new('ob-la-di.mp3')
source.volume = 0.1
source.pause

$mqtt.subscribe_to "Wuffcorder/84.CC.A8.0A.33.98/BTN" do
	if source.state == :paused
		$wuff.state = :PLAYING
		source.resume
	elsif source.state == :playing
		source.pause
	end
end

source.on_finish do
	$wuff.state = :IDLE;
end

cassette << source

Thread.stop()
