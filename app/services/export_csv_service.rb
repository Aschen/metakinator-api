require "csv"

class ExportCsvService

  attr_accessor :errors, :questions, :filename, :mime_type, :data

  def initialize(klass, entity_class, filename = "export.csv")
    @klass = klass
    @errors = []
    @filename = filename
    @mime_type = "text/csv"
    @entity_class = entity_class

    @data = generate_csv
  end

  # exterieur collectif sport
  #    yes       no     tirAlarc
  def generate_csv
    ::CSV.generate do |csv|
      # Write headers
      questions_nominal = Question.where(entity_class: @entity_class).order(id: :asc).map { |q| q.nominal }
      questions_nominal += ["class"]
      csv.add_row(questions_nominal)

      # Write rows
      @klass.where(klass: @entity_class).each do |entity|
        row = entity.answers.order(question_id: :asc).map do |answer|
          answer.answer
        end
        row += [entity.name.parameterize]
        csv << row
      end
    end
  end

end
