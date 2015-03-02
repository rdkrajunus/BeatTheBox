# guesses that the dealtCard will be higher than the card at the ith index in
# box.
# dealtCard is an integer bounded on [2-14], where 11-14 correspond to J, Q, K and A
# respectively
# box is a vector of length 9, of all the cards in the 3x3 grid.
# i is the position of the chosen card
higher <- function(dealtCard, box, i) {
    if ((dealtCard > box[i]) || ((dealtCard == 8) && (box[i] == 8))) {
        box[i] <- dealtCard
    }
    else {
        box[i] <- NA
    }

    box
}

# guesses that the dealtCard will be lower than the card at the ith index in
# box.
lower <- function(dealtCard, box, i) {
    if ((dealtCard < box[i]) || ((dealtCard == 8) && (box[i] == 8))) {
        box[i] <- dealtCard
    }
    else {
        box[i] <- NA
    }

    box
}

# given a vector of 52 integers bounded on [2-14], play beat the box according
# to the naive strategy defined in the readme.md
playNaively <- function(deck) {
    count <- 9
    box <- deck[1:9]

    for (dealtCard in deck[10:52]) {

        underCard.idx <- which.max(abs(box-8))
        underCard <- box[underCard.idx]

        if (underCard < 8) {
            box <- higher(dealtCard, box, underCard.idx)
        }
        else if (underCard == 8) {

            if (rbinom(1, 1, .5) == 1) {
                box <- higher(dealtCard, box, underCard.idx)
            }
            else {
                box <- lower(dealtCard, box, underCard.idx)
            }
        }
        else if (underCard > 8) {
            box <- lower(dealtCard, box, underCard.idx)
        }

        if (all(is.na(box))) {
            return(count)
        }

        count <- count + 1
    }
    return(count)
}

suit <- c(2:14)
deck <- rep(suit, 4)
set.seed(1013)

#construct 500,000 shuffled 52 card decks
playingDecks <- replicate(sample(deck, replace=F), n=500000, simplify = TRUE)

#for each deck, play the naive strategy, and for each deck, return how many
#cards were successfully dealt before the game ended.  If 52 cards were dealt
#the game was successful.
naive <- apply(playingDecks, 2, playNaively)
length(which(naive == 52))/500000