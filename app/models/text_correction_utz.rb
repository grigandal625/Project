class TextCorrectionUtz < ActiveRecord::Base
  belongs_to :ka_topic

  def self.label
    return "маркировка или корректировка текста"
  end
end
