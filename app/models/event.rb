class Event
  include Mongoid::Document
  include Mongoid::Timestamps

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
  field :long, type: BigDecimal
  field :latt, type: BigDecimal


  attr_accessible :picture, :title, :description, :category, :seats, :entrance, :date, :time, :address, :locality, :country, :venue, :long, :latt
  mount_uploader :picture, PictureUploader

  belongs_to :organiser, class_name: 'User'
  has_many :bookings
end
