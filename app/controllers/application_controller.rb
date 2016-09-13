class ApplicationController < ActionController::API
  rescue_from Mongoid::Errors::DocumentNotFound, with: :record_not_found

  rescue_from Exception do |e|
    error(e)
  end

  protected

    def record_not_found
      render json: { errors: [{ status: '404', title: 'Record not found' }] } ,  status: 404
    end

    def error(e)
      if request.env["ORIGINAL_FULLPATH"] =~ /^\//
        error_info = { error: "internal-server-error", exception: "#{e.class.name} : #{e.message}" }
        error_info[:trace] = e.backtrace[0,10] if Rails.env.development?
        render json: error_info.to_json, status: 500
      else
        raise e
      end
    end
end
