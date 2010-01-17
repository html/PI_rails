class Question < ActiveRecord::Base
  has_one :answer

  def self.answered_questions
    find(:all, :include => :answer, :conditions =>  'answers.question_id is NOT NULL')
  end

  def self.unanswered_questions
    find(:all, :include => :answer, :conditions => 'answers.question_id is NULL')
  end

  def self.count_unanswered
    count(:include => :answer, :conditions =>  'answers.question_id is NULL')
  end
end
