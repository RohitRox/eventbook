class Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :address, type: String
  field :cell_no, type: String
  field :profile_pic

  mount_uploader :profile_pic, ProfilePicUploader

  attr_accessible :address, :cell_no, :profile_pic

end