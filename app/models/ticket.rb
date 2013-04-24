class Ticket
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  belongs_to :booking
  belongs_to :user

end