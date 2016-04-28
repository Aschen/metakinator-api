class ExportArffService

  attr_accessor :errors, :questions, :filename, :mime_type, :data

  def initialize(klass, filename = "export.arff")
    @klass = klass
    @errors = []
    @filename = filename
    @mime_type = "text/text"

    @data ||= generate_arff
  end

  def generate_arff
    arff = Rarff::Relation.new(@klass.name)

    arff.instances = @klass.all.map do |entity|
      entity.answers.order(question_id: :asc).map do |answer|
        answer.answer
      end + [entity.name.parameterize.underscore]
    end

    Question.all.order(id: :asc).each_with_index do |question, i|
      arff.attributes[i].name = question.nominal
    end

    arff.attributes[-1].name = "class"
    arff.attributes[-1].type = "{#{@klass.all.map{ |e| e.name.parameterize.underscore }.join(',')}}"

    arff.to_arff
  end

end
