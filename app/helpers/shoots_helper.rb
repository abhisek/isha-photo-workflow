module ShootsHelper

  def colorize_shoot_entry(shoot)
    now = Date.strptime(Time.now.strftime("%m/%d/%Y"), "%m/%d/%Y")

    klass = ''

    ::Shoot::MetaInfo::All.each do |mi|
      exp = Date.strptime(shoot.meta[mi[:key] + "_expected"], "%m/%d/%Y")

      if shoot.meta[mi[:key] + "_actual"].to_s.empty? and exp < now
        klass = 'red'
        break
      elsif shoot.meta[mi[:key] + "_actual"].to_s.empty?
        next
      end

      act = Date.strptime(shoot.meta[mi[:key] + "_actual"], "%m/%d/%Y")

      if act > exp
        klass = 'yellow'
      end

    end

    klass
  end

end
