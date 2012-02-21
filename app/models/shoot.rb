class Shoot < ActiveRecord::Base
  serialize :meta

  belongs_to :user
  has_many :shoot_logs

  validates :event, :presence => true
  validates :description, :presence => true
  validates :photographer, :presence => true

  scope :f_after_create,  lambda {|date| where('created_at > ?', date) }
  scope :f_before_create, lambda {|date| where('created_at < ?', date) }
  scope :f_event_like,    lambda {|event| where('event LIKE ?', "%#{event}%") }
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
        :name => 'Compiled and Checked',
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
        :off  => 7.days
      },
      {
        :name => 'Thumbnail',
        :key  => 'thmbn',
        :off  => 30.days
      }
    ]
  end

  def my_before_save
    rd = self.reported_on

    MetaInfo::All.each do |mi|
      self.meta[mi[:key] + "_expected"] = (rd + mi[:off]).strftime(Date::DATE_FORMATS[:default])
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

end
