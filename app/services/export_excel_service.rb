class ExportExcelService

  attr_accessor :errors, :questions, :filename

  def initialize(klass, entity_class, filename = "#{Rails.root}/public/export.xlsx")
    @klass = klass
    @errors = []
    @filename = filename
    @workbook = WriteXLSX.new(filename)
    @worksheet = @workbook.add_worksheet
    @entity_class = entity_class
  end

  def write
    row = 1
    @klass.where(klass: @entity_class).each do |entity|
      col = 0
      @worksheet.write(row, col, entity.name)

      col = 1
      entity.answers.order(question_id: :asc).each do |answer|
#        @worksheet.write(row, col, Answer.answers[answer.answer])
        @worksheet.write(row, col, answer.answer)
        col += 1
      end

      row += 1
    end

    row = 0
    col = 1
    Question.where(entity_class: @entity_class).order(id: :asc).each do |question|
     @worksheet.write(row, col, question.title)
     col += 1
    end

    @workbook.close
  end

end
