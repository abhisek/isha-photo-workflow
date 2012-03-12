module Exporter

  class CSV
    def initialize
      @schema = []
      @entries = []
    end

    def schema=(x)
      @schema = x
    end

    def add_entry(a)
      @entries << a
    end

    def to_string(sep = "\t")
      r = String.new
      r << @schema.collect {|e| e.capitalize}.join(sep) << "\n"
      r << @entries.inject("") {|re, ee| re << ee.join(sep) << "\n"; re}

      r
    end
  end

end
