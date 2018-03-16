class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :postgame]
  before_action :set_player, only: [:create, :update, :postgame]
  before_action :run_end_turn_checker, only: [:show]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
    @player = Player.new
    @players_array = Player.all.collect{ |player| [player.name, player.id] }
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @players_array = Player.all.collect{ |player| [player.name, player.id] }
    @game = Game.new_game
    if @player.nil?
      @player = Player.new(name: params[:name])
      @player.save
      @game.player = @player
    else
      @game.player = @player
    end

    if @game.save
      redirect_to @game, notice: 'Game was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    if @game.input_check(params[:commit])
      return_notice = "Your guess was incorrect..."
    else
      return_notice = "Your guess was correct!"
    end

    if run_end_turn_checker
      @game.save
      return
    elsif @game.update(game_params)
      if @game.save
        redirect_to @game, notice: return_notice
        return
      else
        render :edit
        return
      end
    end
  end

  def postgame

  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
        @game = Game.find(params[:id])
    end

    def set_player
      unless params[:player_id].nil? || params[:player_id] == ""
        @player = Player.find(params[:player_id])
      end
    end

    def run_end_turn_checker
      if @game.end_turn_check == "win"
        flash[:notice] = "you won"
        redirect_to(action: "postgame", id: @game)
        return true
      elsif @game.end_turn_check == "loss"
        flash[:notice] = "you lost"
        redirect_to(action: "postgame", id: @game)
        return true
      else
        return false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:id, :player_id, :name)
    end
end
