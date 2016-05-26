class EntitiesService

  attr_accessor :errors

  def initialize(entity_class)
    @errors = []
    @entity_class = entity_class
  end

  def add_entity(entity_name, questions)
    ActiveRecord::Base.transaction do
      new_entity = Entity.create(name: entity_name, klass: @entity_class)

      question_ids = questions.map do |question|
        Answer.create(question_id: question[:id],
                      answer: question[:answer],
                      entity_id: new_entity.id)
        question[:id]
      end

      all_question_ids = Question.where(entity_class: @entity_class).pluck(:id)
      (all_question_ids - question_ids).each do |question_id|
        Answer.create(question_id: question_id,
                      answer: 3,
                      entity_id: new_entity.id)
      end

      true
    end
  end

end
