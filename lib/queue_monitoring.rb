module QueueMonitoring
  def queued?(*args)
    string_args = args.map(&:to_s)
    running?(string_args) or scheduled?(string_args)
  end

  private

  def running?(args)
    Sidekiq.redis do |redis|
      jobs     = redis.smembers('workers').map { |worker| job redis.get("worker:#{worker}") }
      job_args = job_arguments_in jobs
      job_args.include? args
    end
  end

  def scheduled?(args)
    Sidekiq.redis do |redis|
      job_args = []

      redis.smembers('queues').map do |queue_name|
        items_count = redis.llen "queue:#{queue_name}"
        jobs        = 0.upto(items_count - 1).map { |n| queue_item redis.lindex("queue:#{queue_name}", n) }

        job_args += job_arguments_in jobs
      end

      job_args.include? args
    end
  end

  def job_arguments_in(jobs)
    jobs.select { |class_name, args| class_name == name }.map(&:second)
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
