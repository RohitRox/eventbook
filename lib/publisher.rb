class Publisher
  USER_ACCESS_TOKEN = "BAACm7B2P8PMBADTsGaEnvPu7wgokZB6nKOw7BMiZAnD3J0szJptu7PlmpnpQUDNYm6bHkruY2g44VIQkedI9MxwrgUNH8QP9ArRV0xXZAKB7BuQp3ZBmJb7jX6PDNhuDAtMEl3jR6IwojU7mNsVkXYltSzqDZAPw4CeKDrbqmIDjzCcOV0TQ7ca1hlfh5KZA4ZD"

  attr_accessor :page, :post, :link, :description

  def initialize(event)
    @page ||= FbGraph::Page.new('eventbooknepal').fetch(
    :access_token => USER_ACCESS_TOKEN,
    :fields => :access_token
    )
    @post = event.title
    @link = "http://23.22.125.64/events/#{event.id}"
    @description = (event.description).slice(0,140)
  end

  def publish
    @page.feed!(
      :message => @post,
      :link => @link,
      :description => @description
    )
  end
end