namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 0: Sample query; show the names of the events available")
    result = Event.select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.

    puts("Query 1: Sample query; Report the total number of tickets bought by a given customer.")
    result1 = Customer.find(1).tickets.count
    puts(result1)
    puts("EOQ") # End Of Query --

    puts("Query 2: Sample query; Report the total number of different events that a given customer has attended.")
    result2 = Event.joins(ticket_types:{tickets: :order}).where(orders:{customer_id:1}).distinct.count
    puts(result2)
    puts("EOQ") # End Of Query --

    puts("Query 3: Sample query; Names of the events attended by a given customer.")
    result3 = Event.joins(ticket_types:{tickets: :order}).where(orders:{customer_id:1}).select(:name).distinct.map { |x| x.name }
    puts(result3)
    puts("EOQ") # End Of Query --

    puts("Query 4: Sample query; Total number of tickets sold for an event.")
    result4 = Event.joins(ticket_types: :tickets).where(id:1).distinct.count
    puts(result4)
    puts("EOQ") # End Of Query --

    puts("Query 5: Sample query; Total sales of an event.")
    result5 = TicketType.joins(:event,:tickets).where(event_id:1).sum("ticket_price")
    puts(result5)
    puts("EOQ") # End Of Query --

    puts("Query 6: Sample query; The event that has been most attended by women.")
    result6 = Event.joins(ticket_types:{tickets:{order: :customer}}).where(customers:{gender:"f"}).group(:name).distinct.count.max
    puts(result6)
    puts("EOQ") # End Of Query --

    puts("Query 7: Sample query; The event that has been most attended by men ages 18 to 30.")
    result7 = Event.joins(ticket_types:{tickets:{order: :customer}}).where("customers.gender='m' AND customers.age>=18 AND customers.age<=30").group(:name).distinct.count.max
    puts(result7)
    puts("EOQ") # End Of Query --
  end
end