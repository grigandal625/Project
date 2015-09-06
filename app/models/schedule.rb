class Schedule < ActiveRecord::Base
	serialize :data, JSON

	def add_record(week_idx, event)
		week_data = self.data[week_idx.to_s]
		if(week_data == nil)
			week_data = Hash.new
		end

		#puts week_data
		event.each do |k,v|
			if(week_data[k] == nil)
				week_data[k] = Array.new
			end

			week_data[k].push(v)
		end

		self.data[week_idx.to_s] = week_data

		self.save
	end

	def find_recs(week_idx, group_name)
		week_data = self.data[week_idx.to_s]
		if(week_data == nil)
			return []
		end

		if(week_data[group_name] == nil)
			return []
		end

		week_data[group_name]
	end

	def self.current_week
		return 9
	end
end
