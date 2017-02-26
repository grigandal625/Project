class Timetable < ActiveRecord::Base
  belongs_to :group
  has_many :events, dependent: :destroy

  def to_json
    json = []
    events.each do |event|
      json << JSON[event.to_json]
    end
    return json.to_json
  end

end
