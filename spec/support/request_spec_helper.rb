module RequestSpecHelper
  include Warden::Test::Helpers

  def json
    JSON.parse(response.body)
  end

  def api_authentication(user)
    post('/auth/sign_in', params: {email: user.email, password: user.password})
    {
      "access-token": response.headers["access-token"],
      "token-type": "Bearer",
      "client": response.headers["client"],
      "expiry": response.headers["expiry"],
      "uid": response.headers["uid"]
    }
  end

end
