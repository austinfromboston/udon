ENV["RACK_ENV"] = "test"
require 'rubygems'
require 'sinatra'
require File.expand_path( File.dirname(__FILE__)) + '/../config/env'
require 'spec'
