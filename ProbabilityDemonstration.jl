### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 6849541c-7059-11ef-00fa-4162e4aa1296
using PlutoUI, LaTeXStrings

# ╔═╡ 9f3fcf7e-7c3b-4a2f-8ac7-066c91a58b58
using Images: download, load

# ╔═╡ 03a12b64-75fc-4500-a7c2-d1008e336a92
using Random, DataFrames, StatsBase, CSV, Distributions

# ╔═╡ fb980c21-ddb5-45dc-b2fc-e3ad4d0b7d8a
md"""
# 1. Probability

How can we find the likelihood that a certain event will happen? For example, if I flip a coin, how could we calculate the chance of it coming up Heads?

!!! info "Calculing the Probability of an Event"
	The probability than an event `A` occurs is
	```math
		P(A) = \frac{\text{\# ways } A \text{ can happen}}{\text{\# of all possible events}}
	```
So in the case of a coin, what's the probability of flipping Heads? Well, there's only one way to get Heads. But either Heads *or* Tails could come up.
```math
	P(\text{Heads}) = \frac{\text{\# of ways to get Heads}}{\text{\# of possible results from flipping the coin}} = \frac{1}{2} = 0.5
```
There's a 50% chance that I'll flip a Heads. Let's use this idea with a sligthly more complicated coin-flipping game.
"""

# ╔═╡ 0dd16c15-14fe-4cc2-9715-4d7b17ed1395
md"""
## Coin Flip Game

Let's play a game. The game has two rounds.

First round: You call heads or tails. I'll flip a coin and write down the result.

Second round: I'll flip the coin again, but this time you have to call the opposite value of the first round. (E.g., if you first called "Heads", on the second round you call "Tails".)

After this, we go to scoring.
- If your call succeeds on both flips, you win, and I give you \$5! 
- If your call does not succeed on both flips, I win and I get \$5!
"""

# ╔═╡ 6f2b4f7e-713e-457f-8b92-afaf073d5afb
md"""
### Round 1

#### Make your first call!
"""

# ╔═╡ e33ba075-2c75-46df-8249-a8b7516ab3e5
@bind FirstCall Select(["Heads", "Tails"])

# ╔═╡ 1a6bd81b-7745-403c-917f-0f28c1653caa
md"""
#### Alright, let's do the first coin flip.
"""

# ╔═╡ 2146c469-39f9-43c5-a74c-b085c1391679
@bind flip1 Button("First coin flip")

# ╔═╡ e39f21d7-ec57-415f-ab0d-2b175254e159
md"""
### Round 2
#### You make the complementary call. Let's flip!
"""

# ╔═╡ 7bcb419d-4a4e-4ccd-bcde-e132c1371879
@bind flip2 Button("Second coin flip")

# ╔═╡ c97da7d2-6549-4646-b500-a16213a86afe
md"""
### Scoring
#### Let's calculate the scores!
"""

# ╔═╡ 1c9505ad-f560-4767-868e-b9524798b80a
md"""
## Calculating the Probability

How would we calculate the probability? Why not play this game a bunch of times and see how often you win and how often I win?

Let's run the trials.
"""

# ╔═╡ 01af4e82-4837-495b-ad92-8b79b1789494
@bind NumTrials NumberField(0:10^6,default=10^3)

# ╔═╡ 5e0b3f7b-15db-410e-90aa-9621d7965ea4
md"""
You only win if your calls are correct on both flips. Let's say you call Heads and then Tails. We want to find out the probability that you're right.

Observe that there's only one way to get Heads and then Tails. But what are all the possibilities that can result from flipping a coin twice?

- Heads, Heads
- Heads, Tails
- Tails, Heads
- Tails, Tails

Let's calculate the probability of getting Heads and Tails, then.

```math
	P(\text{Heads} \cap \text{Tails}) = \frac{1}{4} = 0.25
```

Notice that the results from the simulation are pretty close to this! So if you win only 25% of the time, that must mean I win 75% of the time! (Why? Hint: think of the complement.) Is this a game you should keep playing?
"""

# ╔═╡ e6d1e564-b67f-4432-99c3-fb3fbecec69c
md"""
Let's do another example to keep practicing this idea of calculating the probability of an event.
"""

# ╔═╡ c7c2dea0-b11b-419e-93ce-bddddae31f63
md"""
## Monty Hall Problem

You're on a game show and you are presented with 3 doors. Behind one door is a brand new car, behind another door is nothing, and behind the third door is a goat. You don't know which is which. The game is split into two rounds.

1. Pick a door. (Let's say you pick door 1.)
2. A door is opened (Door 2 or 3 is opened.)
3. You are allowed to change your choice; do you want to open another door?
4. All doors are opened

Is it better to change doors? Or keep your original choice?
"""

# ╔═╡ 05d03c7a-921a-454c-83e5-f3b67fbf7c9d
md"""
## Calculating the probability

Let's try to answer this question by playing the game a bunch of times and find the proportion of wins. This is the same as finding the probability that we win.
"""

# ╔═╡ bf17c06a-5322-48ce-bd42-9272992c463e
@bind MontyHallTrials NumberField(0:10^6, default=1000)

# ╔═╡ dd7e8762-bb05-43ea-8b89-7e3c8a85b295
md"""
Now, this is just a simulation. We haven't *proven* that the probability of winning when switching your choice is `\approx 2/3'. How can you prove this? (Hint: Write out a table of all possible outcomes. How many times do you win?)

If you're stuck, here are some resources.

- [Wikipedia](https://en.wikipedia.org/wiki/Monty_Hall_problem)
- [Original solution proposed by S. Selvin (1975)](https://www.jstor.org/stable/2683689)
"""

# ╔═╡ 3c272358-5da7-48eb-a6d7-e37262e6defa
md"""
# 3. Conditional Probabilities
Let's recall the defintion of a conditional probability.

!!! info "Conditional Probabilities"
	The **conditional probablity** of an event `A` occurring given event `B` is

	```math
		P(A | B) = \frac{P(A \cap B)}{P(B)}
	```

Let's use this idea to predict the likelihood of heart disease as it relates to age of a patient.
"""

