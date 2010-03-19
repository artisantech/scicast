module ::Paperclip
  
  module ClassMethods
  
    def has_attached_file_with_hobo(name, *args, &b)
      has_attached_file_without_hobo(name, *args, &b)
    
      fields do |f|
        f.field "#{name}_file_name",    :string
        f.field "#{name}_content_type", :string
        f.field "#{name}_file_size",    :integer
        f.field "#{name}_updated_at",   :datetime
      end
    
      declare_attr_type name, ::Paperclip::Attachment
    end
    alias_method_chain :has_attached_file, :hobo
    
    def attachment_fields(*names)
      names.map { |name| ["#{name}_file_name", 
                          "#{name}_content_type",
                          "#{name}_file_size",
                          "#{name}_updated_at"] }.flatten
    end
  
  end
  
end
