require 'net/http'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a[rand(26)] }.join
  end

  def score
    @letters = params[:letters]
    @guessed_word = params[:word]
    @right_guess = right_guess?(@letters, params[:word])
    url = "https://wagon-dictionary.herokuapp.com/#{@guessed_word.downcase}"
    result_serialized = URI.open(url).read
    @result = JSON.parse(result_serialized)
    if !@right_guess
      @response = 'Word does not match the given letters'
    elsif !@result['found']
      @response = 'Word is not a valid English word'
    else
      @respnse = 'Word is valid!'
    end
  end

  private

  def right_guess?(letters, guessed_word)
    right_guess = true
    guessed_word.upcase!
    guessed_word.split('').each do |letter|
      unless guessed_word.count(letter) <= letters.count(letter)
        right_guess = false
        break
      end
    end
    return right_guess
  end
end
