require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
    @start_time = Time.now
  end

  def existing_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end
  
  def score
    @answer = params[:answer]
    @letters = params[:grid]
    @start_time = Time.parse(params[:start])
    @end_time = Time.now
    @result = { time: @end_time - @start_time }
    if existing_word(@answer)
      if (@answer.chars.map(&:upcase) & @letters.split("")) == @answer.chars.map(&:upcase)
        @result[:score] = @answer.length / (@end_time - @start_time)
        @result[:message] = 'well done'
      else
        @result[:score] = 0
        @result[:message] = 'not in the grid'
      end
    else
      @result[:score] = 0
      @result[:message] = 'not an english word'
    end
    return @result
  end

end
