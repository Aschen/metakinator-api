class EntitiesController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :set_entity_class, only: [:index, :new, :export_csv, :export_excel, :export_arff]

  # GET /entities
  # GET /entities.json
  def index
    if @entity_class
      @entities = Entity.where(klass: @entity_class)
    else
      @entities = Entity.all
    end
  end

  # GET /entities/1
  # GET /entities/1.json
  def show
  end

  # GET /entities/new
  def new
    @entity = Entity.new(klass: @entity_class)
    @questions = Question.all
  end

  # GET /entities/1/edit
  def edit
    @questions = Question.all
  end

  # POST /entities
  # POST /entities.json
  def create
    @entity = Entity.new(entity_params)

    respond_to do |format|
      if @entity.save
        format.html { redirect_to @entity, notice: 'Entity was successfully created.' }
        format.json { render :show, status: :created, location: @entity }
      else
        format.html { render :new }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entities/1
  # PATCH/PUT /entities/1.json
  def update
    @entity.answers.destroy_all # uglyyy
    params[:entity][:questions].each do |question, answer|
      @entity.add_answer(question, answer)
    end

    respond_to do |format|
      if @entity.update(entity_params)
        format.html { redirect_to @entity, notice: 'Entity was successfully updated.' }
        format.json { render :show, status: :ok, location: @entity }
      else
        format.html { render :edit }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.json
  def destroy
    @entity.destroy
    respond_to do |format|
      format.html { redirect_to entities_url, notice: 'Entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export_excel
    service = ExportExcelService.new(Entity, @entity_class)
    service.write
    send_file service.filename, filename: "export.xlsx"
  end

  def export_csv
    service = ExportCsvService.new(Entity, @entity_class)
    send_data service.data, filename: "export.csv", type: service.mime_type
  end

  def export_arff
    service = ExportArffService.new(Entity, @entity_class)
    send_data service.data, filename: service.filename, type: service.mime_type
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.find(params[:id])
    end

    def set_entity_class
      @entity_class = params[:entity_class]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_params
      params.require(:entity).permit(:name)
    end
end
