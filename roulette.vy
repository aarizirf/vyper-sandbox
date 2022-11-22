players: public(DynArray[address, 100])
losers: public(DynArray[address, 100])
odds: public(uint256)
playersTurn: public(uint256)
creator: public(address)

@external
def __init__():
    self.odds = 3
    self.playersTurn = 0
    self.creator = msg.sender

@external
def setOdds(oneInThisMany: uint256):
    assert self.creator == msg.sender
    self.odds = oneInThisMany

# checks if player has lost
# checks if player is already playing
# adds to players
@external
def addPlayer(player: address):
    assert player not in self.losers
    assert player not in self.players
    assert len(self.players) <= 99
    self.players.append(player)

# access: make sure this is only internally callable
# behavior:
# clears the whole players list
# adds Player to the losers list
@internal
def lose (player: address):
    for i in self.players:
        self.players.pop()
    self.losers.append(player)

# behavior: pics a random number between 1 and the 'odds' value
# It doesn't need to be a fancy or fair function
@internal
def random() -> uint256:
    return block.timestamp % self.odds + 1

# behavior:
# rolls a random number using Random()
# grab the next player address to play
# if number is 1 call Lose on the address
# if not set the playersTurn to the next play index
@external
def play():
    rng: uint256 = self.random()
    player: address = self.players[self.playersTurn]
    if rng == 1:
        self.lose(player)
    else:
        self.playersTurn += 1
        if self.playersTurn == len(self.players):
            self.playersTurn = 0

# returns whether or not this address is in the losers list 
@external
def isALoser(person: address) -> bool:
    return person in self.losers
