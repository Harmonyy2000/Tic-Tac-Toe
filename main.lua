function love.load()
    newGame()
end

function love.draw()
    drawBoard()
    drawMarkers()
    if gameWon == true then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(winnerText, 100, 100, 0, 1, 1)
    end
end

function love.mousepressed(x, y, button)
    if gameWon == true then
        newGame()
        return
    elseif x >= 340 and x < 940 and y >= 60 and y < 660 then
        local gridPos = {x = math.ceil((x - 340) / 200), y = math.ceil((y - 60) / 200)}
        if board[gridPos.y][gridPos.x] == 0 then
            board[gridPos.y][gridPos.x] = currentPlayer
            currentPlayer = -currentPlayer
        end
    end
    checkWin()
end

function newGame()
    gameWon = false
    winnerText = love.graphics.newText(love.graphics.newFont(30), nil)
    board = {
        {0, 0, 0},
        {0, 0, 0},
        {0, 0, 0}}
    currentPlayer = 1
end

function checkWin()
    local winRow = checkWinRow()
    local winCol = checkWinCol()
    local winDiagonal = checkWinDiagonal()
    local stalemate = checkStalemate()
    if winRow == 1 or winCol == 1 or winDiagonal == 1 then
        gameWon = true
        winnerText:set("Red wins!")
    elseif winRow == -1 or winCol == -1 or winDiagonal == -1 then
        gameWon = true
        winnerText:set("Green wins!")
    elseif stalemate == 1 then
        gameWon = true
        winnerText:set("It's a draw!")
    end
end

function checkWinRow()
    for i,row in ipairs(board) do
        if row[1] == 1 and row[2] == 1 and row[3] == 1 then
            return 1
        elseif row[1] == -1 and row[2] == -1 and row[3] == -1 then
            return -1
        else
            return 0
        end
    end
end

function checkWinCol()
    local leftCol = 0
    local middleCol = 0
    local rightCol = 0
    for i,row in ipairs(board) do
        leftCol = leftCol + row[1]
        middleCol = middleCol + row[2]
        rightCol = rightCol + row[3]
    end
    if leftCol == 3 or middleCol == 3 or rightCol == 3 then
        return 1
    elseif leftCol == -3 or middleCol == -3 or rightCol == -3 then
        return -1
    else
        return 0
    end
end

function checkWinDiagonal()
    local firstDiagonal = 0
    local secondDiagonal = 0
    for i,row in ipairs(board) do
        firstDiagonal = firstDiagonal + row[i]
        secondDiagonal = secondDiagonal + row[4-i]
    end
    if firstDiagonal == 3 or secondDiagonal == 3 then
        return 1
    elseif firstDiagonal == -3 or secondDiagonal == -3 then
        return -1
    else
        return 0
    end
end

function checkStalemate()
    for i,row in ipairs(board) do
        for j,square in ipairs(row) do
            if square == 0 then
                return 0
            end
        end
    end
    return 1
end

function drawBoard()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 538, 60, 3, 600) -- Left vertical
    love.graphics.rectangle("fill", 739, 60, 3, 600) -- Right vertical
    love.graphics.rectangle("fill", 340, 258, 600, 3) -- Top horizontal
    love.graphics.rectangle("fill", 340, 459, 600, 3) -- Bottom horizontal
end

function drawMarkers()
    for i,row in ipairs(board) do
        for j,square in ipairs(row) do
            local x = 340 + (200 * j - 100)
            local y = 60 + (200 * i - 100)
            if square ~= 0 then
                if square == 1 then
                    love.graphics.setColor(255, 0, 0)
                elseif square == -1 then
                    love.graphics.setColor(0, 255, 0)
                end
                love.graphics.circle("fill", x, y, 75)
            end
        end
    end
end