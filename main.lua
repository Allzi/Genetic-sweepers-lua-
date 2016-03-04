require "networkSystem"

function love.load()
	math.randomseed(os.time())
	math.random(1,8)
	kenttaX = 100
	kenttaY = 100
	alkuX = 50
	alkuY = 50
	tileSize = 8
	gameLenght = kenttaX*kenttaY/2
	netNum = 10
	
	seuranta = 1
	seurantaDl = 0
	graphics = true
	graphicsDl = 0
	
	fitnessit= {}
	for i=1, 10 do
		fitnessit[i]=0
	end
	
	score = {}
	
	love.graphics.setMode( kenttaX*tileSize, kenttaY*tileSize, false, false, 0 )
	
	nets = NetSys
	nets:init(netNum,18,4,10)
	
	field = {}
	for i = 1, kenttaX do
		field [i] = {}
		for j = 1, kenttaY do
			field[i][j]={}
			for z = 1, 10 do
				field[i][j][z]=0
			end
		end
	end
	
	fillerBots = {}
	for i = 1, netNum do
		fillerBots[i]={alkuX,alkuY, alkuX, alkuY, false}
	end
	turn = 1
end

function love.update(dl)

	seurantaDl = seurantaDl + dl
	graphicsDl = graphicsDl + dl
	if love.keyboard.isDown("up") and seurantaDl > 0.3 then
		seurantaDl = 0
		seuranta = seuranta + 1
		if seuranta > 10 then seuranta = 1 end
	end
	if love.keyboard.isDown("down") and graphicsDl > 0.3 then
		graphicsDl = 0
		graphics = not graphics
	end
		
	local invec = {}
	for i=1, #fillerBots do
		invec[i] = {}
		for x=0, 2 do
			for y=0, 2 do
				if fillerBots[i][1] + x - 1 < 1 or fillerBots[i][1] + x - 1 > kenttaX
				or fillerBots[i][2] + y - 1 < 1 or fillerBots[i][2] + y - 1 > kenttaY then
					invec[i][x*3 + y + 1] = 1
				else
					invec[i][x*3 + y + 1] = field[fillerBots[i][1] + x - 1][fillerBots[i][2] + y - 1][i]
				end
			end
		end
		
		for x=0, 2 do
			for y=0, 2 do
				if fillerBots[i][3] + x - 1 < 1 or fillerBots[i][3] + x - 1 > kenttaX
				or fillerBots[i][4] + y - 1 < 1 or fillerBots[i][4] + y - 1 > kenttaY then
					invec[i][x*3 + y + 10] = 1
				else
					invec[i][x*3 + y + 10] = field[fillerBots[i][3] + x - 1][fillerBots[i][4] + y - 1][i]
				end
			end
		end
	end
	local outvec = nets:update(invec)
	for i=1, #fillerBots do
		if fillerBots[i][5] == false then
			if outvec[i][1]>0.5 then fillerBots[i][1] = fillerBots[i][1] + 1 end
			if outvec[i][1]<-0.5 then fillerBots[i][1] = fillerBots[i][1] - 1 end
			if outvec[i][2]>0.5 then fillerBots[i][2] = fillerBots[i][2] + 1 end
			if outvec[i][2]<-0.5 then fillerBots[i][2] = fillerBots[i][2] - 1 end
			if fillerBots[i][1]>kenttaX then fillerBots[i][1] = kenttaX end
			if fillerBots[i][1]<1 then fillerBots[i][1] = 1 end
			if fillerBots[i][2]>kenttaY then fillerBots[i][2] = kenttaY end
			if fillerBots[i][2]<1 then fillerBots[i][2] = 1 end
			
			if outvec[i][3]>0.5 then fillerBots[i][3] = fillerBots[i][3] + 1 end
			if outvec[i][3]<-0.5 then fillerBots[i][3] = fillerBots[i][3] - 1 end
			if outvec[i][4]>0.5 then fillerBots[i][4] = fillerBots[i][4] + 1 end
			if outvec[i][4]<-0.5 then fillerBots[i][4] = fillerBots[i][4] - 1 end
			if fillerBots[i][3]>kenttaX then fillerBots[i][3] = kenttaX end
			if fillerBots[i][3]<1 then fillerBots[i][3] = 1 end
			if fillerBots[i][4]>kenttaY then fillerBots[i][4] = kenttaY end
			if fillerBots[i][4]<1 then fillerBots[i][4] = 1 end
			
			
			--if field[fillerBots[i][1]][fillerBots[i][2]][i] == 1 then fillerBots[i][5] = true end
			field[fillerBots[i][1]][fillerBots[i][2]][i] = 1
			field[fillerBots[i][3]][fillerBots[i][4]][i] = 1
		end
	end
	
	turn = turn + 1
	if turn > gameLenght then
		nextgame()
		turn = 1
	end
	
	
end
function love.draw()
	r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0,0,255,255)
	if graphics then
		for i = 1, kenttaX do
			for j = 1, kenttaY do
				if field[i][j][seuranta] == 1 then
					love.graphics.rectangle("fill",i*tileSize-tileSize,j*tileSize-tileSize,tileSize,tileSize)
				end
			end
		end
	end
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("fill", fillerBots[seuranta][1]*tileSize-tileSize, fillerBots[seuranta][2]*tileSize-tileSize,tileSize,tileSize)
	love.graphics.rectangle("fill", fillerBots[seuranta][3]*tileSize-tileSize, fillerBots[seuranta][4]*tileSize-tileSize,tileSize,tileSize)
	
	
	love.graphics.setColor(0,255,0,255)
    
	love.graphics.print("parhaat",20,20)
	for i = 0, 20 do
		if #score - i > 0 then
			love.graphics.print(score[#score-i],20,20*i + 40)
		end
	end
	love.graphics.print("seurannassa",100,20)
	love.graphics.print(seuranta,200,20)
	love.graphics.print("vuoro",100,40)
	love.graphics.print(turn,200,40)
	love.graphics.print("verkkoja",100,60)
	love.graphics.print(nets.idcounter,200,60)
	love.graphics.print("sukupolvi",100,80)
	love.graphics.print(#score + 1,200,80)
    
    
	
	love.graphics.setColor(r,g,b,a)
end

function nextgame()
	for i = 1, netNum do
		fitnessit[i] = 0
		for x = 1, #field do
			for y = 1, #field[x] do
				if field[x][y][i] == 1 then fitnessit[i] = fitnessit[i] + 1 end
			end
		end
	end
	nets:generation(fitnessit)
	score[#score + 1] = fitnessit[1]
	
	for i = 1, 10 do
		fillerBots[i]={alkuX,alkuY, alkuX, alkuY, false}
	end
	for i = 1, kenttaX do
		for j = 1, kenttaY do
			for z = 1, netNum do
				field[i][j][z]=0
			end
		end
	end
	
end










