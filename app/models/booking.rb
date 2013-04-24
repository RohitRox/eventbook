class Booking
  include Mongoid::Document
  include Mongoid::Timestamps
  include Stateflow

  belongs_to :user
  belongs_to :event
  has_many :tickets
  field :status, type: String

  BOOKED = 'booked'
  CANCELLED = 'cancelled'
  ATTENDED = 'attended'
  EXPIRED = 'expired'

  scope :booked, where(:status => BOOKED)
  scope :cancelled, where(:status => CANCELLED)
  scope :attended, where(:status => ATTENDED)
  scope :expired, where(:status => EXPIRED)

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