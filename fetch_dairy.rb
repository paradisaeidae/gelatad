require 'dry/monads/all'
# Construct technique for obtaining ingredients. To make a batch of gelato
# Three flavours available, Raspberry, Vanilla and Chocolate!
# Simplification for example: Make order, ingredients delivered. Or not!
# Here using task as it is more async.
class ObtainDairy
include Dry::Monads::Task::Mixin

def call
 # Start two orders running concurrently
 milkOrder  = Task { fetch_milk  }
 creamOrder = Task { fetch_cream }
 milkOrder.bind { |milK| creamOrder.fmap { |creaM| [milK, creaM] } } end

def fetch_milk
 sleep 3
 [{ litres: ' of milk:', amount: '6' }] end

def fetch_cream
 sleep 2
 [{ litres: ' of cream:', amount: '2' }] end end

# Open the orders book!
basicDairy = ObtainDairy.new

# Spin up two orders
obtainDairyTask = basicDairy.call

# Wait for the delivery
obtainDairyTask.wait(5)

obtainDairyTask.fmap do |milkOrder, creamOrder|
 puts "milkOrder: #{ milkOrder.inspect }"
 puts "creamOrder: #{ creamOrder.inspect }" end
