class Notice < ApplicationRecord

  rails_admin do
    list do
      field :message
      field :sent
    end
    show do
      field :message
      field :sent
    end
    edit do
      field :message
    end
  end
end
