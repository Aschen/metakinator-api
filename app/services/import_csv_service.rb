require 'csv'

class ImportCsvService

  def initialize(entity_class, csv_file)
    @csv_file = csv_file
    @entity_class = entity_class.capitalize
  end

  def import_csv
    ActiveRecord::Base.transaction do
      @csv_content = ::CSV.parse(File.open(@csv_file, "r").read)

      import_questions(@csv_content[0])

      @csv_content[1..-1].each do |entity_row|
        import_entity(entity_row)
      end
    end
  end

  private # ====================================================================

  def import_entity(entity_row)
    entity_name = entity_row[-1]
    entity = Entity.create(name: entity_name, klass: @entity_class)

    questions = Question.where(entity_class: @entity_class).order(id: :asc)

    entity_row[0..(entity_row.count - 2)].each_with_index do |answer, i|
      answer = answer.size == 1 ? answer.to_i : answer # convert "5" to 5
      Answer.create(question_id: questions[i].id, entity_id: entity.id, answer: answer)
    end
  end

  def import_questions(questions_row)
    question_index = @csv_content[0].count - 2

    questions_row[0..question_index].each do |question|
      Question.create(title: question, nominal: question.parameterize.underscore, entity_class: @entity_class)
    end
  end
end
