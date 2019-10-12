class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.pluck(:rating).uniq.sort
    end

    def self.with_rating(ratings)
        Movie.where("lower(rating) in (?)", ratings.map{ |rating| rating.downcase})
    end
end
