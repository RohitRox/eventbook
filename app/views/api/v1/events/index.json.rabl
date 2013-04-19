object false
# attributes false

node(:events) { |m| @events.map(&:address) }