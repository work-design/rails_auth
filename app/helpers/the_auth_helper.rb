module TheAuthHelper

  def search_form_for(record = :q, options = {}, &block)
    options[:css] ||= {
      wrapper_all: 'inline field',
      wrapper_input: 'field',
      wrapper_submit: 'field',
      submit: 'ui green button'
    }

    super
  end

end