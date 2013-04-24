class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :survey

  field :answer, type: Array, default: []
  field :statement
  field :answering, type: String
	MOODS = [:great, :good, :fair, :unsatisfactory]
  
  def answering=(val)
  	self.answer << val
  	self.save!
  end

self.class_eval do
	MOODS.each do |mood|
 		self.send(:define_method,mood) do
  			answer.select{|reply| reply == mood.to_s}.count 	 	
 	 	end
	end
end

  def positive
  	answer.select{|reply| reply == "yes"}.count
  end
  def negative
  	answer.select{|reply| reply == "no"}.count
  end
  def total
  	answer.count
  end
  # accepts_nested_attributes_for :answers
end