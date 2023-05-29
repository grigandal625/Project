class Student < ActiveRecord::Base
  belongs_to :group
  has_many :results
  has_many :semanticnetworks
  has_many :studentframes
  has_many :recomendations

  has_one :user, dependent: :destroy
  has_and_belongs_to_many :passed_personality_tests, class_name: 'PersonalityTest'
  has_and_belongs_to_many :personalities

  def check_narrowness_breadth_equivalence_range
    self.equivalence_range_score = 0
    self.equivalence_range_score += 1 if self.free_sort_objects_dedicated_groups_count&.between?(15, 35)
    self.equivalence_range_score += 1 if self.free_sort_objects_largest_group_objects_count&.between?(10, 35)
    self.equivalence_range_score += 1 if self.free_sort_objects_single_object_group_count&.between?(0, 15)
    save
  end

  def check_field_independence_dependency
    self.field_independence_dependency_score = 0
    self.field_independence_dependency_score += 1 if self.included_figures_score&.between?(0.0, 2.5)
    save
  end

  def check_impulsivity_reflexivity
    self.impulsivity_reflexivity_score = 0
    self.impulsivity_reflexivity_score += 1 if self.compare_similar_drawings_score&.between?(7, 12)
    self.impulsivity_reflexivity_score += 1 if self.compare_similar_drawings_time&.between?(8, 16)
    save
  end

  def find_cognitive_styles
    return {} if self.impulsivity_reflexivity_score.blank? || self.field_independence_dependency_score.blank? || self.equivalence_range_score.blank?

    equivalence = if equivalence_range_score == 0
                    :narrowness
                  elsif equivalence_range_score == 3
                    :breadth
                  end

    field = if field_independence_dependency_score == 0
              :independence
            else
              :dependence
            end

    impulsivity_reflexivity = if impulsivity_reflexivity_score == 0
                                :impulsivity
                              elsif impulsivity_reflexivity_score == 2
                                :reflexivity
                              end
    result = {
      field: field,
      equivalence: equivalence,
      impulsivity_reflexivity: impulsivity_reflexivity
    }
    nil_keys = result.select { |_, value| value.blank? }.keys
    existing_keys = result.reject { |_, value| value.blank? }.keys
    return result if nil_keys.blank?

    if result.select { |_, value| value.blank? }.keys.include?(:equivalence)
      if field == :independence || impulsivity_reflexivity == :reflexivity
        equivalence = :narrowness
      else
        equivalence = :breadth
      end
      result[:equivalence] = equivalence
    end

    if result.select { |_, value| value.blank? }.keys.include?(:impulsivity_reflexivity)
      if field == :independence || equivalence == :narrowness
        impulsivity_reflexivity = :reflexivity
      else
        impulsivity_reflexivity = :impulsivity
      end
      result[:impulsivity_reflexivity] = impulsivity_reflexivity
    end
    result
  end
end
