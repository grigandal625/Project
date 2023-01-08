class LikertUtzMatch < ApplicationRecord
  belongs_to :likert_utz_task
  belongs_to :likert_utz_variant
end