# ╔═╡ 04c83e04-e3cb-4b5f-9ef0-86a5e5d2392e
md"""
## Predicting Heart Disease: The Data

In the table below, we have data from a sample of patients which includes the following information:

1. Age (29-77)
2. How many patients have heart disease
3. How many patients do not have heart disease
4. Total number of patients at that age

The second table includes the totals of positive heart disease cases, negative heart disease cases, that the sample size.

[NOTE: This data has been adapted from [source](https://www.kaggle.com/datasets/rishidamarla/heart-disease-prediction).]
"""

# ╔═╡ 852988d5-cfe1-4726-adba-673760270a94
md"""
## Predicting Heart Disease: Calculating Probabilities

> 1. Given that a randomly selected patient is 55 years old, what is the probability that they have heart disease?
"""

# ╔═╡ fdd2120c-2bfb-4e7c-9464-920be5956f71
md"""
```math
P(\text{Heart Disease} = \text{true} | \text{Age} = 55) = \frac{P(\text{Heart Disease} = \text{true} \cap \text{Age} = 55)}{P(\text{Age} = 55)}
```
```math
 = \frac{4/270}{6/270} = 0.67
```
"""

# ╔═╡ b567828b-c543-494d-86b7-2bd83de655f8
md"""
> 2. Randomly sample an age from the sample. What is the probability that a person does *not* have heart disease, given their age?
"""

# ╔═╡ f861302c-5c7c-4937-b008-9fbb04afcbd5
@bind PatientSample Button("Take a random sample from age data")

# ╔═╡ acd33b2e-3778-441d-8a9e-d17885b56d4f
md"""
##### 3. Given that a patient has heart disease, what is the probability that they are 62 years old?
"""

# ╔═╡ 0354dcb7-04b2-45d8-89f6-5eff16a30de4
L"""
	P(\text{Age} = 62 | \text{Heart Disease} = \text{true}) = \frac{P(\text{Age} = 62 \cap \text{Heart Disease} = \text{true})}{P(\text{Heart Disease} = \text{true})}
"""

# ╔═╡ efa1c659-00eb-4fe5-832a-555b1e9c1411
L"""
	= \frac{7/270}{120/270} = 0.058
"""

# ╔═╡ 5168a78f-236e-4a5c-b02d-6e80c72eb3c5
md"""
# 4. Independent Probabilities

## The Multiplication Law
Remember our definition for conditional probabilities?
```math
	P(A|B) = \frac{P(A \cap B)}{P(B)}
```

If we multiply both sides by `P(B)`, we actually have an equation for finding the *joint* probability of `A` and `B`.

!!! info "Multiplication Law"
	The joint probability ``P(A \cap B)`` is the following.
	```math
		P(A \cap B) = P(A|B)P(B)
	```

It turns out that this observation will be useful when we talk about **independent probabilities**.

## Independent Events
Intuitively, we'd like two events `A` and `B` to be independent if the outcome of `A` does not affect the outcome of `B` and vice versa. For example, getting Heads on a coin flip and the fact that it's raining outside are indendent events: rain doesn't make it any more or less likely that I get a Heads on a coin flip.

How do we define independence more rigorously? Well, there are a couple of equivalent definitions for two events to be **independent**.

!!! info "Independence"
	1. `P(A|B) = P(A)` or `P(B|A) = P(B)`

	2. We can also use the multiplication law. The multiplication law says
	```math
		P(A \cap B) = P(A|B)P(B)
	```
	But by Defintion 1, we know that `P(A|B) = P(A)`. Let's plug this into the multiplication law.

	```math
		P(A\cap B) = P(A) P(B)
	```

We can use either of these defintion to test if two events `A` and `B` are independent! Cool, right?
"""

# ╔═╡ 1cc3eca0-b86a-47dd-8d7a-4786e3c01e11
md"""
Let's practice this idea of independence with another street-hustling game, this time with marbles.
"""

# ╔═╡ f4363c9d-c450-4e48-af17-a7c6d70b0848
md"""
## Marble Game

The Street Hustler is back with another game to hustle you out of your hard-earned dollars. This time, I've got a bag of marbles. Inside of the bag, there are red, blue, and yellow marbles. Here's the distribution of marbles.

Red: 5 marbles

Blue: 6 marbles

Yellow: 3 marbles

Here's the game.

1. We both bet \$5.
2. You call what color marble I'm going to pull out of the bag. We'll write down the result.
3. I'll put the marble back, and you call a *different* color. I'll pull out another marble and write down the result.
4. Scoring:

	- If you are correct on both pulls, you get all $10 in the pot

	- If you are correct only on the first pull, you get $3 back

	- If you are correct only on the second pull, I get $3 back

	- If you are wrong on both pulls, I get all $10
"""

# ╔═╡ a78583fc-a62a-499f-8407-b2a2ea738136
md"""
#### Make your first call!
"""

# ╔═╡ 4918242d-ad87-4e3a-b6a4-0ca5a9b6878a
@bind FirstMarbleCall Select(["Red", "Blue", "Yellow"])

# ╔═╡ 32a96c44-528d-46c8-a956-9922f0d5175a
@bind FirstMarble Button("First marble from the bag")

# ╔═╡ ff1be402-f40b-4180-9bb5-9434d12b03ba
md"""
#### Make your second call! Remember, it has to be different from your first call.
"""

# ╔═╡ 0af3b6f8-df1c-4ee8-a6c2-46b3485155b6
@bind SecondMarbleCall Select(["Red","Blue","Yellow"])

# ╔═╡ e4262628-49bb-4fd9-a006-285f64c1900a
@bind SecondMarble Button("Second marble from the bag")

# ╔═╡ 108ae1e6-e38b-401e-a4d0-a66990540511
md"""
#### Calculating probabilities for the Marble Game
"""

