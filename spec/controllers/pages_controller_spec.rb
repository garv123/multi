require 'spec_helper'

describe PagesController do

  before(:each) do
    @id = "my-subdomain"
  end

  context "when not logged in" do
    describe "GET index" do
      it "is successful" do
        get :index
        response.should be_success
      end
    end

    describe "GET spaces" do
      it "redirects to the signin page" do
        get :spaces
        response.should redirect_to root_path
      end
    end

    describe "GET show" do
      it "redirects to the signin page" do
        get :show, id: @id
        response.should redirect_to root_path
      end
    end

    describe "POST charge" do
      it "redirects to the signin page" do
        post :charge, id: @id
      end
    end
  end

  context "when logged in" do
    before(:each) do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:cobot]
      @auth = request.env["omniauth.auth"]
      session[:token] = @auth['credentials']['token']
      session[:admin_of] = ["my-subdomain", "test2"]
      stub_request(:get, "https://www.cobot.me/api/user").to_return(status: 200,
        body: {"admin_of" => [{"space_subdomain" => "co-up"}]}.to_json)
    end

    describe "GET index" do
      it "redirects to the spaces page" do
        get :index
        response.should redirect_to spaces_path
      end
    end

    describe "GET spaces" do
      it "is successful" do
        get :spaces
        response.should be_success
      end
    end

    describe "GET show" do
      context "without correct permissions" do
        it "redirects to the spaces page" do
          get :show, id: "not_my-subdomain"
          response.should redirect_to spaces_path
        end
      end

      context "with correct permissions" do
        it "is successful" do
          stub_request(:get, "https://my-subdomain.cobot.me/api/memberships").to_return(:status => 200, :body => "[{\"id\": \"0c4f75fa14924423810d6f12aeb56fbb\", \"address\": {\"company\": \"ACME corp\", \"name\": \"johnny doe\", \"address\": \"broadway\", \"post_code\": \"10999\", \"city\": \"Berlin\", \"state\": \"BE\", \"country\": \"Germany\"}}, {\"id\": \"0c4f75fa14924423810d6f12aeb56ffa\", \"address\": {\"company\": \"\", \"name\": \"jane smith\", \"address\": \"somewhere\", \"post_code\": \"10999\", \"city\": \"Berlin\", \"state\": \"BE\", \"country\": \"Germany\"}}]", :headers => {})
          get :show, id: @id
          response.should be_success
        end
      end
    end

    describe "POST charge" do
      context "without correct permissions" do
        it "redirects to the spaces page" do
          post :charge, id: "not_my-subdomain", membership: "1", amount: "20", description: "test"
          response.should redirect_to spaces_path
        end
      end

      context "with correct permissions" do
        before(:each) do
          @membership = "1"
          @amount = "20"
          @description = "test"
          @charges = stub_request(:post, "https://#{@id}.cobot.me/api/memberships/#{@membership}/charges?amount=#{@amount}&description=#{@description}").to_return(:status => 201, :body => "abc", :headers => {:status => 201})
        end

        it "posts charges to the selected member via the cobot API" do
          post :charge, id: @id, membership: @membership, amount: @amount, description: @description
          a_request(:post, "https://#{@id}.cobot.me/api/memberships/#{@membership}/charges?amount=#{@amount}&description=#{@description}").should have_been_made
        end

        it "redirects to the show page" do
          post :charge, id: @id, membership: @membership, amount: @amount, description: @description
          response.should redirect_to space_path("my-subdomain")
        end
      end
    end
  end

end
