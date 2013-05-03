
class Integer
  def as_bytes
    return "1 Byte" if self == 1
    
    label = ["Bytes", "KiB", "MiB", "GiB", "TiB"]
    i = 0
    num = self.to_f
    while num >= 1024 do
      num = num / 1024
      i += 1
    end
    
    "#{format('%.2f', num)} #{label[i]}"
  end
end
