class SResult < ActiveRecord::Base
  belongs_to :result
  has_one :log, as: :component, autosave: true
end
