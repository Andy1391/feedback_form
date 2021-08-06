require_relative './config/environment'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/param'
require 'sinatra/reloader' if development?
require 'recaptcha'
require 'pony'
require 'haml'
require 'yaml'

run ApplicationController
# use FormController
