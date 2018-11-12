require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
    @start_time = Time.now
  end

  def in_grid?(attempt, grid)
    grid_hash = Hash.new(0)
    grid.each { |letter| grid_hash[letter] += 1 }
    attempt.upcase.chars.each { |letter| grid_hash[letter] -= 1 }
    grid_hash.values.all? { |v| v >= 0 }
  end

  def score
    @letters = params[:letters].split(',')
    @word = params[:word]
    time = Time.now - Time.parse(params[:time])
    result = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@word}").read)
    @message = { word: @word, time: time, score: 0, message: "not in grid" }
    if result["found"] && in_grid?(@word, @letters)
      @message[:message] = "well done"
      @message[:score] = @word.length * 10 - time.to_i / 30
    elsif result["found"] == false
      @message[:message] = "not word"
    end
  end
end
