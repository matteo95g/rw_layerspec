# frozen_string_literal: true
module ParamsHandler
  extend ActiveSupport::Concern

  included do
    def layer_params_sanitizer
      params.require(:layer).merge(logged_user: params[:logged_user], user_id: params.dig(:logged_user, :id), dataset: params[:dataset_id])
                            .permit!
                            .reject{ |_, v| v.nil? }
    end
  end

  class_methods {}
end
