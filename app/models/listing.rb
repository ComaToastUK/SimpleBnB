class Listing

  include DataMapper::Resource

  property :id,          Serial
  property :title,       String
  property :location,    String
  property :price,       Integer
  property :imageurl,    Text
  property :created_at,  Date
  property :description, Text

  belongs_to :user

end
