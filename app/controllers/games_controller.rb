require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def game
    @start_time = Time.now
    @grid = generate_grid(9).join(" ")
  end

  def score
    @start_time = params[:start_time].to_time
    @end_time = Time.now
    @attempt = params[:query]
    @grid = params[:grid]
    @result = run_game(@attempt, @grid, @start_time, @end_time)
  end


  # def time_to_answer
  #   @time_taken = @end_time - @start-time
  # end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = Array.new(grid_size) { [*("A".."Z")].sample }
    return grid
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result

    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    p attempt_feedback = open(url).read
    p result_english_check = JSON.parse(attempt_feedback)

    p time_taken = end_time - start_time

    english_word_characters = result_english_check["word"].upcase.scan /\w/

    sum = 0

    english_word_characters.each { |letter|
      if english_word_characters.count(letter) > grid.count(letter)
        sum += 1
      else
        sum
      end
    }

    if result_english_check["found"] == true
      p score_english = result_english_check["word"].length
      message1 = "Well Done!"
    else
      p score_english = 0
      message1 = "Not an English word!"
    end

    if sum.zero?
      # result_english_check["word"].index{ |x| !grid.include?(x) }.nil?
      p score_grid = 1
      message2 = "Well Done!"
      # result_english_check["word"].index{ |x| !grid.include?(x) }.nil?
    else
      p score_grid = 0
      message2 = "Not in the Grid!"
    end

    total_score = score_english * score_grid / time_taken

    message = "#{message1} #{message2}"

    result = { attempt: result_english_check["word"], time: time_taken, score: total_score, message: message }
  end

end
