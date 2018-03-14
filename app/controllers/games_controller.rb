class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :new_game_new_player_check, only: [:create]
  before_action :set_player, only: [:create, :update]

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
    @players_array = Player.all.collect{ |player| [player.name, player.id] }
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new_game
    if @player.nil?
      @player = Player.new(name: params[:name])
      @player.save
      @game.player = @player
    else
      @game.player = @player
    end
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    if @game.process_input(params[:commit])
      return_notice = "Your guess was incorrect..."
    else
      return_notice = "Your guess was correct!"
    end

    if @game.word == @game.current_guess
      return_notice += " You won!"
    end

    if @game.guesses_left <= 0
      return_notice += " You ran out of guesses."
    end

    # here we want to run checks, and pass it:
    # - to the end if word guessed or guessed exhausted
    # - back to show otherwise.

    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: return_notice  }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
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

    def new_game_new_player_check
      if params[:player_id] == "" && params[:game][:new_player] == "false"
        redirect_back fallback_location: new_game_url, notice: "Please select an existing player"
      elsif params[:name] == "" && params[:game][:new_player]
        redirect_back fallback_location: new_game_url, notice: "Please enter a name"
      end
    end

    def set_player
      unless params[:player_id].nil?
        @player = Player.find(params[:player_id])
      end
    end



    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:id, :player_id, :name)
    end
end
