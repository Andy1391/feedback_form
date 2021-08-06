require 'spec_helper'

RSpec.describe ApplicationController, :type => :controller do
  include Rack::Test::Methods

  def app
    ApplicationController.new
  end
  
  context 'GET form page' do
    it 'return status 200' do     
      get '/form'
      expect(last_response.status).to eq(200)
    end

    it 'return status 404' do
      get '/form_new'
      expect(last_response.status).to eq(404)
    end
  end

  context 'POST form' do
    it 'raise error message' do
      post '/form', :name => 'Ok'   
       expect(last_response.status).to eq(400)
       expect(last_response.body).to include('Parameter cannot have length less than 3')
    end
  
    it 'send form' do
      allow_any_instance_of(ApplicationController).to receive(:verify_recaptcha).and_return(true)
      allow(Pony).to receive(:deliver)
      post '/form', 'image' => Rack::Test::UploadedFile.new('spec/files/me.jpg', 'image/jpeg'),
        name: 'Peter', email: 'peter_pen@mail.com',
        message: 'Let’s assume we have a class called Product with...'       
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('Form submitted successfully!')    
    end
  end
end

