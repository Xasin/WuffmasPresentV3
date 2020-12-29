
require_relative 'OpusStream.rb'
require_relative 'CassetteSource.rb'

module Wuff
	class WuffCorder
		attr_reader :state
		attr_reader :hw_state
		attr_reader :audio_stream

		def initialize(mqtt, tag)
			@mqtt = mqtt;
			@name = tag;

			@state = :IDLE;

			@pending_files = [];
			@current_play_file = nil;
			@recording_filename = nil;

			@audio_stream = Xasin::OpusStream::Output.new do |data|
				pub "Audio/In", data, qos: 0 unless data.nil?
			end
			@audio_cassette = Xasin::OpusStream::CassetteSource.new
			@audio_stream << @audio_cassette

			@mqtt.subscribe_to "Wuffcorder/#{tag}/HWStatus" do |data|
				@hw_state = data;

				pub "State", @state
			end

			@mqtt.subscribe_to "Wuffcorder/#{tag}/Audio/Out" do |data|
				next if @sox_io.nil?

				if((Time.now() - @sox_io_start) > 3600)
					close_rec_file()
					next;
				end
				# Skip a little to prevent the start buttong press from making a
				# crunch sound
				next if((Time.now() - @sox_io_start) < 0.5)

				@sox_io.write(data);
			end

			@mqtt.subscribe_to "Wuffcorder/#{tag}/BTN" do |btn|
				handle_button btn;
			end
		end

		def handle_button(btn)
			case @state
			when :IDLE
				start_recording if btn == "REC"
			when :IDLE_PENDING
				start_recording if btn == "REC"
				play_next_file  if btn == "PLAY"
			when :PLAYING
				@current_play_file&.toggle_pause if btn == "PLAY"
				@current_play_file&.stop if btn == "STOP"
			when :RECORDING
				stop_recording if btn == "REC"
				self.state = :REC_PAUSED if btn == "PLAY"
				stop_recording true if btn == "STOP"
			when :REC_PAUSED
				stop_recording if btn == "REC"
				self.state = :RECORDING if btn == "PLAY"
				stop_recording true if btn == "STOP"
			end
		end

		def <<(filename)
			@pending_files << filename unless @pending_files.include? filename
			self.state = :IDLE_PENDING if(@state == :IDLE)
		end

		def stop_recording(discard_rec = false)
			return if @sox_io.nil?

			@sox_io.close()
			@sox_io_start = nil;
			@sox_io = nil;

			self.state = @pending_files.empty? ? :IDLE : :IDLE_PENDING

			if discard_rec
				File.delete(@recording_filename)
			else
				self << @recording_filename
			end

			@recording_filename = nil;
		end

		def start_recording(file = nil)
			file ||= "/tmp/WuffRecord-#{@name}-#{Time.now().strftime("%Y-%m-%d_%H-%M-%S")}.ogg"

			@recording_filename = file;

			stop_recording

			@sox_io_start = Time.now();
			@sox_io = IO.popen(['sox', '-c1', '-b16', '-r24000', '-traw', '-esigned', '-',
				'-togg', file,
				'noisered', 'NoiseProfile.prof', '0.21'], 'w', :external_encoding => 'ASCII-8BIT');
			@sox_io.binmode

			self.state = :RECORDING
		end

		def play_next_file
			return if @pending_files.empty?
			next_fname = @pending_files.shift

			@current_play_file&.stop


			@current_play_file = Xasin::OpusStream::FileSource.new(next_fname);
			@current_play_file.on_finish do
				self.state = @pending_files.empty? ? :IDLE : :IDLE_PENDING
				@current_play_file = nil;
				File.delete(next_fname)
			end

			@audio_cassette << @current_play_file
			self.state = :PLAYING
		end

		def pub(topic, data, **opts)
			@mqtt.publish_to "Wuffcorder/#{@name}/" + topic, data, **opts
		end

		def state=(new_state)
			return if @state == new_state

			allowed_states = [:IDLE, :IDLE_PENDING, :PLAYING, :RECORDING, :REC_PAUSED];
			raise ArgumentError unless allowed_states.include? new_state

			@state = new_state;
			pub "State", new_state.to_s, qos: 2;
		end
	end
end
