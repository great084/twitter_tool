module OmniauthMocks
  def twitter_mock_uid_234567
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
                                                                   'provider' => 'twitter',
                                                                   'uid' => '234567',
                                                                   'info' => {
                                                                     'nickname' => 'mockmock',
                                                                     'name' => 'Mock User',
                                                                     'image' => 'http://mock_image_url.com',
                                                                     'location' => '',
                                                                     'email' => 'mock@example.com',
                                                                     'urls' => {
                                                                       'Twitter' => 'https://twitter.com/MockUser1234',
                                                                       'Website' => ''
                                                                     }
                                                                   },
                                                                   'credentials' => {
                                                                     'token' => 'mock_credentails_token',
                                                                     'secret' => 'mock_credentails_secret'
                                                                   },
                                                                   'extra' => {
                                                                     'raw_info' => {
                                                                       'name' => 'Mock User',
                                                                       'id' => '123456',
                                                                       'followers_count' => 0,
                                                                       'friends_count' => 0,
                                                                       'statuses_count' => 0
                                                                     }
                                                                   }
                                                                 })
  end

  def twitter_mock_uid_123456
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
                                                                   'provider' => 'twitter',
                                                                   'uid' => '123456',
                                                                   'info' => {
                                                                     'nickname' => 'mockmock',
                                                                     'name' => 'Mock User',
                                                                     'image' => 'http://mock_image_url.com',
                                                                     'location' => '',
                                                                     'email' => 'mock@example.com',
                                                                     'urls' => {
                                                                       'Twitter' => 'https://twitter.com/MockUser1234',
                                                                       'Website' => ''
                                                                     }
                                                                   },
                                                                   'credentials' => {
                                                                     'token' => 'mock_credentails_token',
                                                                     'secret' => 'mock_credentails_secret'
                                                                   },
                                                                   'extra' => {
                                                                     'raw_info' => {
                                                                       'name' => 'Mock User',
                                                                       'id' => '123456',
                                                                       'followers_count' => 0,
                                                                       'friends_count' => 0,
                                                                       'statuses_count' => 0
                                                                     }
                                                                   }
                                                                 })
  end

  # 異常なデータ(uidが欠落)
  def twitter_invalid_mock
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
                                                                   'provider' => 'twitter',
                                                                   # "uid" => "123456",
                                                                   'info' => {
                                                                     'name' => 'Mock User',
                                                                     'image' => 'http://mock_image_url.com',
                                                                     'location' => '',
                                                                     'email' => 'mock@example.com',
                                                                     'urls' => {
                                                                       'Twitter' => 'https://twitter.com/MockUser1234',
                                                                       'Website' => ''
                                                                     }
                                                                   },
                                                                   'credentials' => {
                                                                     'token' => 'mock_credentails_token',
                                                                     'secret' => 'mock_credentails_secret'
                                                                   },
                                                                   'extra' => {
                                                                     'raw_info' => {
                                                                       'name' => 'Mock User',
                                                                       'id' => '123456',
                                                                       'followers_count' => 0,
                                                                       'friends_count' => 0,
                                                                       'statuses_count' => 0
                                                                     }
                                                                   }
                                                                 })
  end

  def twitter_cancel_mock
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
  end
end
