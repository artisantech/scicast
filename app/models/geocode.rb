Geocode = classy_module do
  
  fields do
    lat :float
    lng :float
  end
  
  before_validation :geocode
  
  def geocode
    geocode! if postcode_changed?
  end
  
  def geocode!
   self.lat = self.lng = nil # the location is reset even if the geocoding fails

   unless postcode.blank?
     geo = GeoKit::Geocoders::MultiGeocoder.geocode("#{postcode.strip}, UK")
     if geo.success
       self.lat = geo.lat
       self.lng = geo.lng
     end
   end
  end
  
  attr_protected :lat, :lng

end