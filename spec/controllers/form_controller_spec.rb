require 'spec_helper'
# require "./app/controllers/form_controller.rb"


RSpec.describe FormController, type: :controller do  

  it "displays home page" do 
   get '/'
  end
end