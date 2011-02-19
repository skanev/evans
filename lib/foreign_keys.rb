module ForeignKeys
  def foreign_key(table, column, ref_table = nil, ref_column = nil)
    ref_table  ||= column.to_s.gsub(/_id$/, '').tableize
    ref_column ||= 'id'

    execute "ALTER TABLE #{table} ADD FOREIGN KEY (#{column}) REFERENCES #{ref_table}(#{ref_column})"
  end
end
