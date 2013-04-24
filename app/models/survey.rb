class Survey
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :event

  has_many :questions
  accepts_nested_attributes_for :questions

  def moody
    surveys = []
    self.questions.each do |question|
      current_question = {question: question.statement}
      Question::MOODS.each do |mood|
        current_question.merge!({mood.to_s => question.send(mood)})
      end
      surveys << current_question
    end
      surveys
  end
  def result
  # 	great = questions.map(&:answer).select{|reply| reply == "great"}.count
  #  	good = questions.map(&:answer).select{|reply| reply == "good"}.count
  # 	fair = questions.map(&:answer).select{|reply| reply == "fair"}.count
  # 	unsatisfactory = questions.map(&:answer).select{|reply| reply == "unsatisfactory"}.count
 	# [great, good, fair, unsatisfactory].sort.last  
  end

end