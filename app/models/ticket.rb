class Ticket
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  belongs_to :booking
  belongs_to :user

  field :status, type: String

  BOOKED = 'booked'
  CANCELLED = 'cancelled'
  ATTENDED = 'attended'
  EXPIRED = 'expired'

  stateflow do

    state_column :status

    initial :booked

    state :booked, :cancelled, :admitted, :expired

    event :cancel do
      transitions :from => :booked, :to => :cancelled
    end

    event :attend do
      transitions :from => :booked, :to => :attended
    end

    event :expire do
      transitions :from => :booked, :to => :expired
    end

  end


end