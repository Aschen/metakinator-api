class EntitiesController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy]
  before_action :set_entity_class, except: [:index, :show, :create, :update, :destroy, :edit]

  # GET /entities
  # GET /entities.json
  def index
    @entity_class = params[:entity_class]
    if @entity_class
      @entities = Entity.where(klass: @entity_class)
    else
      @entities_class = Entity.uniq.pluck(:klass)
    end
  end

  # GET /entities/1
  # GET /entities/1.json
  def show
  end

  # GET /entities/new
  def new
    @entity = Entity.new(klass: @entity_class)
    @questions = Question.where(entity_class: @entity_class)
  end

  # GET /entities/1/edit
  def edit
    @questions = Question.where(entity_class: @entity.klass)
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

  def delete_class
    Entity.where(klass: @entity_class).destroy_all
    Question.where(entity_class: @entity_class).delete_all
    flash[:notice] = "Base de connaissance supprimé"
    redirect_to entities_path
  end

  def import_csv
    service = ImportCsvService.new(import_params[:name], import_params[:csv_file].tempfile.path)

    if service.import_csv
      redirect_to entities_path(entity_class: import_params[:name])
    else
      flash[:error] = "Une erreur est survenue lors de l'import"
      render :index
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

  def fuzzy_match
    unless params[:name].present?
      render json: { "errors" => "Missing name param" }, status: 400 and return
    end

    service = FuzzyMatcherService.new(@entity_class)
    best_match = service.find_match(params[:name])

    if best_match
      render json: { "best_match" => best_match, "found" => true }
    else
      render json: { "found" => false }
    end
  end

  def add_entity
    if params[:entity_name].empty? || params[:questions].empty?
      render json: { "errors" => "Missing entity_name or questions param" }, status: 400 and return
    end

    service = EntitiesService.new(@entity_class)

    if service.add_entity(params[:entity_name], params[:questions])
    else
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.find(params[:id])
    end

    def set_entity_class
      unless params[:entity_class].present?
        render json: { "errors" => "Missing entity_class param" }, status: 400 and return
      end

      @entity_class = params[:entity_class]
    end

    def import_params
      params.require(:entity).permit(:name, :csv_file)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_params
      params.require(:entity).permit(:name)
    end
end
