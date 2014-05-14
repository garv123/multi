require 'spec_helper'

describe CobotController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'invoices'" do
    it "returns http success" do
      get 'invoices'
      response.should be_success
    end
  end

end
