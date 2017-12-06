# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  content = '<span class="fields-with-error">'.html_safe
  content += html_tag
  content += '<div class= "invalid-feedback">'.html_safe
  content += instance.error_message&.collect { |e| e.capitalize }.join(', ')
  content += '</div></span>'.html_safe
  content
end
