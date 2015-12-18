class ImagesSortUtz < ActiveRecord::Base
  has_many :images_sort_utz_pictures
  belongs_to :ka_topic

  def pictures
    images_sort_utz_pictures
  end

  def name
    theme
  end
end
