class Guest < Hobo::Guest

  def administrator?
    false
  end
  
  def judge?
    false
  end

end