# ╔═╡ 8c9cbad3-88e9-4642-a357-b1b725c26e84
Marble_df = DataFrame([5 6 3 14],["# Red";"# Blue";"# Yellow";"Total"])

# ╔═╡ 117469e7-95fa-4234-8cb6-e0fcb791f90a
md"""
##### 1. What's the probability of the first pull being your first call: $(FirstMarbleCall)?
"""

# ╔═╡ 3ded2fef-af6a-4c9e-a151-a9c90ad41b0c
md"""
##### 3. What is the probability that you'll be correct on both pulls?
"""

# ╔═╡ 8baf5a65-4497-445c-9d78-02cef09306e7
L"""
	P(\text{First Pull} = \text{%$(FirstMarbleCall)} \cap \text{Second Pull} = \text{%$(SecondMarbleCall)})
"""

# ╔═╡ 7aecc382-f026-4c07-88c1-9dbbf50dc110
L"""
	= P(\text{First Pull} = \text{%$(FirstMarbleCall)}) P(\text{Second Pull} = \text{%$(SecondMarbleCall)})
"""

# ╔═╡ 07128f6b-4435-47be-9d47-9e0e73639036
md"""
Notice that the probability of losing is the complement.
"""

# ╔═╡ ff7e1a5b-3074-4523-9177-37142b7ccfde
md"""
Is this a game you want to keep playing? Probably not! I'm going to win most of the time!
"""

# ╔═╡ 966bf9a9-c82c-4f4e-bcf2-bda2af3a0653
md"""
# Code Appendix

Don't worry about me.
"""

# ╔═╡ 7169d5b1-1677-4538-9ce9-2f2f980dc4dc
if SecondMarbleCall == "Red"
	numerator2 = 5
elseif SecondMarbleCall == "Blue"
	numerator2 = 6
elseif SecondMarbleCall == "Yellow"
	numerator2 = 3
end;

# ╔═╡ 79111809-93fc-4f85-b936-b02306139c0e
decimal2 = round(numerator2/14,digits=2);

# ╔═╡ 203e2921-d9c7-40fc-9f30-165b51bc1bb7
L"""
	= P(\text{Second Pull} = %$(SecondMarbleCall)) = \frac{%$(numerator2)}{14} = %$(decimal2)
"""

# ╔═╡ 32e24d45-9cd7-4763-8f24-1008eaeea3a1
begin
	num_red = 5
	num_blue = 6
	num_yellow = 3
end;

# ╔═╡ aa895e05-ca82-49e1-b816-1dc15befee0f
if FirstMarbleCall == "Red"
	numerator = 5
elseif FirstMarbleCall == "Blue"
	numerator = 6
elseif FirstMarbleCall == "Yellow"
	numerator = 3
end;

# ╔═╡ 1a2bd89a-526e-4d9a-b28a-4f1372c22209
L"""
	\frac{%$(numerator)}{14} \cdot \frac{%$(numerator2)}{14} = \frac{%$(numerator*numerator2)}{%$(14*14)} = %$(round((numerator*numerator2)/14^2,digits=2))
"""

# ╔═╡ bbddfae0-09d7-4f93-a064-7c5b2dd45412
L"""
	P(\text{Losing}) = 1 - \frac{%$(numerator*numerator2)}{%$(14*14)} = \frac{%$(196-(numerator*numerator2))}{196} = %$(round((196-numerator*numerator2)/196,digits=2))
"""

# ╔═╡ da0c0c66-0f9f-41d7-a0e3-09166c9a28b4
decimal = round(numerator/14,digits=2);

# ╔═╡ 3603b7b1-985d-4c21-a82b-7a07733368b9
L"""
	P(\text{Marble Color} = \text{%$(FirstMarbleCall)}) = \frac{%$(numerator)}{14} = %$(decimal)
"""

# ╔═╡ 46fe7f34-be94-4873-b7be-66c5da884c9c
# Load picture of red marble
RedMarblePicture = let
	image = download("https://i.imgur.com/aMvMCVu.jpeg")
	load(image)
end;

# ╔═╡ 4af8ff80-5dc6-4e6c-a67e-070cf00b41e4
BlueMarblePicture = let
	image = download("https://i.imgur.com/uexfWLP.jpeg")
	load(image)
end;

# ╔═╡ ccd33e97-d461-40e4-9332-009f24f31545
YellowMarblePicture = let
	image = download("https://i.imgur.com/z29q7EJ.jpeg")
	load(image)
end;

# ╔═╡ f6ba4b94-e499-457f-88ee-53f67b0653a7
function MarbleScoring(bag_pull_result1, bag_pull_result2, FirstMarbleCall, SecondMarbleCall)
	if bag_pull_result1 == FirstMarbleCall && bag_pull_result2 == SecondMarbleCall
		return "Your calls were correct on both pulls! You win \$10!"
	elseif bag_pull_result1 == FirstMarbleCall && bag_pull_result2 != SecondMarbleCall
		return "Only your first call was correct. You get \$3 back!"
	elseif bag_pull_result1 != FirstMarbleCall && bag_pull_result2 == SecondMarbleCall
		return "Only your second call was correct. I get \$3 back!"
	elseif bag_pull_result1 != FirstMarbleCall && bag_pull_result2 != SecondMarbleCall
		return "Neither call was correct. I win \$10!"
	end
end;

# ╔═╡ 6d55c867-6a70-40b0-b3e1-f9a5272ceec5
function PullFromBag()
	ω = weights([5/14; 6/14; 3/14])
	Marbles = ["Red"; "Blue"; "Yellow"]
	sample(Marbles, ω)
end;

# ╔═╡ c9d3cfc1-b33c-45b3-923e-2c436cde1dd6
FirstPull = let
	FirstMarble
	PullFromBag()
end;

# ╔═╡ d02a00a2-6ff7-4ec0-8afa-34eebc7b5363
md"""
##### 2. What's the probability that the second marble will be your second call, $(SecondMarbleCall), given that the first pull was $(FirstPull)?
"""

