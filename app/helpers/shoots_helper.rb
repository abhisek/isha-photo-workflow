module ShootsHelper

  def colorize_shoot_entry(shoot)
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

    klass
  end

  def colorize_shoot_key(shoot, key)
    now = Date.current
    exp = Date.strptime(shoot.meta[key + "_expected"], Date::DATE_FORMATS[:default])

    if (shoot.is_key_applicable?(key)) and (exp < now)

      if shoot.meta[key + "_actual"].to_s.empty? 
        return 'red'
      end

      if Date.strptime(shoot.meta[key + "_actual"], Date::DATE_FORMATS[:default]) > exp
        return 'yellow'
      end

    end

    return 'green' # none
  end

end
