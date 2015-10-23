module YtzHelper
  def text_with_editable_links(text, intervals)
    new_text = text
    intervals.each do |interval|
      link = link_to text[interval.start, interval.end], '#', class: 'editable', data: {
          name: 'interval',
          type: 'select',
          source: interval.answers.map {|t| {value: t.id, text: t.text}},
      }

      length = interval.end - interval.start

      new_text[interval.start, length] = link
    end
    new_text.html_safe
  end
end