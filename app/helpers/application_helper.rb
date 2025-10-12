module ApplicationHelper
  def word_pluralize(count, singular)
    count == 1 ? singular : singular.pluralize
  end
end
