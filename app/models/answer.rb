class Answer
	include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :question
  field :degree, type: String
  scope :good, where(degree: 'good')
end
