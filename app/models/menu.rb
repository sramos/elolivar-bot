class Menu < ApplicationRecord
  enum menu_type: [:puree, :solid]

  validates_presence_of :date
  validates_presence_of :menu_type
  validates_uniqueness_of :menu_type, scope: :date
  validates_presence_of :description

  rails_admin do
    list do
      field :date
      field :menu_type
    end
    show do
      field :date
      field :menu_type
      field :description
    end
    edit do
      field :date
      field :menu_type
      field :description
    end
  end

  # Wrappers for simple_calendar
  def start_time
    self.date
  end
  def end_time
    self.date
  end
end
