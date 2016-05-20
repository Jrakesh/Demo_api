describe "Album API" do
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

  it "returns all the album" do
     get "/api/v1/albums",{'token' => @token}
     expect(response).to have_http_status(200)
  end

  it "show album details" do
    album = FactoryGirl.create(:album)
    get "/api/v1/albums/#{album.id}", {'token' => @token}
    expect(response).to have_http_status(200)
  end

  it "should be delete" do
    @user.add_role :admin
    album = FactoryGirl.create(:album)
    delete "/api/v1/albums/#{album.id}", {'token' => @token}
    expect(response).to have_http_status(200)
  end
end
