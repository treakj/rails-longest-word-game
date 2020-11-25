require 'open-uri'

class GamesController < ApplicationController
  def new
    @grid = 9.times.map { ('A'..'Z').to_a.sample }
    @start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) * 1000
  end

  def score
    file = open("https://wagon-dictionary.herokuapp.com/#{params[:tryword].downcase}").read
    hash = JSON.parse(file)
    time = (params[:end_time].to_i - params[:start_time].to_i)
    grid_string = params[:grid].downcase
    response = params[:tryword].downcase.chars.all? { |w| grid_string.sub!(w, '') if grid_string.chars.include?(w) }
    if !response
      @message = 'Not in the grid'
      @score = 0
    elsif hash.key?('error')
      @message = 'Not an english word'
      @score = 0
    else
      @message = 'Conglatulations!'
      @score = [params[:tryword].length * 20 - time * 10, 10].max
    end
  end

  private

  def current_user
    @_current_user ||= session[:current_user_id] &&
                       User.find_by(id: session[:current_user_id])
  end
end
# def run_game(attempt, grid, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
#   hash = hash_read("https://wagon-dictionary.herokuapp.com/#{attempt}")
#   result = {}
#   result[:time] = (end_time - start_time).to_i
#   time = result[:time]
#   grid_string = grid.join.downcase
#   response = attempt.downcase.chars.all? { |w| grid_string.sub!(w, '') if grid_string.chars.include?(w) }
#   hash.key?("error") || !response ? result[:score] = 0 : result[:score] = (attempt.length * 15 - time * 10).to_i
#   result[:message] = msg(hash.key?("error"), response)
#   return result
#   <input id="grid" name="grid" type="hidden" value=<%=@grid.join()%>>
#   <input id="start_time" name="start_time" type="hidden" value=<%=@start_time%>>
#   <input id="end_time" name="end_time" type="hidden" value=<%=Time.now%>>
# # end
