require "neuralNetwork"

NetSys = {
	nets = {},
	idcounter = 1
}
function NetSys:init(netN, inputs, outputs, neurons)
	for i = 1, netN do
		self.nets[i] = NeuralNetwork:copy()
		self.nets[i]:init(inputs, outputs, neurons, self.idcounter)
		self.idcounter = self.idcounter + 1
	end
end

function NetSys:update(input)
	local output = {}
	for i=1, #self.nets do
		output[i]=self.nets[i]:update(input[i])
	end
	return output
end

function NetSys:generation(fitness)
	for i=1,#self.nets do
		self.nets[i]:reset()
	end
    -- sort nets by fitness, from high to low
	for i = 1, #fitness - 1 do
		for j = 1, #fitness - 1 do
			if fitness[j] < fitness[j+1] then
				local temp1 = fitness[j]
				local temp2 = self.nets[j]
				fitness[j] = fitness[j+1]
				self.nets[j] = self.nets[j+1]
				fitness[j+1]=temp1
				self.nets[j+1]=temp2
			end
		end
	end
    -- new nets
    -- leaves 2, mutates rest.
	for i = 3, #self.nets do
		-- make other nets as copies of the 2 best.
		self.nets[i] = self.nets[i%2 +1]:copy()
        
        -- mutate each new net
		for k=1, i/3+1 do -- nets in the end of the array eat uranium more and more
			self.nets[i]:mutate()
		end
		self.nets[i].id = self.idcounter
		self.idcounter = self.idcounter+1
	end
    
end