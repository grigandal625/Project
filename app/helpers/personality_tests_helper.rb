module PersonalityTestsHelper
  def link_to_add partial, where, link_text, css_class = nil
    content_tag(:a, link_text, class: 'link-to-add-html '+ css_class,
                data: { html: render( partial: partial).gsub('"', "'") }.merge(where))
  end

  def sidebar(sidebar_replace)
    if sidebar_replace.empty?
      render partial: 'personality_tests/sidebar'
    else
      sidebar_replace
    end
  end
end