# ╔═╡ cae4f0d6-df9b-4626-b180-a38191505463
L"""
	P(\text{Second Pull} = \text{%$(SecondMarbleCall)}|\text{First Pull} = \text{%$(FirstPull)}) = \frac{P(\text{Second Pull} = \text{%$(SecondMarbleCall)} \cap \text{First Pull} = \text{%$(FirstPull)})}{P(\text{First Pull} = \text{%$(FirstPull)})}
"""

# ╔═╡ 54ab948b-36b0-4af7-bf01-8920a9d079b2
L"""
	= \frac{P(\text{Second Pull} = \text{%$(SecondMarbleCall)}) P(\text{First Pull} = \text{%$(FirstPull)})}{P(\text{First Pull} = \text{%$(FirstPull)})}
"""

# ╔═╡ a12f06f2-b92e-4ac9-a925-79dee4b2419a
SecondPull = let
	SecondMarble
	PullFromBag()
end;

# ╔═╡ dfa6becf-1597-494c-ad78-c80f6fd39021
MarbleScoring(FirstPull, SecondPull, FirstMarbleCall, SecondMarbleCall)

# ╔═╡ 9edd2684-7afb-43e9-b4d2-1b76a451b4f5
function PictureOfMarble(bag_pull_result)
	if bag_pull_result == "Red"
		return RedMarblePicture
	elseif bag_pull_result == "Blue"
		return BlueMarblePicture
	elseif bag_pull_result == "Yellow"
		return YellowMarblePicture
	end
end;

# ╔═╡ 5b190ded-d9fc-4a87-bdaa-7f6c5226a67f
begin
	println("I'M DRAWING THE FIRST MARBLE FROM THE BAG...")
	sleep(1)
	PictureOfMarble(FirstPull)
end

# ╔═╡ 61e09cad-8632-4e23-a4a0-1d6cfe1c20a5
begin
	println("I'VE PUT THE FIRST MARBLE BACK AND I'M DRAWING THE SECOND ONE...")
	sleep(1)
	PictureOfMarble(SecondPull)
end

# ╔═╡ dcb9c754-5aca-4776-9e11-7543d02525ff
function ReturnData(age,Data)
	return filter(:Age => n -> n == age,Data)
end;

# ╔═╡ 804d70ca-16e4-45c4-ac24-ad87fcd5a864
df₀ = DataFrame(CSV.File("/home/pdc/Desktop/Teaching/Clemson_Fall_2024/ProbabilityDemos/Heart_Disease_Prediction.csv"));

# ╔═╡ 90a1fb67-5366-45ad-89dd-8a6e6490f57c
df = df₀[:,[:Age, :Sex, :BP, :HeartDisease]];

# ╔═╡ f80d5819-2852-4597-a8b9-629f8ca90743
df_aggregate = let
	PossibleAges = sort(unique(df.Age))
	Data = DataFrame(Array{Float64}(undef,0,4),["Age";"Positive_HD";"Negative_HD";"Total"])
	for i = PossibleAges
		current_data = filter(:Age => n -> n == i, df)
		age = i
		num_hd = sum(current_data.HeartDisease)
		num_no_hd = size(current_data,1) - num_hd
		total = size(current_data,1)
		push!(Data, [age num_hd num_no_hd total])
	end
	Data
end

# ╔═╡ e98b5e4e-eafa-4a76-a986-e2be1dd13c80
describe(df_aggregate)

# ╔═╡ c219eb04-bc64-4e01-b086-078cc95e5542
df_totals = let
	total_positive = sum(df_aggregate.Positive_HD)
	total_negative = sum(df_aggregate.Negative_HD)
	total_cases = sum(df_aggregate.Total)
	Data = DataFrame([total_positive total_negative total_cases],["Total_Positive"; "Total_Negative"; "Total_Cases"])
end

# ╔═╡ 3266bf28-c201-4a39-b339-6ab7f87350f5
df_totals

# ╔═╡ bfa6240e-3b69-4155-9e63-12f81c9e70c4
begin
	PatientSample
	df_totals
end

# ╔═╡ 1a257425-3837-4a48-91ae-d7f321e6a1e9
df_totals

# ╔═╡ d72be4b1-8f1f-4815-9b89-69c9372f75a8
ReturnData(55,df_aggregate)

# ╔═╡ fabe186c-ede6-42a7-950c-42c9f7f76720
ReturnData(62, df_aggregate)

# ╔═╡ e637c579-3472-40b6-baeb-d31e131921d8
sample_weights = let
	PossibleAges = df_aggregate.Age
	TotalAges = size(PossibleAges,1)
	ω = Array{Float64}(undef,TotalAges,1)
	for i = 1:TotalAges
		ω[i] = df_aggregate.Total[i]
	end
	ω = (1/df_totals.Total_Cases[1]).*ω
	weights(ω)
end;

# ╔═╡ fd2149c3-1696-465f-a63d-5aa1bd50ba0c
Patient_Age = let
	PatientSample
	sample(df_aggregate.Age, sample_weights)
end

# ╔═╡ c941b6b7-1d1f-47ab-8909-cba4b455454f
AgeSampleData = let
	PatientSample
	ReturnData(Patient_Age,df_aggregate)
end

# ╔═╡ d368d649-658b-44d7-9c1a-5a6717824d2a
HeartDiseaseRandomSampleProbability = let
	val = (AgeSampleData.Negative_HD[1]/270)/(AgeSampleData.Total[1]/270)
end;

# ╔═╡ 53960d6a-fd80-4f63-9ccc-8fc06353b2b0
L"""
	= \frac{%$(AgeSampleData.Negative_HD[1])/270}{%$(AgeSampleData.Total[1])/270}\\
	
	= %$(round(HeartDiseaseRandomSampleProbability,digits=2))
"""

# ╔═╡ d3723242-b6f7-4e31-8325-bb6b1eaff425
L"""

	P(\text{Heart Disease} = \text{false} | \text{Age} = %$(Patient_Age)) = \frac{P(\text{Heart Disease} = \text{false} \cap \text{Age} = %$(Patient_Age))}{P(\text{Age} = %$(Patient_Age))}

"""

