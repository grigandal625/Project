class Log < ActiveRecord::Base
  belongs_to :component, polymorphic: true
end
