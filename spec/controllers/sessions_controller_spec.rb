require 'spec_helper'

describe SessionsController do

  before(:each) do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:cobot]
    @auth = request.env["omniauth.auth"]
  end

  describe "create" do
    it "creates a session with the authentication token" do
      get :create
      session[:token].should == @auth['credentials']['token']
    end

    it "creates a session with the list of admin-authorized subdomains" do
      get :create
      session[:admin_of].should == ["my-subdomain", "test2"]
    end

    it "redirects to the spaces page" do
      get :create
      response.should redirect_to spaces_path
    end
  end

  describe "failure" do
    it "deletes the session[:token]" do
      session[:token] = @auth['credentials']['token']
      get :failure
      session[:token].should be_nil
    end

    it "deletes the session[:admin_of]" do
      session[:admin_of] = ["my-subdomain", "test2"]
      get :failure
      session[:admin_of].should be_nil
    end

    it "redirects to the root path" do
      get :failure
      response.should redirect_to root_path
    end
  end

  describe "destroy" do
    it "deletes the session[:token]" do
      session[:token] = @auth['credentials']['token']
      get :destroy
      session[:token].should be_nil
    end

    it "deletes the session[:admin_of]" do
      session[:admin_of] = ["my-subdomain", "test2"]
      get :destroy
      session[:admin_of].should be_nil
    end

    it "redirects to the root path" do
      get :destroy
      response.should redirect_to root_path
    end
  end

end
