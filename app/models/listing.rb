class Listing < ActiveRecord::Base
  	belongs_to :neighborhood
  	belongs_to :host, :class_name => "User"
  	has_many :reservations
  	has_many :reviews, :through => :reservations
  	has_many :guests, :class_name => "User", :through => :reservations
  
  	validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

    # callbacks: trigger logic before or after alteration on the object
    
    # user attached to that CREATED listing should be converted into a "host".
  	after_create :user_host_status
  	after_destroy :user_host_status
    #listing is destroyed-the user should be converted back to a regular user


  	
  	def average_review_rating
  		self.reviews.average(:rating)
  	end

    def is_reserved?(day)
      self.reservations.each do |res|
        if day.between?(res.checkin, res.checkout)
          return true
        end
      end
      
      return false
      # look at all of this listing's reservations
      #  iterate over those
        #  if the day is between checkin and checkout?
        #  return true
      # if we look thru all the reservations and exit the loop
      #  return false
    end


  	private

    
  	def user_host_status
  		if self.host.listings.empty?
  			self.host.update(host: false)
  		else
  			self.host.update(host: true)
  		end
  	end


end
