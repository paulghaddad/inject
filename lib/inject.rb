# Return true if all elements are equal to the argument, false otherwise.
def all_equal?(argument, elements)
  # TODO: rewrite to use inject instead of recursion
  #case elements
  #when []
    #true
  #else
    #first, *rest = elements
    #first == argument && all_equal?(argument, rest)
  #end

  # This also works, but is more verbose
  #elements.inject(true) do |result, n|
    #result && n == argument
  #end

  elements.inject(:&) == argument
end

# Return the number of elements that are equal to the argument.
def count_equal(argument, elements)
  # TODO: rewrite to use inject instead of select and size
  #equal = elements.select do |element|
    #element == argument
  #end

  #equal.size

  elements.inject(0) do |elements_equal, n|
    if argument == n
      elements_equal += 1
    else
      elements_equal
    end
  end
end

# Find keys in a nested hash using an array key.
#
# Example:
#   nested_key([:outer, :inner], { outer: { inner: 'value' } })
#   # => 'value'
def nested_key(keys, hash)
  keys.inject(hash) do |new_hash, key|
    return nil unless new_hash[key]
    new_hash[key]
  end
end

class Category < ActiveRecord::Base
  belongs_to :parent, class_name: 'Category'
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'

  # Find categories where the body matches a space-separated list of words.
  #
  # For example, the query "hey there" should match any category with a body
  # containing both "hey" and "there."
  #def self.search(query)
    # TODO: rewrite to use inject instead of each and mutation
    #relation = self
    #query.split(' ').each do |keyword|
      #relation = relation.where('body LIKE ?', "%#{keyword}%")
    #end
    #relation

  def self.search(query)
    query.split(' ').inject(self.all) do |entries, search_term|
      entries.where('body LIKE ?', "%#{search_term}%")
    end
  end

  # Find categories using a slash-separated list of names.
  #
  # For example, the path "Parent/Child" will find a category named "Child"
  # within a parent category named "Parent."
  def self.find_by_path(path)
    path.split('/').inject(self.all) do |categories, path_part|
      path_match = categories.try(:find_by, name: path_part)
      return nil unless path_match

      if path_match.children.empty?
        categories.first
      else
        path_match.children
      end
    end
  end

  private

  def self.children
    all
  end
end
