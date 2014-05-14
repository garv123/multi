module ApplicationHelper
  def client
    @client ||= OAuth2::Client.new(
      '079203b42b97938ff6a62fe42e3facae',
      'cdee13bf303205d7ca60895d88c72ce0b14df0178bd78702169593a80793975a',
      site: 'https://www.cobot.me',
      authorize_path: '/oauth2/authorize',
      access_token_path: '/oauth2/access_token',
      raise_errors: false
    )
  end

  def api
    @api ||= OAuth2::AccessToken.new(client, access_token)
    @api
  end

  def access_token(access_token=nil)
    session[:token]
  end

  def user(cobot_user=nil)
    @user ||= api.get('https://www.cobot.me/api/user')
  end

end
