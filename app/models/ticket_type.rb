class TicketType < ApplicationRecord
  belongs_to :event
  has_many :tickets
end
