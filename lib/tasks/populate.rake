namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'
    require 'populator'

    [Cto, Service, User, Order].each(&:delete_all)

    #Create list of Cros to run experimentation
    Cto.populate 15 do |cto|
      cto.name=Faker::Company.name
      cto.description=Faker::Company.catch_phrase
      cto.address=Faker::Address.street_address
      cto.contacts=Faker::PhoneNumber.cell_phone


      #Create list of services
      Service.populate 4 do |service|
        service.cto_id=cto.id
        service.description=Populator.sentences(2..10)
        price=Faker::Number.number(3)
        service.price=price

        #Create list of orders and users who order the service
        password='testuser'
        User.populate 4 do |user|
          user.email = Faker::Internet.email
          user.encrypted_password = User.new(:password => password).encrypted_password
          user.sign_in_count=1
          #Each user will have few orders with different states.Only changed state will show that order was changed
          Order.populate 2 do |order|
            order.service_id=service.id
            order.user_id=user.id
            order.price=price*Faker::Number.number(1).to_f

            #New - order is only received
            #In Process - operator is working on this order
            #Confirmed - Order can be processed as station has schedule and can be planned
            #Ordered - Operator received confirmation from station than user arrived and ordered service
            #Completed - Station has paid us for the order

            case rand(4)
              when 0
                order.status= 'New'
              when 1
                order.status=   'In Process'
              when 2
                order.status=   'Confirmed'
              when 3
                order.status=   'Ordered'
              else
                order.status='Completed'
            end

            order.carNumber=Faker::Lorem::word
            order.uniqueCode=SecureRandom.hex(10)
            order.requestDate=Date.current
            order.plannedDate=Date.current + 2.days
            order.confirmationDate=Date.current
         end
        end
      end
  end
  end
  end