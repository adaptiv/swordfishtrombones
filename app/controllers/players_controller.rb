class PlayersController < ApplicationController
  def new
    @round = Round.last || Round.new(round: 0, ocean: 20)

    player_count = @round.player_count
    if player_count >= 4
      render text: 'This game is already full'
      return
    end

    player_id = player_count+1
    @round.send("player#{player_id}=".to_sym, 0)
    @round.save!

    redirect_to player_path(player_id)
  end

  def show
    @player_id = params[:id]
    round
  end

  def round
    @round        = Round.last
    @player_count = @round.player_count

    if @player_count == 4
      @round.ocean = [(@round.ocean*1.25).to_i, 20].min
      @round.save!

      if @round.round < 10 && @round.ocean > 0
        @round        = Round.create(round: @round.round+1, ocean: @round.ocean)
        @player_count = 0
      end
    end
  end

  def fish
    player_id = params[:id]
    @round    = Round.last
    if @round.player_count < 4
      fished = [@round.ocean, params[:fish].to_i].min
      @round.send("player#{player_id}=".to_sym, fished)
      @round.ocean = @round.ocean - fished
      @round.save!
    end

    redirect_to player_path(player_id)
  end

  def data
    rows = Round.all.map do |round|
      puts round.inspect
      {
          c: [
                 { v: round.round.to_s },
                 { v: round.send("player#{params[:id]}".to_sym) },
                 { v: (1..4).map { |i| round.send("player#{i}".to_sym) || 0 }.reduce(:+) },
                 { v: round.ocean }
             ]
      }
    end
    render json: {
        cols: [
                  { label: "Round", type: "string" },
                  { label: "Individual", type: "number" },
                  { label: "Group", type: "number" },
                  { label: "Ocean", type: "number" }
              ],
        rows: rows
    }
  end

end
