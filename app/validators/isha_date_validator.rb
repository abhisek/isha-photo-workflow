class IshaDateValidator < ActiveModel::Validator
  def validate(record)
    if record.reported_on < record.shot_on
      record.errors[:reported_on] << "cannot be before shot_on"
      return false
    end

    Shoot::MetaInfo::All.each do |mi|
      unless record.meta[mi[:key] + "_actual"].to_s.empty?
        key_date = Date.strptime(record.meta[mi[:key] + "_actual"], Date::DATE_FORMATS[:default])

        if key_date < record.reported_on
          record.errors[:date] << "- #{mi[:name]} date cannot be before reported_on"
          return false
        end
      end
    end
  end
end
