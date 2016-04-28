class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_entity_class, only: [:index, :first_question, :best_question]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.where(entity_class: @entity_class)
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def first_question
    service = DaneelService.new(@entity_class)
    best = service.get_first_question

    render json: { "best_question" => best.id }
  end

  def best_question
    unless params[:questions_id].present?
      render json: { "errors" => "Missing questions_id param" }, status: 400 and return
    end

    asked_questions = Question.where(id: params[:questions_id])

    service = DaneelService.new(@entity_class)
    best = service.get_best_question(asked_questions)

    if best
      render json: { "best_question" => best.id }
    else
      render json: { "best_question" => -1, "no_more_questions" => true }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    def set_entity_class
      @entity_class = params[:entity_class]
      raise ArgumenError, "Missing entity_class param" unless @entity_class
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :nominal, :entity_class)
    end
end