# ╔═╡ 769b2b4b-81b9-4831-9931-fecc894beccc
TableOfContents()

# ╔═╡ d781916f-a481-43b0-ac67-3e449e064152
# Load picture of Heads
HeadsPicture = let
	image = download("https://i.imgur.com/v8zBILD.png")
	load(image)
end;

# ╔═╡ 7d001ab6-cd1f-45e6-a25f-a14c7bc5d121
# Load picture of Tails
TailsPicture = let
	image = download("https://i.imgur.com/963ZahF.png")
	load(image)
end;

# ╔═╡ cdf3d953-e2fb-455b-bf1d-fa0cc07296b4
function DisplayCoinPicture(coinflip)
	return coinflip.picture
end;

# ╔═╡ f0b33f07-cd45-436b-a3b6-5e428b256011
function DisplayCoinResult(coinflip,round)
	if coinflip.flip_result == true && FirstCall == "Heads"
		return "You've won round $round"
	elseif coinflip.flip_result == true && FirstCall == "Tails"
		return "You've lost round $round"
	elseif coinflip.flip_result == false && FirstCall == "Heads"
		return "You've lost round $round"
	elseif coinflip.flip_result == false && FirstCall == "Tails"
		return "You've won round $round"
	end
	#return coinflip.flip_result
end;

# ╔═╡ 83a3f1af-c17d-4fd7-bcae-b713cfa81db0
function DisplayCoin(call)
	if call == "Heads"
		return HeadsPicture
	elseif call == "Tails"
		return TailsPicture
	end
end;

# ╔═╡ 3a6c0fd3-2f87-4a82-bd7d-7544fd5b4c13
function Scoring(Call,Flip1,Flip2)
	if Call == "Heads" && Flip1.flip_name == "Heads" && Flip2.flip_name == "Tails"
		student_score = 5
		my_score = 0
	elseif Call == "Tails" && Flip1.flip_name == "Tails" && Flip2.flip_name == "Heads"
		student_score = 5
		my_score = 0
	else
		student_score = 0
		my_score = 5
	end
	return "Your score is $student_score and my score is $my_score"
end;

# ╔═╡ 854b6dea-32ec-4319-abe4-430a143fe9b9
struct Coin
	flip_result::Bool
	flip_name::String
	picture
end;

# ╔═╡ 5e8ab254-0a27-4015-a1a9-44ade21fc6d7
function CoinFlip()
	dist = Bernoulli()
	flip = rand(dist)
	if flip == true
		result = Coin(flip,"Heads",HeadsPicture)
		return result
	elseif flip == false
		result = Coin(flip,"Tails",TailsPicture)
		return result
	end
end;

# ╔═╡ 347605f1-4236-4206-9d7e-5524b1042439
Flip1 = let
	flip1
	CoinFlip()
end;

# ╔═╡ 8e6a8843-02b5-44b9-9c17-cca29cc37771
DisplayCoinPicture(Flip1)

# ╔═╡ 47e94ab7-cb8c-455c-8b63-9e5c45e29269
Flip2 = let
	flip2
	CoinFlip()
end;

# ╔═╡ 824488ee-1aea-48d1-a72d-3ed4053076aa
DisplayCoinPicture(Flip2)

# ╔═╡ 20d8cd54-b29e-44d6-a428-1bf30931873c
Scoring(FirstCall,Flip1,Flip2)

# ╔═╡ 501563c6-caf1-4327-b072-a03db1810783
function CoinFlip_Simulation_TailsHeads(trials)
	dist = Bernoulli()
	students_wins = 0
	my_wins = 0
	for i = 1:trials
		flip1 = rand(dist)
		flip2 = rand(dist)
		if flip1 == false && flip2 == true
			students_wins += 1
		else
			my_wins += 1
		end
	end
	#student_result = "Proportion of your wins to all flips: $(students_wins/trials)"
	#my_result = "Proportion of my wins to all flips: $(my_wins/trials)"
	#[student_result; my_result]
	println("Call Tails then Heads.")
	println("Proportion of your wins to all flips: $(students_wins/trials)")
	println("Proportion of my wins to all flips: $(my_wins/trials)")
end;

# ╔═╡ 3b777ac2-3342-45e3-bf5d-15eef677bfd0
CoinFlip_Simulation_TailsHeads(NumTrials)

# ╔═╡ cd33400f-03e6-418e-a5e7-39d004bc31e4
function CoinFlip_Simulation_HeadsTails(trials)
	dist = Bernoulli()
	students_wins = 0
	my_wins = 0
	for i = 1:trials
		flip1 = rand(dist)
		flip2 = rand(dist)
		if flip1 == true && flip2 == false
			students_wins += 1
		else
			my_wins += 1
		end
	end
	#student_result = "Proportion of your wins to all flips: $(students_wins/trials)"
	#my_result = "Proportion of my wins to all flips: $(my_wins/trials)"
	#[student_result; my_result]
	println("Call Heads then Tails.")
	println("Proportion of your wins to all flips: $(students_wins/trials)")
	println("Proportion of my wins to all flips: $(my_wins/trials)")
end;

# ╔═╡ 987fbed9-7956-422c-a93c-9a48d1c3ecdc
CoinFlip_Simulation_HeadsTails(NumTrials)

# ╔═╡ 3c3feec6-3a83-4b31-8d2b-c030ef6e50f4
function MontyHallSimulation_NoSwitch(trials)
	dist = Bernoulli(1/3)
	win = 0
	lose = 0
	for i = 1:trials
		# Set up doors
		door1 = "Goat"
		door2 = "Nothing"
		door3 = "Car"
		# Choose a door
		choose_door = sample([door1;door2;door3],Weights([1/3,1/3,1/3]))
		if choose_door == door3
			win += 1
		else
			lose += 1
		end
	end
	println("Probability of winning: $(win/trials)")
	println("Probability of losing: $(lose/trials)")
