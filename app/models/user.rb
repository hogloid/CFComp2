class User
    include ActiveModel::Model

    attr_accessor :id
    validates :id, presence: true
end
