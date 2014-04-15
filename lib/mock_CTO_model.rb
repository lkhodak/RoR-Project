
# Special mock class to emulate work in db layer
class CTOMock
  attr_accessor :cto_id
  attr_accessor :cto_name
  attr_accessor :cto_addr
  attr_accessor :cto_discount
  def initialize(id, name, addr, discount)
    @cto_id=id
    @cto_name=name
    @cto_addr=addr
    @cto_discount=discount
  end
end