end;

# ╔═╡ 6452e562-8ed1-4d7d-88c8-e9aa0a599b16
MontyHallSimulation_NoSwitch(MontyHallTrials)

# ╔═╡ f057d858-4782-4de0-b841-9f3d7501bb83
function MontyHallSimulation_Switch(trials)
	dist = Bernoulli(1/3)
	win = 0
	lose = 0
	for i = 1:trials
		# Set up doors
		door1 = "Goat"
		door2 = "Nothing"
		door3 = "Car"
		# Choose a door
		first_choice_door = sample([door1;door2;door3],Weights([1/3,1/3,1/3]))
		# Door is revealed
		if first_choice_door == door1
			open_door = door2
		elseif first_choice_door == door2
			open_door = door1
		elseif first_choice_door == door3
			open_door = sample([door1;door2],Weights([1/2,1/2]))
		end
		# Change decision
		if first_choice_door == door1 && open_door == door2
			second_choice_door = door3
			win += 1
		elseif first_choice_door == door2 && open_door == door1
			second_choice_door = door3
			win += 1
		else
			lose += 1
		end
	end
	println("Probability of winning: $(win/trials)")
	println("Probability of losing: $(lose/trials)")
end;

# ╔═╡ 4c13f185-597d-47c0-8392-037bb5bacb92
MontyHallSimulation_Switch(MontyHallTrials)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
LaTeXStrings = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CSV = "~0.10.14"
DataFrames = "~1.6.1"
Distributions = "~0.25.111"
Images = "~0.26.1"
LaTeXStrings = "~1.3.1"
PlutoUI = "~0.7.60"
StatsBase = "~0.34.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.1"
manifest_format = "2.0"
project_hash = "5196ce66d9267c9be4a4dbfc0325baa472f396e0"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra"]
git-tree-sha1 = "3640d077b6dafd64ceb8fd5c1ec76f7ca53bcf76"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.16.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceSparseArraysExt = "SparseArrays"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "f21cfd4950cb9f0587d5067e69405ad2acd27b87"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.6"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "5a97e67919535d6841172016c9530fd69494e5ec"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.6"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "71acdbf594aab5bbb2cec89b208c41b4c411e49f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.24.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "05ba0d07cd4fd8b7a39541e31a7b0254704ea581"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.13"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "9ebb045901e9bbf58767a9f34ff89831ed711aae"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.7"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.CommonWorldInvalidations]]
git-tree-sha1 = "ae52d1c52048455e85a387fbee9be553ec2b68d0"
uuid = "f70d9fcc-98c5-4d4a-abd7-e4cdeebd8ca8"
version = "1.0.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "e6c693a0e4394f8fda0e51a5bdf5aef26f8235e9"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.111"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "7878ff7172a8e6beedd1dea14bd27c3c6340d361"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.22"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43ba3d3c82c18d88471cfd2924931658838c9d8f"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+4"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "ebd18c326fa6cee1efb7da9a3b45cf69da2ed4d9"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.11.2"

[[deps.HistogramThresholding]]
deps = ["ImageBase", "LinearAlgebra", "MappedArrays"]
git-tree-sha1 = "7194dfbb2f8d945abdaf68fa9480a965d6661e69"
uuid = "2c695a8d-9458-5d45-9878-1b8a99cf7853"
version = "0.3.1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "8e070b599339d622e9a081d17230d74a5c473293"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.17"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "7c4195be1649ae622304031ed46a2f4df989f1eb"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.24"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageBinarization]]
deps = ["HistogramThresholding", "ImageCore", "LinearAlgebra", "Polynomials", "Reexport", "Statistics"]
git-tree-sha1 = "f5356e7203c4a9954962e3757c08033f2efe578a"
uuid = "cbc4b850-ae4b-5111-9e64-df94c024a13d"
version = "0.3.0"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageCorners]]
deps = ["ImageCore", "ImageFiltering", "PrecompileTools", "StaticArrays", "StatsBase"]
git-tree-sha1 = "24c52de051293745a9bad7d73497708954562b79"
uuid = "89d5987c-236e-4e32-acd0-25bd6bd87b70"
version = "0.1.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "3447781d4c80dbe6d71d239f7cfb1f8049d4c84f"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.6"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "437abb322a41d527c197fa800455f79d414f0a3c"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.8"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "OpenJpeg_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "d65554bad8b16d9562050c67e7223abf91eaba2f"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.13+0"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageMorphology]]
deps = ["DataStructures", "ImageCore", "LinearAlgebra", "LoopVectorization", "OffsetArrays", "Requires", "TiledIteration"]
git-tree-sha1 = "6f0a801136cb9c229aebea0df296cdcd471dbcd1"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.4.5"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "44664eea5408828c03e5addb84fa4f916132fc26"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.1"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "e0884bdf01bbbb111aea77c348368a86fb4b5ab6"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.10.1"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageBinarization", "ImageContrastAdjustment", "ImageCore", "ImageCorners", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "12fdd617c7fe25dc4a6cc804d657cc4b2230302b"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.26.1"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0936ba688c6d201805a83da835b55c61a180db52"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.11+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.InlineStrings]]
git-tree-sha1 = "45521d31238e87ee9f9732561bfee12d4eebd52d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.2"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "10bd689145d2c3b2a9844005d01087cc1194e79e"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.2.1+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

    [deps.Interpolations.weakdeps]
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "PrecompileTools", "Requires", "TranscodingStreams"]
git-tree-sha1 = "a0746c21bdc986d0dc293efa6b1faee112c37c28"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.53"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "f389674c99bfcde17dc57454011aa44d5a260a40"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c84a835e1a09b289ffcd2271bf2a337bbdda6637"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.3+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "a9eaadb366f5493a5654e843864c13d8b107548c"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.17"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LittleCMS_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll"]
git-tree-sha1 = "fa7fd067dca76cadd880f1ca937b4f387975a9f5"
uuid = "d3a379c0-f9a3-5b72-a4c0-6bf4d2e8af0f"
version = "2.16.0+0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "8084c25a250e00ae427a379a5b607e7aed96a2dd"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.171"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "f046ccd0c6db2832a9f639e2c669c6fe867e5f4f"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "91a67b4d73842da90b526011fa85c5c4c9343fe0"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.18"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "1a27764e945a152f7ca7efa04de513d473e9542e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.1"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "8292dd5c8a38257111ada2174000a33745b06d4e"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.2.4+0"

