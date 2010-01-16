class FaqController < ApplicationController
  #action :create, :model => Question, :success_response => Proc.new { |format|
    #debugger
    #true
  #}

  access_control do
    allow :admin
    allow all, :to => [:index, :ask]
  end

  def index
    @items = Question.answered_questions
  end

  def unanswered
    @items = Question.unanswered_questions
  end

  def ask
    @question = Question.new(params[:question])

    if @question.save
      flash[:notice] = "Ваше питання додано"
      redirect_to '/'
    else
      @items = Question.answered_questions
      render :action => 'index'
    end
  end

  def answer
    @question = Question.find(params[:id])
    not_found unless @question

    if request.post?
      @answer = @question.build_answer(params[:answer])

      if @answer.save
        flash[:notice] = "Ваша відповідь додана"
        redirect_to '/'
      end
    else
      @answer = Answer.new
    end
  end

  def destroy
    @item = Question.find(params[:id])
    @item.destroy
    flash[:notice] = "Успішно видалено питання"
    redirect_to '/unanswered'
  end
end
