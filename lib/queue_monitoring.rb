module QueueMonitoring
  def queued?(task_id)
    running?(task_id) or scheduled?(task_id)
  end

  private

  def running?(task_id)
    Sidekiq.redis do |redis|
      jobs     = redis.smembers('workers').map { |worker| job redis.get("worker:#{worker}") }
      task_ids = task_ids_in jobs
      puts "Running: #{task_ids.inspect}"
      task_ids.include? task_id.to_i
    end
  end

  def scheduled?(task_id)
    Sidekiq.redis do |redis|
      task_ids = []

      redis.smembers('queues').map do |queue_name|
        items_count = redis.llen "queue:#{queue_name}"
        jobs        = 0.upto(items_count - 1).map { |n| queue_item redis.lindex("queue:#{queue_name}", n) }

        task_ids += task_ids_in(jobs)
      end
      puts "Scheduled: #{task_ids.inspect}"

      task_ids.include? task_id.to_i
    end
  end

  def task_ids_in(jobs)
    jobs.select { |class_name, args| class_name == name }.map(&:second).map(&:first).map(&:to_i)
  end

  def job(json)
    document   = JSON(json)
    class_name = document['payload']['class']
    arguments  = document['payload']['args']

    [class_name, arguments]
  end

  def queue_item(json)
    document = JSON(json)
    class_name = document['class']
    arguments  = document['args']

    [class_name, arguments]
  end
end
