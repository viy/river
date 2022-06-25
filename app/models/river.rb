class River < ApplicationRecord
  belongs_to :source
  belongs_to :match, optional: true
  scope :ready_to_match, ->(source_id) {where(source_id: source_id, match_type: 'ready_to_match')}
  scope :match_list, ->(source_id) {where(source_id: source_id)
                                          .where("match_type != 'auto' AND match_type IS NOT NULL")}
  scope :close_to, ->(source) do
    where("ST_DistanceSphere(ST_MakePoint(take_out_long, take_out_lat), ST_MakePoint(?, ?)) < 10000
          AND ST_DistanceSphere(ST_MakePoint(put_in_long, put_in_lat), ST_MakePoint(?, ?)) < 10000",
          source.take_out_long, source.take_out_lat, source.put_in_long, source.put_in_lat)
      .where("source_id != ?", source.source_id)
  end

  after_update_commit do
    if match_type
      #broadcast_update html: match_type.humanize
    end
  end
end
