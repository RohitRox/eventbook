class Event
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :category, type: String
  field :seats, type: Integer
  field :entrance, type: String
  field :date, type: Date
  field :time, type: String

  attr_accessible :picture, :title, :description, :category, :seats, :entrance, :date, :time
  mount_uploader :picture, PictureUploader

  belongs_to :organiser, class_name: 'User'
  has_many :bookings
end
