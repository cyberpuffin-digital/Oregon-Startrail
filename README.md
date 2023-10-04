# Oregon Startrail

Earth's most goodest sciencey-types have stumbled across the solution to over population and limited resources:  Shoot them into deep space.  Brilliant!

You are one of the fortunate few that gets to stay awake during the voyage to provide the necessary human touch to shuttling frozen bodies through the cosmose.

Reach each waypoint to earch money and replenish supplies.  Can you make your ship self-sufficient and reach the planet where you can settle?  Or will you, like so many before you, get stranded in the frigid embrace of entropy?

Good luck brave explorer!

## Instructions

**Make sure to supply your ship before departing earth**

1) Trade at each waypoint to gather the necessary resources for the next leg of the trip
2) Monitor resources (Air, Energy, Food, Fuel, and Water) to keep your humans alive, see Resource table below
3) Reach Wolf1061c
4) Begin a new settlement


## Resources
### LDJam Notes

* Quick-fix: "Use Fuel" button added to take place of workstations (below) until Space Dock implemented.
* Bug: Resource calculations are not completely balanced of fully functional.  This affects energy, plants, space, and waste at least.
* Not implemented: Workstations didn't get enabled at all

### Table

| Resource | Description | Consumers | Producers |
| -------- | ----------- | --------- | --------- |
| Air | 78% Nitrogen, 21% Oxygen, 1% Other.  Good ol' Earth atmosphere. | Human | Plant, "Use Fuel" button |
| Bot | Worker bots that perform necessary ship functions: maintaining cryopods, cleaning waste, running the ship. | | |
| Cryopod | The biodiversity necessary to create a sustaining population that won't die out of inbreeding.... again... hopefully... | | |
| Energy | Fundamental force of nature we've tricked into doing our work. | Bot, Cryopod | Human, "Use Fuel" button |
| Fish | Edible aquatic animals that help process waste and help plants grow. | Human | |
| Food | Processed plant and animal matter; combined with synthetic aminos, vitamins and minerals.  Everything the body needs. | Human | Fish, ~~Plant~~ |
| Fuel | Dark matter.  Each pound of it weighs over then thousand pounds. | Travel, "Use Fuel" button | |
| Human | Carbon-based life "running" the show.  Backup units found in cryopods.  Warning: Starting a settlement with too few human will adversely affect biodiversity. | | |
| Plant | Mostly inanimate carbon-based life that likes to show-off with graphic displays of propagation.  Goes well with fish matter. | Human | |
| Waste | Everyone poos, except ~~you~~ the bots.  Makes for good backup fertilizer. | Fish | Fish, Human |
| Water | H2O?  Never touch the stuff.  Fish %#*^ in it. | Fish, Human, Plant | "Use Fuel" button|
| Work | Maintaining the ship and keeping things clean requires effort.  | Cryopod | Bot, Human |

## Workstations
## Fishery

A dedicate space for fish to live and reproduce.

### Effects

Fish production is increased

## Hydroponic

A dedicated space for plants to grow and reproduce.

### Effects

Plant production is increased

## Aquaponic

Combination Fishery and Hydroponic.

### Effects

Each fish that has a plant to nibble on will produce more and consume less, while the plant will grow better for the pruning and nutrients provided by fish waste.

Each fish or plant that doesn't have a companion will perform slightly worse than if it were in a dedicated fishery or Hydroponics workstation.

# Ludum Dare 54

Oregon Startrail started out as a Compo entry for Ludum Dare 54, with a theme of "Limited Space".

## Known issues with LD entry

* Trade system doesn't account for player's inventory, effects selling.
* UI/UX is very confusing (text-heavy and little to no highlighting).
* Resource consumption balance is very off balance
* Inventory space is not calculating correctly

## LD entry's missing features

* Space dock for upgrading the ship
* Messages tab for log of events
* Random travel events

## Tools and Resources used for LDJam

* [Godot 4.1.1-stable](https://godotengine.org/)
* [Gimp 2.1](https://www.gimp.org/)
* [Open Dyslexic 3](https://opendyslexic.org/)
* [Kawkab Mono](https://makkuk.com/kawkab-mono/)
* [Droid Sans](https://www.fontsquirrel.com/fonts/droid-sans)

## LD entry - how to win (SPOILERS)

<details>
<summary>How to beat LDJam 54 entry</summary>
The balance of the LDJam entry is off and workstations are not yet implemented.  As a result I tossed in a "Use Fuel" button to make water, oxygen, and energy at the cost of a unit of fuel.  This is slightly less unbalanced, though still nerfed.

Buy as much fuel and food as you can afford / store from earth.  Burn a few units right away (or 20, space limits aren't calculating correctly anyway).

As you travel, burn another unit of fuel if Air, Energy, or Water gets low.

Enjoy your new settlement.
</details>
