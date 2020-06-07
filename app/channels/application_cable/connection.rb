module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    identified_by :room_id

    def connect
      self.current_user = find_verified_user
      self.room_id = session['room_id']
    end

    protected

    def find_verified_user
      if (verified_user = User.find(session['user_id']))
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def session
      cookies.encrypted[Rails.application.config.session_options[:key]]
    end
  end
end
