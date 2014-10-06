class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    auth_hash = request.env["omniauth.auth"]
    uid = auth_hash['uid']
    name = auth_hash['info']['name']

    auth = Authorization.find_by(provider: 'twitter', uid: uid)

    # User already known with this provider. Return user with this authorization
    if auth
      user = auth.user
    else
      if current_user # User already signed in
        user = current_user
      else
        user = User.find_by(name: name)
        if user.blank?
          user = User.create({
            name: name,
            password: Devise.friendly_token[0,8],
            email: "#{UUIDTools::UUID.random_create}@ycommerce.in"
            })
        end
      end
      # Create authorization for user
      auth = user.authorizations.find_by(provider: 'twitter')
      if auth.blank?
        auth = user.authorizations.build(provider: 'twitter', uid: uid)
        user.authorizations << auth
      end
      auth.update_attributes({
        uid: uid,
        token: auth_hash['credentials']['token'],
        secret: auth_hash['credentials']['secret'],
        name: name,
        url: "http://twitter.com/#{name}"
        })
    end   
   if user
      sign_in_and_redirect user, :event => :authentication
    else
      redirect_to :new_user_registration
    end 
  end
end
