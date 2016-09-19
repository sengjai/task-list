# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.txt file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

require 'csv'
require 'byebug'

class Todo
	attr_accessor :id, :task, :completed
	def initialize(hash)
		@id = hash[:id]
		@task = hash[:task]
		@completed = hash[:completed]
	end
end

class TaskParser
	attr_reader :file, :current_task

	def initialize(file)
		@file = file
		@job = []
		@current_task = ""
	end

	def add(job_task)
		@job << Todo.new(id: @job.length+1, task: job_task)
	end

	def delete(id)
		@job.each do |x|
			if x.id == id
				@current_task = x.task
				@job.delete(x)
			end
		end
	end

	def complete(id)
		@job.each do |x|
			if x.id == id
				@current_task = x.task
				x.completed = "x"
			end
		end
	end

	def task
		CSV.foreach(@file, :headers => true, :header_converters => :symbol) do |csv_obj|
       @job << Todo.new(csv_obj)
    end
  end

  def save
    CSV.open("todo.csv","wb") do |csv|
    	index = 1
      csv << ["id","task","completed"]
      @job.each do |elem|
        csv << [index,elem.task,elem.completed]
        index += 1
      end
    end
  end

  def list
  	@job.each do |elem|
  		puts (elem.id).to_s + ". " + "[" + (elem.completed).to_s.upcase + "]" + (elem.task).to_s
  	end
  end
end

request = ARGV
parser = TaskParser.new('todo.csv')
if request.first == "list"
	parser.task
	parser.list
elsif request.first == "add"
	request.shift
	parser.task
	job_task = request.join(" ")
	parser.add(job_task)
	puts "Appended \"#{job_task}\" to your TODO list..."
	parser.save
elsif request.first == "delete"
	request.shift
	parser.task
	id = request.join()
	parser.delete(id)
	puts "Deleted \"#{parser.current_task}\" to your TODO list..."
	parser.save
elsif request.first == "complete"
	request.shift
	parser.task
	task_id = request.join()
	parser.complete(task_id)
	puts "Completed \"#{parser.current_task}\" to your TODO list..."
	parser.save
end