[[deps.OpenJpeg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libtiff_jll", "LittleCMS_jll", "libpng_jll"]
git-tree-sha1 = "f4cb457ffac5f5cf695699f82c537073958a6a6c"
uuid = "643b3616-a352-519d-856d-80112ee9badc"
version = "2.5.2+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "645bed98cd47f72f67316fd42fc47dee771aefcd"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "3aa2bb4982e575acd7583f01531f241af077b163"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.13"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "66b20dd35966a748321d3b2537c4584cf40387c7"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "8f6bc219586aef8baf0ff9a5fe16ee9c70cb65e4"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.2"

[[deps.PtrArrays]]
git-tree-sha1 = "77a42d78b6a92df47ab37e177b2deac405e1c88f"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.2.1"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "1d587203cf851a51bf1ea31ad7ff89eff8d625ea"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.0"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "994cc27cdacca10e68feb291673ec3a76aa2fae9"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.6"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e60724fd3beea548353984dc61c943ecddb0e29a"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.3+0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "5680a9276685d392c87407df00d57c9924d9f11e"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.7.1"
weakdeps = ["RecipesBase"]

    [deps.Rotations.extensions]
    RotationsRecipesBaseExt = "RecipesBase"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMD]]
deps = ["PrecompileTools"]
git-tree-sha1 = "2803cab51702db743f3fda07dd1745aadfbf43bd"
uuid = "fdea26ae-647d-5447-a871-4b548cad5224"
version = "3.5.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "456f610ca2fbd1c14f5fcf31c6bfadc55e7d66e0"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.43"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "ff11acffdb082493657550959d4feb4b6149e73a"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.5"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2f5d4697f21388cbe1ff299430dd169ef97d7e14"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.4.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["CommonWorldInvalidations", "IfElse", "PrecompileTools"]
git-tree-sha1 = "87d51a3ee9a4b0d2fe054bdd3fc2436258db2603"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "1.1.1"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Static"]
git-tree-sha1 = "96381d50f1ce85f2663584c8e886a6ca97e60554"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.8.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "eeafab08ae20c62c44c8399ccb9354a04b80db50"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.7"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "SIMD", "UUIDs"]
git-tree-sha1 = "bc7fd5c91041f44636b2c134041f7e5263ce58ae"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.10.0"

