# frozen_string_literal: true

module SightingHelper
  def taxonomy_input_group(form, attribute)
    model = Object.const_get attribute.to_s.camelize

    content_tag :div, class: 'form-group col' do
      content = (form.label attribute) +
                (form.text_field attribute, class: 'form-control') +
                (form.text_field :"#{attribute}_id", class: 'form-control d-none')
      if cannot? :create, model
        content += content_tag :div, class: 'alert alert-warning d-none small' do
          locale = I18n.locale
          I18n.t :taxonomy_manage_auth_fail, model: model.model_name.human.pluralize(locale.to_sym)
        end
      end
      content
    end
  end
end
