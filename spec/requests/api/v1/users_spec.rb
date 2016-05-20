describe "Users API" do
  before do 
    @user = FactoryGirl.create(:user)
    user_login
  end
  def user_login
    params={email: @user.email,password: @user.password}
    post '/api/v1/session',params
    @token = response.header["token"]
    expect(response).to have_http_status(200)
  end

  it "returns all the users" do
     get "/api/v1/users",{'token' => @token}
     expect(response).to have_http_status(200)
  end

  it "show user details" do
    get "/api/v1/users/#{@user.id}", {'token' => @token}
    expect(response).to have_http_status(200)
  end

  it "should be update" do
    params = {
      name: "test changes",
      email: "test@changemail.com"
    }

    put "/api/v1/users/#{@user.id}", params, {'token' => @token}
    expect(response).to have_http_status(200)
  end

  it "should be delete" do
    put "/api/v1/users/#{@user.id}", {'token' => @token}
    expect(response).to have_http_status(200)
  end
end
