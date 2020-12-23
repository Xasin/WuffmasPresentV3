
require_relative 'OpusStream.rb'

module Wuff
	class WuffCorder
		attr_reader :hw_state
		attr_reader :audio_stream

		def initialize(mqtt, tag)
			@mqtt = mqtt;
			@name = tag;

			@state = :IDLE;

			@audio_stream = Xasin::OpusStream::Output.new do |data|
				pub "Audio/In", data, qos: 0 unless data.nil?
			end

			@mqtt.subscribe_to "Wuffcorder/#{tag}/HWStatus" do |data|
				@hw_state = data;

				pub "State", @state
			end
		end

		def pub(topic, data, **opts)
			@mqtt.publish_to "Wuffcorder/#{@name}/" + topic, data, **opts
		end

		def state=(new_state)
			allowed_states = [:IDLE, :IDLE_PENDING, :PLAYING];
			raise ArgumentError unless allowed_states.include? new_state

			pub "State", new_state.to_s, qos: 2;
		end
	end
end
