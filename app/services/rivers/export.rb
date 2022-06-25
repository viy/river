require 'csv'

module Rivers
  class Export
    def initialize(source_id)
      @source_id = source_id
    end

    def call
      rivers = ActiveRecord::Base.connection.execute(
        River.sanitize_sql_array([sql, @source_id, @source_id]))
      file = Tempfile.new('rivers.csv')
      rivers.each do |row|
        file << "#{row['origin_id']},#{row['destination_id']},#{row['source_name']}\n"
      end
      file
    ensure
      file.close
      #file.unlink
    end

    def sql
      <<-SQL
        SELECT a.origin_id as origin_id,  b.origin_id as destination_id, sources.name as source_name
        FROM rivers as a
        JOIN rivers as b
        ON  a.match_id = b.match_id
        JOIN sources
        ON a.source_id = sources.id
        where b.source_id = ? AND a.source_id != ?
      SQL
    end
  end
end
