class Shoot < ActiveRecord::Base
  serialize :meta

  belongs_to :user
  has_many :shoot_logs

  validates :event, :presence => true
  validates :description, :presence => true
  validates :photographer, :presence => true

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
    rd = Date.strptime(self.meta[:report_date], "%m/%d/%Y")

    MetaInfo::All.each do |mi|
      self.meta[mi[:key] + "_expected"] = (rd + mi[:off]).strftime("%m/%d/%Y")
    end

  end

  def initialize(*args)
    super(*args)
    self.meta ||= {}
  end

end
