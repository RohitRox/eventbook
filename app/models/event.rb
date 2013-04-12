class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  geocoded_by :address

  field :title, type: String
  field :description, type: String
  field :category, type: String
  field :seats, type: Integer
  field :entrance, type: String
  field :date, type: Date
  field :time, type: String

  field :address, type: String
  field :locality, type: String
  field :country, type: String
  field :venue, type: String

  field :coordinates, :type => Array

  reverse_geocoded_by :coordinates

  attr_accessible :picture, :title, :description, :category, :seats, :entrance, :date, :time, :address, :locality, :country, :venue, :coordinates
  mount_uploader :picture, PictureUploader

  belongs_to :organiser, class_name: 'User'
  has_many :bookings
end
