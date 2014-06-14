namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'
    require 'populator'

    [Cto, Service, User, Order, Review, Schedule].each(&:delete_all)

    # Create few empty cto.

    #Create list of Cros with related records
    Cto.populate 20 do |cto|

      #Create random generator for models that are served by CTO. Will be added to CTO description
      modelType=""
      case rand(6)
        when 0
          modelType=' models:Audi'
        when 1
          modelType=' models:BMW'
        when 2
          modelType=' models:Toyota'
        when 3
          modelType=' models:Nissan'
        when 4
          modelType=' models:Mersedes'
        when 5
          modelType=' models:Honda'
      end
      cto.name=Faker::Company.name
      cto.description=Faker::Company.catch_phrase + modelType
      cto.address=Faker::Address.street_address
      cto.contacts=Faker::PhoneNumber.cell_phone
    end


    #Create  ranges of busy hours to update
    firstEvent=DateTime.new(DateTime.now.year,DateTime.now.month,DateTime.now.day,9,0)..DateTime.new(DateTime.now.year,DateTime.now.month,DateTime.now.day,10,30)
    secondEvent=DateTime.new(DateTime.now.year,DateTime.now.month,DateTime.now.day,12,0)..DateTime.new(DateTime.now.year,DateTime.now.month,DateTime.now.day,13,0)
    thirdEvent=DateTime.new(DateTime.now.year,DateTime.now.month,DateTime.now.day,15,0)..DateTime.new(DateTime.now.year,DateTime.now.month,DateTime.now.day,17,0)

    scheduleArray=[firstEvent,secondEvent,thirdEvent]

    # Populate cto with array
    Cto.all.each do |cto|
      index=0
      Schedule.populate 3 do |schedule|
        schedule.cto_id=cto.id
        #Let's set schedule start date as today
        schedule.date=Date.current
        schedule.start=scheduleArray[index].begin
        schedule.end=scheduleArray[index].end
        index+=1
      end
    end

    Cto.all.each do |cto|
      #Create list of services
      Service.populate 6 do |service|

        service.cto_id=cto.id
        service.description=Populator.sentences(2..10)
        price=Faker::Number.number(3)
        service.price=price

        #Create list of orders and users who order the service
        password='testuser'
        User.populate 3 do |user|
          user.email = Faker::Internet.email
          user.encrypted_password = User.new(:password => password).encrypted_password
          user.sign_in_count=1

          #Create custom reviews for each service
          Review.populate 2 do |review|
            #put proper references
            review.cto_id=cto.id
            review.user_id=user.id
            review.service_id=service.id

           #put actual data: mark for service and service text
            review.reviewText=Faker::Company.catch_phrase
            review.mark=rand(5)
          end

          #Each user will have few orders with different states.Only changed state will show that order was changed
          Order.populate 2 do |order|
            order.service_id=service.id
            order.user_id=user.id
            order.price=price*Faker::Number.number(1).to_f

            #set role for user. 0 - normal user, 1 - operator, 2 - cto owner, 3 - company owner
            user.role=rand(4)

            #New - order is only received
            #In Process - operator is working on this order
            #Confirmed - Order can be processed as station has schedule and can be planned
            #Ordered - Operator received confirmation from station than user arrived and ordered service
            #Completed - Station has paid us for the order

            case rand(4)
              when 0
                order.status= 'New'
              when 1
                order.status= 'In Process'
              when 2
                order.status= 'Confirmed'
              when 3
                order.status= 'Ordered'
              else
                order.status='Completed'
            end

            order.carNumber=Faker::Lorem::word
            order.uniqueCode=SecureRandom.hex(10)
            # Set planned date as date for event.
            order.requestDate=Date.current
            order.plannedDate=Date.current + 2.days
            order.confirmationDate=Date.current
          end
        end
      end
    end
  end
end