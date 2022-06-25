module Rivers
  class MatchRiver
    def initialize(orig, dest)
      @orig = orig
      @dest = dest
    end

    def call
      dest = River.find(@dest)
      orig = River.find(@orig)
      unless dest.match_id
        match = Match.create
        dest.update(match: match, match_type:'manual')
      end
      orig.update(match_id: dest.match_id, match_type:'manual')
    end
  end
end