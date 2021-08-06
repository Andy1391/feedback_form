class ApplicationController < Sinatra::Base  
  register Sinatra::Flash
  helpers Sinatra::Param

  configure do
    enable :sessions
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  include Recaptcha::Adapters::ViewMethods
  include Recaptcha::Adapters::ControllerMethods

  Recaptcha.configure do |config|
    config.site_key = ENV['RECAPTCHA_SITE_KEY']
    config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
  end

  get '/' do
    haml :index
  end

  get '/form' do    
    haml :'form/index', format: :html5, layout: :'layouts/form_layout'
  end

  post '/form' do
    valid_params
    if verify_recaptcha
      if params[:image] && params[:image][:filename]
        filename = params[:image][:filename]
        file = params[:image][:tempfile]
        path = "./public/uploads/#{filename}"

        File.open(path, 'w+') do |cur_file|
          cur_file.write(file.read)
        end

        Pony.mail({
                    to: :'andy1391test@gmail.com',
                    body: 'test',
                    html_body: "name: #{params[:name]}, email: #{params[:email]}, message: #{params[:message]}",
                    attachments: { File.basename(filename).force_encoding('UTF-8') => File.read(path) },
                    via: :smtp,
                    via_options: {
                      address:
                        'smtp.gmail.com',
                      port:
                        '587',
                      user_name:
                        ENV['EMAIL_USER_NAME'],
                      password:
                        ENV['EMAIL_PASSWORD'],
                      authentication:
                       :plain,
                      domain:
                        'gmail.com'
                    }
                  })
        flash[:notice] = 'Form submitted successfully!'
      else
        flash[:notice] = 'Please, add file'
        redirect '/form'
      end
    else
      flash[:notice] = 'Check recaptcha'
      redirect '/form'
    end
  end

  private

  def valid_params
    email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    param :name, String, min_length: 3, max_length: 250
    param :email, String, blank: false, format: email_regex, message: "It's not email format"
    param :message, String, min_length: 50
  end
end
