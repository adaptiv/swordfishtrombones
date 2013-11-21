class Round < ActiveRecord::Base
  def player_count
    (1..4).each do |i|
      return i-1 if send("player#{i}".to_sym).blank?
    end

    4
  end
end
