class FuzzyMatcherService

  THRESHOLD = 0.3

  attr_reader :entity_class

  def initialize(entity_class)
    @entity_class = entity_class

    @fuzzy_matcher = FuzzyMatch.new(Entity.where(klass: @entity_class), read: :name)
  end

  # Use Dice's Coefficient algorithm to find approximate match (https://www.wikiwand.com/en/Dice's_coefficient)
  def find_match(approximate_name)
    entity, score = @fuzzy_matcher.find_with_score(approximate_name)

    return score >= THRESHOLD ? entity.name : nil
  end
end
