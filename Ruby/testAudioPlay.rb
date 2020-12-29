


require_relative 'Wuffcorder.rb'

require_relative 'CassetteSource.rb'

require 'mqtt/sub_handler.rb'

#$mqtt = MQTT::SubHandler.new('mqtt://JUNNpEz4Z33vMbGZbB5l6cujsQebJaVjVxU81h2QaWcKXGAW8t72ts9L6cKGauNV@mqtt.flespi.io');
$mqtt = MQTT::SubHandler.new('mqtt://192.168.178.230');

$wuff = Wuff::WuffCorder.new($mqtt, "84.CC.A8.0A.33.98");


$cassette = Xasin::OpusStream::CassetteSource.new();
$wuff.audio_stream << $cassette;

$wuff.state = :IDLE;

def add_new_source(file = "/tmp/WuffRecord-84.CC.A8.0A.33.98-temp.ogg")
	unless $file_source.nil?
		$file_source.stop()
	end

	$file_source = Xasin::OpusStream::FileSource.new(file);
	$file_source.volume = 0.2;

	$file_source.on_finish do
		$file_source = nil;
		$wuff.state = :IDLE
	end

	$cassette << $file_source;
	$wuff.state = :PLAYING
end

$mqtt.subscribe_to "Wuffcorder/84.CC.A8.0A.33.9/BTN" do |btn|
	case btn
	when "PLAY"
		if($file_source.nil?)
			add_new_source
		elsif $file_source.state == :paused
			$wuff.state = :PLAYING
			$file_source.resume
		elsif $file_source.state == :playing
			$file_source.pause
		end
	when "REC"
		if($wuff.state == :RECORDING)
			$wuff.stop_recording
			$wuff.state = :IDLE_PENDING
		else
			$wuff.start_recording
			$file_source&.pause
		end
	end
end

Thread.stop()
