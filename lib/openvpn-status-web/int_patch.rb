
class Integer
  def as_bytes
    return '1 Byte' if self == 1

    label = %w[Bytes KiB MiB GiB TiB]
    i = 0
    num = to_f
    while num >= 1024
      num /= 1024
      i += 1
    end

    "#{format('%.2f', num)} #{label[i]}"
  end
end
