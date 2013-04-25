class Api::V1::BookingsController < Api::V1::BaseController
  respond_to :json
  def admit
    booking = @user.bookings.find(params[:id])
    if booking
      if booking.attended?
        @r_hash = OpenStruct.new({ message: 'Sorry ! This booking is already admitted.', booked: false})
      else
        booking.attend!
        @r_hash = OpenStruct.new({ message: 'Successfully admitted.', booked: true, qty: booking.tickets.size})
      end
    else
      @r_hash = OpenStruct.new({message: "Sorry! This booking couldn't be found in the system.", booked: false})
    end
  end
end