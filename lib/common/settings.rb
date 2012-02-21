class Settings
  def self.init
    @@settings = YAML.load(File.read(File.join(Rails.root.to_s, "config/setting.yml")))
  end

  def self.method_missing(*args)
    name = args.shift.to_s
    @@settings["cfg_#{name}".to_sym]
  end
end
