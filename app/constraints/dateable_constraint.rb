# frozen_string_literal: true
class DateableConstraint
  def self.matches?(request)
    request.params['dataset'] = request.params['dataset_id']
  end
end
