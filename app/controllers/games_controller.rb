require 'open-uri'

$total_score = 0

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def add_to_total
    $total_score += params[:longest].length
  end

  def score
    @real_word = in_dictionary?(params[:longest])
    @input = params[:longest].split('')
    @letter_group = params[:letters].split('').reject(&:blank?)
    if (@input - @letter_group).empty? && @real_word
      @response = "Congratulations! '#{params[:longest].capitalize}' is an English word!"
      add_to_total
    elsif (@input - @letter_group).empty? && !@real_word
      @response = "Sorry, but '#{params[:longest]}' doesn't seem to be a valid English word..."
    else @response = "Sorry, but '#{params[:longest]}' can't be built out of #{params[:letters].upcase}"
    end
  end
end

# def dictionary
#   @result = API::Domain.check("https://wagon-dictionary.herokuapp.com/dog")
#   @words = JSON.parse(url.read)
# end

private

def in_dictionary?(word_string)
  response = URI.open("https://wagon-dictionary.herokuapp.com/#{word_string}")
  json = JSON.parse(response.read)
  json['found']
end
