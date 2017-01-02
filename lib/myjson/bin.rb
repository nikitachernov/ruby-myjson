module Myjson
  ##
  # This class defines Myjson bins/ endpoint interactions
  class Bin < Client
    PATH = 'bins'.freeze

    def show(id)
      get(PATH, id: id)
    end

    def create(data)
      post(PATH, data)
    end

    def update(id, data)
      put(PATH, id, data)
    end
  end
end
