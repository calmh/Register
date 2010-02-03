module StudentsHelper
  def format_zipcode(zipcode)
    return nil if zipcode.blank?
    zipcode.sub!(" ", "")
    if zipcode =~ /^(\d\d\d)(\d\d)$/
      return $1 + " " + $2
    else
      return zipcode
    end
  end
end
