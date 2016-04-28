class SportsController < ApplicationController
  before_action :set_sport, only: [:show, :edit, :update, :destroy]

  # GET /sports
  # GET /sports.json
  def index
    @sports = Sport.all
  end

  # GET /sports/1
  # GET /sports/1.json
  def show
  end

  # GET /sports/new
  def new
    @sport = Sport.new
    @questions = Question.all
  end

  # GET /sports/1/edit
  def edit
    @questions = Question.all
  end

  # POST /sports
  # POST /sports.json
  def create
    @sport = Sport.new(sport_params)

    respond_to do |format|
      if @sport.save
        format.html { redirect_to @sport, notice: 'Sport was successfully created.' }
        format.json { render :show, status: :created, location: @sport }
      else
        format.html { render :new }
        format.json { render json: @sport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sports/1
  # PATCH/PUT /sports/1.json
  def update
    @sport.answers.destroy_all # uglyyy
    params[:sport][:questions].each do |question, answer|
      @sport.add_answer(question, answer)
    end

    if @sport.update(sport_params)
      redirect_to @sport, notice: 'Sport was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sports/1
  # DELETE /sports/1.json
  def destroy
    @sport.destroy
    respond_to do |format|
      format.html { redirect_to sports_url, notice: 'Sport was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export_excel
    service = ExportExcelService.new(Sport)
    service.write
    send_file service.filename, filename: "export.xlsx"
  end

  def export_csv
    service = ExportCsvService.new(Sport)
    send_data service.data, filename: "export.csv", type: service.mime_type
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sport
      @sport = Sport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sport_params
      params.require(:sport).permit(:name)
    end
end
