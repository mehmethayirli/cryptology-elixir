# The Project Maxwell
Elixir New Orderbook [Maxwell]

* You can follow this tutorial to create a simple **orderbook** using **Elixir**.

## Installation

1. Create a new Elixir project using the `mix new orderbook` command.
2. Add the following package to your `deps` file:

``elixir
{:gen_server, "~> 2.0"}``

## Docs

![maxwell](https://github.com/mehmethayirli/cryptology-elixir/assets/158029357/a4f61175-52db-47f2-a690-5ed2dfa4e7a3)

Elixir runs the the orderbook near-equivalent of **Uniswap v2's x*y=k** formula: LPs have a very similar risk/return profile to AMM LPs

Market makers have two primary concerns: inventory risk and quoting an optimal bid-ask spread.

Avellaneda & Stoikov famously calculated a model to address these concerns, developing a formula for both an ideal reserve price and an ideal bid-ask spread. Avellaneda Stoikov is simple, and can be thought of as the orderbook near equivalent of Uniswap v2's x*y=k formula: its LPs have a very similar risk/return profile to Uniswap v2 LPs.

Elixir uses a custom variation of Avellaneda & Stoikov's algorithm for deploying liquidity across decentralized exchange orderbooks. 

Before we dive in to these formulas, it is important to understand what is being referred to when we mention "reserve price."

The simplest form of market making sets bids and asks at an equal distance from market price. A pure market making strategy can work well in sideways markets, but it will almost certainly lead to a skewed inventory during strong directional trends.

Avellaneda & Stoikov's reserve price formula (seen below) attempts to thwart this concern, re-engineering the market price the market maker uses to set its bid-ask spread.

```r(s,t)=s−qγσ2(T−t)```
```r(s,t)=s−qγσ2(T−t)```

​
* ```s = current market price (between bids and asks)```

* ```q = quantity base asset / units to desired asset target```

* ```σ = volatility```

* ```T = closing time```

* ```t = current time (T is normalized = 1, so t is a time fraction)```

* ```δa, δb = bid/ask spread```

* ```δa=δb = symmetrical spread```

* ```γ = inventory risk parameter```

* ```κ = order book liquidity parameter```

This formula allows for the network to determine how far the current inventory is from the target inventory, and adjust the bids and asks accordingly (with bids closer to mid, and asks farther away, or vice versa). This way, liquidity gets deployed on both sides of the orderbook, but the maker won't encounter a large asset inventory imbalance if the asset's price begins trending in one direction.

In the legend seen above, 
q,γ and (T-t)
 are all customizable inputs, where the maker can determine the targeted base asset inventory, set an inventory risk parameter (to ensure that asset balance maintains consistency), and set for trading times (which is likely to be set to 1 for infinite market making within the 24/7 crypto markets.)

For creating an optimal bid-ask spread, Avellaneda & Stoikov developed a formula that determines the orderbook's density to set a benchmark price from which the bid and ask order spread will be set.

```δa+δb=γσ2(T−t)+ln(1+γ/κ)```
```δa+δb=γσ2(T−t)+ln(1+γ/κ)```

In the above formula, 
```κ```
 represents the orderbook liquidity parameter, with the liquidity of a specific book being indicated by a higher value for this variable. The spread is correlated to the value of 
```κ```, as thicker order books generally have tighter spreads while thinner ones generally have larger ones.

In practice, this strategy completed a few key steps to deploy orderbook liquidity. First, using the reserve price formula mentioned above, the strategy calculates an ideal market price to use based on what the inventory target the user sets is. Then, it calculates the optimal bid-ask spread of a pair depending on the book's depth, and finally begins placing bids and asks based on the spread.

More information about the performance and practice of this strategy can be found within Stanford's "Optimal High-Frequency Market Making" by Takahiro Fushimi, Christian Gonzalez Rojas, and Molly Herman (2018).

Given that our network is fully transparent, building resilience against outside players is crucial to protect against gamification of the algorithm used to build orderbooks via Elixir. Read Preventing Gamification for more insights into this.


