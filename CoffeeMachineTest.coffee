should = require('chai').should()

class Beverage
	constructor: (@code, @price, @isHot) ->

class CoffeeMachine
	constructor: ->
		@stat = {}
		@fund = 0
		@beverages = 
			'Tea': new Beverage('T',40, true),
			'Coffee': new Beverage('C',50,true),
			'Chocolate': new Beverage('H',60,true),
			'Orange': new Beverage('O',60, false)
		
	order: (beverageName, sugarAmount, money, extraHot) ->
		return 'M:not enough money' if @beverages[beverageName].price > money
		@stat[beverageName] = 0 unless @stat[beverageName]? 
		@stat[beverageName]++
		@fund += @beverages[beverageName].price
		sugarPart = ':'
		beveragePart = @beverages[beverageName].code
		beveragePart += 'h' if @beverages[beverageName].isHot && extraHot
		if @beverages[beverageName].isHot && sugarAmount >= 1
			sugarAmount = 2 if sugarAmount > 2
			sugarPart = "#{sugarAmount}:0"
		"#{beveragePart}:#{sugarPart}"

	report:  ->
		result = ""
		result += "#{beverageName} : #{count}\n" for beverageName, count of @stat
		result += "Fund : #{@fund}"
		result

		
describe 'CoffeeMachine', ->

	it 'should return T:: when ordering a tea', ->
		new CoffeeMachine().order('Tea',0,100,false).should.equal 'T::'

	it 'should return C:: when ordering a coffee', ->
		new CoffeeMachine().order('Coffee',0,100,false).should.equal 'C::'

	it 'should return H:: when ordering a chocolate', ->
		new CoffeeMachine().order('Chocolate',0,100,false).should.equal 'H::'

	it 'should return T:1:0 when ordering a tea with 1 sugar', ->
		new CoffeeMachine().order('Tea',1,100,false).should.equal 'T:1:0'

	it 'should return T:2:0 when ordering a tea with 2 sugars', ->
		new CoffeeMachine().order('Tea',2,100,false).should.equal 'T:2:0'

	it 'should return T:2:0 when ordering a tea with 3 sugars', ->
		new CoffeeMachine().order('Tea',3,100,false).should.equal 'T:2:0'

	it 'should return M:NoMoney when ordering a tea with 10 cents', ->
		new CoffeeMachine().order('Tea',3,10,false).should.equal 'M:not enough money'

	it 'should return O:: when ordering an orange juice', ->
		new CoffeeMachine().order('Orange',0,60,false).should.equal 'O::'

	it 'should return O:: when ordering an orange juice with sugars', ->
		new CoffeeMachine().order('Orange',2,60,false).should.equal 'O::'

	it 'should return O:: when ordering an extra hot orange juice', ->
		new CoffeeMachine().order('Orange',0,60,true).should.equal 'O::'

	it 'should return Ch:: when ordering an extra hot Coffee', ->
		new CoffeeMachine().order('Coffee',0,100,true).should.equal 'Ch::'

	it 'should return Hh:: when ordering an extra hot Chocolate', ->
		new CoffeeMachine().order('Chocolate',0,100,true).should.equal 'Hh::'

	it 'should return Th:: when ordering an extra hot Tea', ->
		new CoffeeMachine().order('Tea',0,100,true).should.equal 'Th::'

	it 'should count when a coffee is ordered', ->
		coffeeMachine = new CoffeeMachine()
		coffeeMachine.order('Coffee',0,100,true)
		coffeeMachine.stat['Coffee'].should.equal 1

	it 'should count the money ordered when a tea is ordered', ->
		coffeeMachine = new CoffeeMachine()
		coffeeMachine.order('Tea',0,100,true)
		coffeeMachine.order('Chocolate',0,100,true)
		coffeeMachine.fund.should.equal 100

	it 'should display the report', ->
		coffeeMachine = new CoffeeMachine()
		numberOfTea = 2
		numberOfChocolate = 5
		numberOfCoffee = 3
		coffeeMachine.order('Tea',0,100,true) for count in [1..numberOfTea]
		coffeeMachine.order('Chocolate',0,100,true) for count in [1..numberOfChocolate]
		coffeeMachine.order('Coffee',0,100,true) for count in [1..numberOfCoffee]
		coffeeMachine.report().should.equal """
		Tea : #{numberOfTea}
		Chocolate : #{numberOfChocolate}
		Coffee : #{numberOfCoffee}
		Fund : #{ numberOfTea*40 + numberOfChocolate*60 + numberOfCoffee*50}
		"""

