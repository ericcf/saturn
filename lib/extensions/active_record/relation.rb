module ActiveRecord

  class Relation

    def hash_by_id
      each_with_object({}) do |record, hash|
        hash[record.id] = record
      end
    end
  end
end
