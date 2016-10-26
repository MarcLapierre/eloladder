module ActiveRelationExtensions

  def find_each_with_order(options = {})
    find_in_batches_with_order(options) do |records|
      records.each { |record| yield record }
    end
  end

  # NOTE: any limit() on the query is overridden with the batch size
  def find_in_batches_with_order(options = {})
    options.assert_valid_keys(:batch_size)

    relation = self

    start = 0
    batch_size = options.delete(:batch_size) || 1000

    relation = relation.limit(batch_size)
    records = relation.offset(start).to_a

    while records.any?
      records_size = records.size

      yield records

      break if records_size < batch_size

      # get the next batch
      start += batch_size
      records = relation.offset(start + 1).to_a
    end
  end
end

ActiveRecord::Relation.send(:include, ActiveRelationExtensions)

module ActiveRecord
  module Querying
    delegate :find_each_with_order, :find_in_batches_with_order, :to => :scoped
  end
end
