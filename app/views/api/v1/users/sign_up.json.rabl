object @user
attributes :_id, :errors, :authentication_token
child :profile do
  attributes :profile_pic_url
end