class Comment < ActiveRecord::Base
  belongs_to :commented, :polymorphic => true
  delegate :name, to: :commented, prefix: :commented, allow_nil: true

  validates_presence_of :comment_date, :commented_type, :commented, :comment

  scope :by_player, ->(player_id = nil) {
    player_id ? where('commented_type = ? and commented_id = ?', 'Player', player_id) : scoped
  }

  def type_label
    commented_type ? "#{commented_type}:" : 'Player/Character:'
  end

  def commented_entities
    commented_type ? eval(commented_type).order(:name) : []
  end
end