[[deps.TiledIteration]]
deps = ["OffsetArrays", "StaticArrayInterface"]
git-tree-sha1 = "1176cc31e867217b06928e2f140c90bd1bc88283"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.5.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "e84b3a11b9bece70d14cce63406bbc79ed3464d2"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.2"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "e7f5b81c65eb858bed630fe006837b935518aca5"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.70"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─fb980c21-ddb5-45dc-b2fc-e3ad4d0b7d8a
# ╟─0dd16c15-14fe-4cc2-9715-4d7b17ed1395
# ╟─6f2b4f7e-713e-457f-8b92-afaf073d5afb
# ╟─e33ba075-2c75-46df-8249-a8b7516ab3e5
# ╟─1a6bd81b-7745-403c-917f-0f28c1653caa
# ╟─2146c469-39f9-43c5-a74c-b085c1391679
# ╟─347605f1-4236-4206-9d7e-5524b1042439
# ╟─8e6a8843-02b5-44b9-9c17-cca29cc37771
# ╟─e39f21d7-ec57-415f-ab0d-2b175254e159
# ╟─7bcb419d-4a4e-4ccd-bcde-e132c1371879
# ╟─47e94ab7-cb8c-455c-8b63-9e5c45e29269
# ╟─824488ee-1aea-48d1-a72d-3ed4053076aa
# ╟─c97da7d2-6549-4646-b500-a16213a86afe
# ╟─20d8cd54-b29e-44d6-a428-1bf30931873c
# ╟─1c9505ad-f560-4767-868e-b9524798b80a
# ╟─01af4e82-4837-495b-ad92-8b79b1789494
# ╟─987fbed9-7956-422c-a93c-9a48d1c3ecdc
# ╟─3b777ac2-3342-45e3-bf5d-15eef677bfd0
# ╟─5e0b3f7b-15db-410e-90aa-9621d7965ea4
# ╟─e6d1e564-b67f-4432-99c3-fb3fbecec69c
# ╟─c7c2dea0-b11b-419e-93ce-bddddae31f63
# ╟─05d03c7a-921a-454c-83e5-f3b67fbf7c9d
# ╟─bf17c06a-5322-48ce-bd42-9272992c463e
# ╠═6452e562-8ed1-4d7d-88c8-e9aa0a599b16
# ╠═4c13f185-597d-47c0-8392-037bb5bacb92
# ╟─dd7e8762-bb05-43ea-8b89-7e3c8a85b295
# ╟─3c272358-5da7-48eb-a6d7-e37262e6defa
# ╟─04c83e04-e3cb-4b5f-9ef0-86a5e5d2392e
# ╟─e98b5e4e-eafa-4a76-a986-e2be1dd13c80
# ╟─f80d5819-2852-4597-a8b9-629f8ca90743
# ╟─c219eb04-bc64-4e01-b086-078cc95e5542
# ╟─852988d5-cfe1-4726-adba-673760270a94
# ╟─d72be4b1-8f1f-4815-9b89-69c9372f75a8
# ╟─3266bf28-c201-4a39-b339-6ab7f87350f5
# ╟─fdd2120c-2bfb-4e7c-9464-920be5956f71
# ╟─b567828b-c543-494d-86b7-2bd83de655f8
# ╟─f861302c-5c7c-4937-b008-9fbb04afcbd5
# ╟─fd2149c3-1696-465f-a63d-5aa1bd50ba0c
# ╟─c941b6b7-1d1f-47ab-8909-cba4b455454f
# ╟─bfa6240e-3b69-4155-9e63-12f81c9e70c4
# ╟─d3723242-b6f7-4e31-8325-bb6b1eaff425
# ╟─53960d6a-fd80-4f63-9ccc-8fc06353b2b0
# ╟─acd33b2e-3778-441d-8a9e-d17885b56d4f
# ╟─fabe186c-ede6-42a7-950c-42c9f7f76720
# ╟─1a257425-3837-4a48-91ae-d7f321e6a1e9
# ╟─0354dcb7-04b2-45d8-89f6-5eff16a30de4
# ╟─efa1c659-00eb-4fe5-832a-555b1e9c1411
# ╟─5168a78f-236e-4a5c-b02d-6e80c72eb3c5
# ╟─1cc3eca0-b86a-47dd-8d7a-4786e3c01e11
# ╟─f4363c9d-c450-4e48-af17-a7c6d70b0848
# ╟─a78583fc-a62a-499f-8407-b2a2ea738136
# ╟─4918242d-ad87-4e3a-b6a4-0ca5a9b6878a
# ╟─32a96c44-528d-46c8-a956-9922f0d5175a
# ╟─c9d3cfc1-b33c-45b3-923e-2c436cde1dd6
# ╟─5b190ded-d9fc-4a87-bdaa-7f6c5226a67f
# ╟─ff1be402-f40b-4180-9bb5-9434d12b03ba
# ╟─0af3b6f8-df1c-4ee8-a6c2-46b3485155b6
# ╟─e4262628-49bb-4fd9-a006-285f64c1900a
# ╟─a12f06f2-b92e-4ac9-a925-79dee4b2419a
# ╟─61e09cad-8632-4e23-a4a0-1d6cfe1c20a5
# ╟─dfa6becf-1597-494c-ad78-c80f6fd39021
# ╟─108ae1e6-e38b-401e-a4d0-a66990540511
# ╟─8c9cbad3-88e9-4642-a357-b1b725c26e84
# ╟─117469e7-95fa-4234-8cb6-e0fcb791f90a
# ╟─3603b7b1-985d-4c21-a82b-7a07733368b9
# ╟─d02a00a2-6ff7-4ec0-8afa-34eebc7b5363
# ╟─cae4f0d6-df9b-4626-b180-a38191505463
# ╟─54ab948b-36b0-4af7-bf01-8920a9d079b2
# ╟─203e2921-d9c7-40fc-9f30-165b51bc1bb7
# ╟─3ded2fef-af6a-4c9e-a151-a9c90ad41b0c
# ╟─8baf5a65-4497-445c-9d78-02cef09306e7
# ╟─7aecc382-f026-4c07-88c1-9dbbf50dc110
# ╟─1a2bd89a-526e-4d9a-b28a-4f1372c22209
# ╟─07128f6b-4435-47be-9d47-9e0e73639036
# ╟─bbddfae0-09d7-4f93-a064-7c5b2dd45412
# ╟─ff7e1a5b-3074-4523-9177-37142b7ccfde
# ╟─966bf9a9-c82c-4f4e-bcf2-bda2af3a0653
# ╟─79111809-93fc-4f85-b936-b02306139c0e
# ╟─7169d5b1-1677-4538-9ce9-2f2f980dc4dc
# ╟─da0c0c66-0f9f-41d7-a0e3-09166c9a28b4
# ╟─32e24d45-9cd7-4763-8f24-1008eaeea3a1
# ╟─aa895e05-ca82-49e1-b816-1dc15befee0f
# ╠═46fe7f34-be94-4873-b7be-66c5da884c9c
# ╠═4af8ff80-5dc6-4e6c-a67e-070cf00b41e4
# ╠═ccd33e97-d461-40e4-9332-009f24f31545
# ╠═f6ba4b94-e499-457f-88ee-53f67b0653a7
# ╠═6d55c867-6a70-40b0-b3e1-f9a5272ceec5
# ╠═9edd2684-7afb-43e9-b4d2-1b76a451b4f5
# ╠═d368d649-658b-44d7-9c1a-5a6717824d2a
# ╠═e637c579-3472-40b6-baeb-d31e131921d8
# ╠═dcb9c754-5aca-4776-9e11-7543d02525ff
# ╠═804d70ca-16e4-45c4-ac24-ad87fcd5a864
# ╠═90a1fb67-5366-45ad-89dd-8a6e6490f57c
# ╠═6849541c-7059-11ef-00fa-4162e4aa1296
# ╠═9f3fcf7e-7c3b-4a2f-8ac7-066c91a58b58
# ╠═03a12b64-75fc-4500-a7c2-d1008e336a92
# ╠═769b2b4b-81b9-4831-9931-fecc894beccc
# ╠═d781916f-a481-43b0-ac67-3e449e064152
# ╠═7d001ab6-cd1f-45e6-a25f-a14c7bc5d121
# ╠═cdf3d953-e2fb-455b-bf1d-fa0cc07296b4
# ╟─f0b33f07-cd45-436b-a3b6-5e428b256011
# ╟─5e8ab254-0a27-4015-a1a9-44ade21fc6d7
# ╟─83a3f1af-c17d-4fd7-bcae-b713cfa81db0
# ╟─3a6c0fd3-2f87-4a82-bd7d-7544fd5b4c13
# ╟─854b6dea-32ec-4319-abe4-430a143fe9b9
# ╟─501563c6-caf1-4327-b072-a03db1810783
# ╟─cd33400f-03e6-418e-a5e7-39d004bc31e4
# ╟─3c3feec6-3a83-4b31-8d2b-c030ef6e50f4
# ╟─f057d858-4782-4de0-b841-9f3d7501bb83
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
