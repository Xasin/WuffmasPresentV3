

require_relative 'FileSource'


module Xasin
	module OpusStream
		class CassetteSource < AudioSource
			def initialize(start_sound: 'cassette_start.wav',
								stop_sound: 'cassette_end.wav',
								hiss_sound: 'cassette_hiss.wav')

				@source_start = FileSource.new(start_sound);
				@source_end   = FileSource.new(stop_sound);
				@source_hiss  = FileSource.new(hiss_sound);

				@source_hiss.repeat = true

				@source_end.stop
				@source_start.stop

				@sound_list = [];
				@sound_list_mutex = Mutex.new

				@state = :idle
			end

			def get_audio(samp_no = 48000 * 0.02)
				# ALWAYS ensure the stop-sound finishes playing
				return @source_end.get_audio(samp_no) * 0.6  if @source_end.has_audio?
				if @source_start.has_audio?
					return 	@source_start.get_audio(samp_no) * 0.6 +
								@source_hiss.get_audio(samp_no) * 0.1
				end

				return nil if @sound_list.empty?

				next_sound = @sound_list[0]

				if (@state == :idle) && next_sound.has_audio?
					@source_start.restart
					@state = :playing

					return @source_start.get_audio(samp_no)
				elsif (@state == :playing) && !next_sound.has_audio?
					@source_end.restart
					@state = :idle

					return @source_end.get_audio(samp_no);
				else
					out_data = next_sound.get_audio(samp_no)
					@sound_list.drop(0) if(@sound_list[0].is_done?)

					@source_end.restart if @sound_list.empty?

					out_data += @source_hiss.get_audio(samp_no) * 0.1 unless out_data.nil?

					return out_data
				end
			end

			def is_done?
				false
			end

			def <<(filename)
				@sound_list_mutex.synchronize do
					@sound_list << filename;
				end
			end
		end
	end
end
