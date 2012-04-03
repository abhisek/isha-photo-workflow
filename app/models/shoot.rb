class Shoot < ActiveRecord::Base
  serialize :meta

  belongs_to :user
  has_many :shoot_logs

  validates :event, :presence => true
  validates :description, :presence => true
  validates :photographer, :presence => true

  validates_with IshaDateValidator

  scope :f_after_create,  lambda {|date| where('created_at > ?', date) }
  scope :f_before_create, lambda {|date| where('created_at < ?', date) }
  scope :f_event_like,    lambda {|event| where('event LIKE ? OR description LIKE ?', "%#{event}%", "%#{event}%") }
  scope :f_photographer_like, lambda {|p| where('photographer LIKE ?', "%#{p}%") }

  before_save :my_before_save

  class MetaInfo
    All = [
      {
        :name => 'Downloaded and Renamed',
        :key  => 'dwrn',
        :off  => 1.day
      },
      {
        :name => 'Deleted and Tagged',
        :key  => 'deltag',
        :off  => 2.days
      },
      {
        :name => 'Selection by Sundar Rajan',
        :key  => 'selsundar',
        :off  => 2.days
      },
      {
        :name => 'Selection Confirmed',
        :key  => 'selconfirmed',
        :off  => 2.days
      },
      {
        :name => 'Complied, Checked and Shifted to the Server',
        :key  => 'compcheck',
        :off  => 3.days
      },
      {
        :name => 'Edited',
        :key  => 'edtd',
        :off  => 5.days
      },
      {
        :name => 'Categorized',
        :key  => 'catg',
        :off  => 6.days
      },
      {
        :name => 'Shifted to LTO',
        :key  => 'shiflto',
        :off  => :next_month_4
      },
      {
        :name => 'Thumbnail',
        :key  => 'thmbn',
        :off  => :next_month_10
      }
    ]
  end

  def my_before_save
    rd = self.reported_on

    MetaInfo::All.each do |mi|
      self.meta[mi[:key] + "_expected"] = (to_effective(rd, mi[:off])).strftime(Date::DATE_FORMATS[:default])
    end

    # Ensure correctness of date format
    MetaInfo::All.each do |mi|
      Date.strptime(self.meta[mi[:key] + "_expected"], Date::DATE_FORMATS[:default])
      Date.strptime(self.meta[mi[:key] + "_actual"], Date::DATE_FORMATS[:default]) unless self.meta[mi[:key] + "_actual"].to_s.empty?
    end
  end

  def is_key_applicable?(k)
    if (self.photographer !~ /chitranga/i) and (k == 'selsundar')
      return false
    else
      return true
    end
  end

  def initialize(*args)
    super(*args)
    self.meta ||= {}
  end

  def flag
    shoot = self
    now = Date.current
    ret = :none

    ::Shoot::MetaInfo::All.each do |mi|
      next if (!shoot.is_key_applicable?(mi[:key]))
      
      exp = Date.strptime(shoot.meta[mi[:key] + "_expected"], Date::DATE_FORMATS[:default])
      if shoot.meta[mi[:key] + "_actual"].to_s.empty? and exp < now
        ret = :red
        break
      elsif shoot.meta[mi[:key] + "_actual"].to_s.empty?
        next
      end

      act = Date.strptime(shoot.meta[mi[:key] + "_actual"], Date::DATE_FORMATS[:default])
      if act > exp and exp < now
        ret = :yellow
      end
    end
    
    return ret
  end

  private
  def to_effective(base, off)
    if off == :next_month_4
      next_month_day(base, 4)
    elsif off == :next_month_10
      next_month_day(base, 10)
    else
      base + off
    end
  end

  def next_month_day(date, day)
    d = date.day
    m = date.month
    y = date.year

    if m == 12
      m = 1
      y += 1
    else
      m += 1
    end

    d = day

    Date.strptime("#{d}/#{m}/#{y}", Date::DATE_FORMATS[:default])
  end
end
