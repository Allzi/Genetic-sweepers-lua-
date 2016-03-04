
NeuralNetwork = {
	id = 0,
	neurons = {},
	links = {},
	inputN = 0,
	outputN = 0,
	mutateSpeed = 1
}

function NeuralNetwork:init(inputs, outputs, neurons, id)
	self.inputN = inputs
	self.outputN = outputs
	self.id = id
	for i = 1, inputs + outputs + neurons do
		self.neurons[i]=0
		self.links[i]={}
		for j = 1, #self.neurons do
			self.links[j][i]= math.random()*2 -1
			self.links[i][j]= math.random()*2 -1
		end
	end
end

function NeuralNetwork:mutate()
	mutateSpeed = self.mutateSpeed*(math.random()*0.5+0.8)
	local fuuuu = math.random(self.inputN +1, #self.neurons)
	for i = 1,#self.neurons do
		self.links[i][fuuuu] = self.links[i][fuuuu] + (math.random() - 0.5)*mutateSpeed
		self.links[fuuuu][i] = self.links[fuuuu][i] + (math.random() - 0.5)*mutateSpeed
	end
end


function NeuralNetwork:addNeuron()
	self.neurons[#self.neurons+1] = 0
	local baa = #self.links +1
	for i = 1, baa do
		self.links[i][baa] = 0
		self.links[baa][i] = 0
	end
end

function NeuralNetwork:update(input)
	for i = 1, #input do --inputneuronit
		self.neurons[i]=input[i]
	end
	
	for i = self.inputN + self.outputN + 1, #self.neurons do -- välineuronit
		local sum = 0
		for j = 1, #self.links do
			sum = self.links[j][i]*self.neurons[j] + sum
		end
		self.neurons[i] = (math.exp(sum)-math.exp(-sum))/(math.exp(sum)+math.exp(-sum))
	end
	
	for i = self.inputN + 1, self.inputN + self.outputN do --outputit
		local sum = 0
		for j = 1, #self.links do
			sum = self.links[j][i]*self.neurons[j] + sum
		end
		self.neurons[i] = (math.exp(sum)-math.exp(-sum))/(math.exp(sum)+math.exp(-sum))
	end
	local output = {}
	for i = 1, self.outputN do
		output[i]=self.neurons[self.inputN + i]
	end
	return output
end

function NeuralNetwork:copy()
	return copy(self, true)	
end

function NeuralNetwork:reset()
	for i = 1, #self.neurons do
		self.neurons[i] = 0
	end
end

function copy(obj, deep, saved, ret)
	ret = ret or {}
	saved = saved or {}
	for k, v in pairs(obj) do
		if deep and type(v) == "table" then
			if not saved[v] then
				saved[v] = {}
				ret[k] = copy(v, deep, saved, saved[v])
			else
				ret[k] = saved[v]
			end
		else
			ret[k] = v
		end
	end
	setmetatable(ret, getmetatable(obj))
	return ret
end