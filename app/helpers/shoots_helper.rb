module ShootsHelper

  def tag_shoot_entry(shoot)
    now = Date.current

    klass = ''

    ::Shoot::MetaInfo::All.each do |mi|
      next if (!shoot.is_key_applicable?(mi[:key]))

      exp = Date.strptime(shoot.meta[mi[:key] + "_expected"], Date::DATE_FORMATS[:default])

      if shoot.meta[mi[:key] + "_actual"].to_s.empty? and exp < now
        klass = 'red'
        break
      elsif shoot.meta[mi[:key] + "_actual"].to_s.empty?
        next
      end

      act = Date.strptime(shoot.meta[mi[:key] + "_actual"], Date::DATE_FORMATS[:default])

      if act > exp and exp < now
        klass = 'yellow'
      end

    end

    color_to_tag(klass)
  end

  def tag_shoot_key(shoot, key)
    color = ''
    now = Date.current
    exp = Date.strptime(shoot.meta[key + "_expected"], Date::DATE_FORMATS[:default])

    if (shoot.is_key_applicable?(key)) and (exp < now)

      if shoot.meta[key + "_actual"].to_s.empty? 
        return color_to_tag('red')
      end

      if Date.strptime(shoot.meta[key + "_actual"], Date::DATE_FORMATS[:default]) > exp
        return color_to_tag('yellow')
      end

    end

    color_to_tag('green')
  end

  def color_to_tag(color)
    case color.to_s
    when /red/i
      image_tag('flag-32.png', :size => '20x20')
    when /yellow/i
      image_tag('Flag-yellow-32.png', :size => '20x20')
    else
      ""
    end
  end
end
