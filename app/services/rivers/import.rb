require 'csv'

module Rivers
  class Import
    attr_reader :errors, :distant_match_ids

    def initialize(file, source_id)
      @file = file
      @source_id = source_id
      @parsed_rivers_ids = []
      @close_match_ids = []
      @distant_match_ids = []
      @errors = []
    end

    def call
      parse_file
      match_rivers
    end

    def total_rivers
      @parsed_rivers_ids.count
    end

    def matched_rivers
      @close_match_ids.count
    end

    def ready_to_match
      @distant_match_ids.count
    end

    def not_matched
      total_rivers - matched_rivers - ready_to_match
    end

    private
    def parse_file
      CSV.foreach(@file, headers: true) do |row|
        parse(row)
      end
    rescue => e
      @errors << "Not able to parse CSV"
    end

    # "id","river_name","name","put_in_long","put_in_lat","take_out_long","take_out_lat","import_id"
    def parse(row)
      river = River.find_or_initialize_by(origin_id:row['id'], source_id: @source_id)
      river.update(river: row['river_name'], section: row['name'],
                   put_in_lat: row['put_in_lat'], put_in_long: row['put_in_long'],
                   take_out_long: row['take_out_long'], take_out_lat: row['take_out_lat'],
                   grade: row['grade'])
      river.save!
      @parsed_rivers_ids << river.id
    rescue => e
      @errors << "#{row["id"]} was not parsed correctly"
    end

    def match_rivers
      close_match_rivers
      distant_match_rivers
    end

    def close_match_rivers
      matches = ActiveRecord::Base.connection.execute(River.sanitize_sql_array([sql, 300, 300, @source_id, @source_id, @parsed_rivers_ids]))
      matches.each do |row|
        match_river = River.find(row['origin_id'])
        match_river.update(match_id: match_id(row), match_type: 'auto')
        @close_match_ids << match_river.id
      end
    end

    def match_id(row)
      return row['destination_match_id'] if row['destination_match_id']

      match_id = Match.create.id
      River.find(row['destination_id']).update(match_id: match_id, match_type: 'auto')
      match_id
    end

    def distant_match_rivers
      distant_match_sql = sql + ' AND a.id NOT IN (?)'
      matches = ActiveRecord::Base.connection.execute(
        River.sanitize_sql_array([distant_match_sql, 5000, 5000,
                                  @source_id, @source_id, @parsed_rivers_ids,
                                  @close_match_ids]))
      matches.each do |row|
        match_river = River.find(row['origin_id'])
        match_river.update(match_type: 'ready_to_match')
        @distant_match_ids << match_river.id
      end
    end

    def sql
      <<-SQL
        SELECT a.id as origin_id, b.match_id as destination_match_id, b.id as destination_id
        FROM rivers as a, rivers as b
        WHERE
            (ST_DistanceSphere(ST_MakePoint(a.take_out_long, a.take_out_lat), ST_MakePoint(b.take_out_long, b.take_out_lat)) < ?
          AND ST_DistanceSphere(ST_MakePoint(a.put_in_long, a.put_in_lat), ST_MakePoint(b.put_in_long, b.put_in_lat)) < ?)
          AND a.source_id = ? AND b.source_id != ? AND a.id IN (?)
      SQL
    end
  end
end