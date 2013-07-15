require 'bundler/setup'
require 'sinatra'
require 'awesome_print'
require 'json'
require 'data_mapper'
require 'dm-adjust'

class Slug
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String,  :required => true
  property :unique_hits,  Integer, :default  => 0
  property :total_hits,   Integer, :default  => 0
end

DataMapper.setup(:default, 'postgres://localhost/beacon')
DataMapper.finalize.auto_upgrade!

get '/:slug.gif' do
  slug = Slug.first_or_create(name: params[:slug])
  if !request.env['HTTP_IF_MODIFIED_SINCE']
    slug.adjust!(unique_hits: 1)
  end
  slug.adjust!(total_hits: 1)

  last_modified Time.now
  etag          Time.now.to_i

  send_file 'spacer.gif'
end

get '/:slug.json' do
  slug = Slug.first_or_create(name: params[:slug])

  { name:   slug.name,
    unique: slug.unique_hits,
    total:  slug.total_hits
  }.to_json
end