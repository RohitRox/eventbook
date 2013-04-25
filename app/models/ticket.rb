class Ticket
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :booking
  belongs_to :user

end