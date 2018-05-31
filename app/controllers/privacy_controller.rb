# frozen_string_literal:true

class PrivacyController < ThylacineController
  skip_authorization_check

  def index; end
end
