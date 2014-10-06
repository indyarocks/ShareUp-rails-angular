class Users::UsersController < Devise::SessionsController
  respond_to :json

  def is_user
    reject_if_not_authorized_user!
    render status: 200,
      json: {
        success: !Users.find_by(name: params[:name]).present?
      }
  end

  def reject_if_not_authorized_user!
    warden.authenticate!(
      scope: resource_name,
      recall: "#{controller_path}#failure"
      )
  end

end