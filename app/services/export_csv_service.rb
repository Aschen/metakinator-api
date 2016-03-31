require "csv"

class ExportCsvService

  attr_accessor :errors, :questions, :filename, :mime_type, :data

  def initialize(filename = "export.csv")
    @errors = []
    @filename = filename
    @mime_type = "text/csv"

    @data = generate_csv
  end

  # exterieur collectif sport
  #    yes       no     tirAlarc
  def generate_csv
    ::CSV.generate do |csv|
      # Write headers
      questions_nominal = Question.all.order(id: :asc).map { |q| q.nominal }
      csv.add_row(questions_nominal)

      # Write rows
      Sport.all.each do |sport|
        row = sport.answers.order(question_id: :asc).map do |answer|
          answer.answer
        end
        row << sport.name.parameterize
        csv << row
      end
    end
  end

end
