APP_ROOT = File.expand_path( File.dirname(__FILE__)) + '/..'
[ APP_ROOT, "#{APP_ROOT}/lib", "#{APP_ROOT}/app/models" ].each { |dir| $LOAD_PATH.unshift dir }

require 'rubygems'
require 'mongo_mapper'
require 'carrierwave'
require 'carrierwave/orm/mongomapper'
require 'active_support'
