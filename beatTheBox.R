library(binom)

# guesses that the dealtCard will be higher than the card at the ith index in
# box.
# dealtCard is an integer bounded on [2, 14], where 11-14 correspond to J, Q, K and A
# respectively
# box is a vector of length 9, of all the cards in the 3x3 grid.
# i is the position of the chosen card
higher <- function(dealtCard, box, i) {
    if (is.na(box[i])) {
        box[i] <- NA
    }
    else if ((dealtCard > box[i]) || ((dealtCard == 8) & (box[i] == 8))) {
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
    if (is.na(box[i])) {
        box[i] <- NA
    }
    else if ((dealtCard < box[i]) || ((dealtCard == 8) && (box[i] == 8))) {
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

calcProbHigherLower <- function(boxCard, deck) {
    if (is.na(boxCard)) {
        return(c(0,0))
    }

    cardsRemainingTotal <- length(deck)

    higherNumerator <- ifelse(boxCard == 8, length(which(deck >= boxCard)), length(which(deck > boxCard)))
    lowerNumerator <- ifelse(boxCard == 8, length(which(deck <= boxCard)), length(which(deck < boxCard)))

    probHigher <- length(which(deck > boxCard)) / cardsRemainingTotal
    probLower <- length(which(deck < boxCard)) / cardsRemainingTotal
    return(c(probHigher, probLower))
}

playProbabilistically <- function(deck) {
    count <- 9
    box <- deck[1:9]

    for (i in 10:52) {
        higherLowerProbs <- sapply(box, calcProbHigherLower, deck=deck[i:52])
        maxProbIdx <- which.max(higherLowerProbs)
        boxCardIdx <- ceiling(maxProbIdx/2)

        if (maxProbIdx %% 2 == 0) {
            box <- lower(deck[i], box, boxCardIdx)
        }
        else {
            box <- higher(deck[i], box, boxCardIdx)
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

# construct 25,000 shuffled 52 card decks
size <- 25000
#Rprof("profile.out")
playingDecks <- replicate(sample(deck, replace=F), n=size, simplify = TRUE)

# for each deck, play the naive strategy, and for each deck, return how many
# cards were successfully dealt before the game ended.  If 52 cards were dealt
# the game was successful.
naive <- apply(playingDecks, 2, playNaively)
probabilistic <- apply(playingDecks, 2, playProbabilistically)
#Rprof(NULL)
nProb <- length(which(naive == 52))/size
nProbConfint <- binom.confint(x=length(which(naive == 52)), n=size, conf.level=.99, methods=c("exact"))

pProb <- length(which(probabilistic == 52))/size
pProbConfint <- binom.confint(x=length(which(probabilistic == 52)), n=size, conf.level=.99, methods=c("exact"))
pProbConfint
