class Size < ApplicationRecord
  has_many :products
  belongs_to :sizetype
end
