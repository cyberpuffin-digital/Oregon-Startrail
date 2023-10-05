# Oregon Startrail

Earth's most goodest sciencey-types have stumbled across the solution to over population and limited resources:  Shoot them into deep space.  Brilliant!

You are one of the fortunate few that gets to stay awake during the voyage to provide the necessary human touch to shuttling frozen bodies through the cosmose.

Reach each waypoint to earch money and replenish supplies.  Can you make Star Wagon self-sufficient and reach the planet where you can settle?  Or will you, like so many before you, get stranded in the frigid embrace of entropy?

Good luck brave explorer!

## Guide

* **Trade** for the resources needed to keep the crew alive.
* Upgrade Star Wagon to better utilize resources.
* Travel between waypoints until a habitable planet is found.
* Start a new settlement, see how many generations it lasts.

## Biodiversity

The new settlement is going to need a diverse source of genetics to persist the generations.  A [Minimum Viable Population](https://en.wikipedia.org/wiki/Minimum_viable_population) value is hard to pin down for many reasons, not least of which is the randomness of genetics and unexpected external factors.  But all American studies agree "more is betterer!"

Reach your destination with as many living humans as you can to maximize the survival chances of your new colony.

## Resources

| Resource | Description | Consumers | Producers |
| -------- | ----------- | --------- | --------- |
| Air | 78% Nitrogen, 21% Oxygen, 1% Other.  Good ol' Earth atmosphere. | Human | Hydroponic, Oxygen Generator, Plant |
| Bot | Worker bots that perform necessary ship functions: maintaining cryopods, cleaning waste, piloting Star Wagon, etc ... | | Bot Bench |
| Cryopod | The biodiversity necessary to create a sustaining population that won't die out of inbreeding.... again... hopefully... | | |
| Energy | Fundamental force of nature we've tricked into doing our work. | Bot, Bot Bench, Cryopod, Fishery, Hydroponic, Oxygen Generator, Water Generator | Fusion Generator, Human |
| Fish | Edible aquatic animals that help process waste and help plants grow. | Human | Aquaponic, Fishery |
| Food | Processed plant and animal matter; combined with synthetic aminos, vitamins and minerals.  Everything the body needs. | Human | Aquaponic, Fish, Fishery, Hydroponic, Plant |
| Fuel | Dark matter.  Each pound of it weighs over then thousand pounds. | Travel, Fusion Generator | Recycling |
| Human | Carbon-based life "running" the show.  Backup units found in cryopods.  Warning: Starting a settlement with too few human will adversely affect biodiversity. | | |
| Money | Root of all evil | Traders | Workers |
| Plant | Alternative carbon-based life that form symbiotic waste consumption / production cycle with humans. | Human | Aquaponic, Hydroponic |
| Spare Parts | Random pile of junk that usually spits out the part or component needed for repairs. | Bot bench, Repairs |
| Waste | Everyone poos, except ~~you~~ bots.  Makes for good backup fertilizer. | Aquaponics, Fish, Fishery, Hydroponic, Plant | Fish, Human, Plant |
| Water | H2O?  Never touch the stuff.  Fish %#(^ in it. | Fish, Fishery, Human, Hydroponic, Plant | Recycling, Water Generator |
| Work | Maintenance and upkeep requires effort.  | Bot Bench, Cryopod, Fishery, Hydroponic,  | Bot, Human |

## Star Wagon

A modest upgrade from the canvased-covered caravans of the wild west, Star Wagon is an Earth-made vessel designed to land on a habitable planet and seed a new settlement.

### Details
| Detail | Description | Effect |
| --------- | ----------- | ------ |
| Energy capacity | Bot refrigerator. |
| Space available | Room for resources. |

### Upgrades
#### Components
| Component | Description | Effect |
| --------- | ----------- | ------ |
| Battery | Energy storage device. | Increases energy capacity. |

#### Generators

| Generator | Description | Consumes | Produces |
| -------- | ----------- | --------- | --------- |
| Fusion | GENERATOR SMASH ... atoms for energy. | Fuel | Energy |
| Oxygen | Angry pixies that produce Earth-standard air. | Energy | Air |
| Water | Once you've got a handle on the O, H should come along easily. | Energy | Water |

#### Workstations

| Workstation | Description | Effect |
| -------- | ----------- | --------- |
| Aquaponic | Combined Fishery and Hydroponic, best of both worlds. | Increases fish and plant production while reducing water consumption and decreasing waste production, based on efficiency. |
| Bot Bench | Combine spare parts and broken bots to make new bots. | Produces bots. |
| Fishery | Place for fish to live and thrive. | Increases fish production based on efficiency. |
| Hydroponic | Space for plants to be processed.  | Increases plant production based on efficiency. |
| Recycling | Waste not want not.  Put everything in the soup and we'll see what we get out. | Processes waste into water and tiny amounts of fuel. |

# Ludum Dare 54

Oregon Startrail started out as a Compo entry for Ludum Dare 54, with a theme of "Limited Space".

## LDJam Notes

* Quick-fix: "Use Fuel" button added to take place of workstations (below) until Space Dock implemented.
* Bug: Resource calculations are not completely balanced of fully functional.  This affects energy, plants, space, and waste at least.
* Not implemented: Workstations didn't get enabled at all


## Known issues with LD entry

* Trade system doesn't account for player's inventory, effects selling.
* UI/UX is very confusing (text-heavy and little to no highlighting).
* Resource consumption balance is very off balance
* Inventory space is not calculating correctly

## LD entry's missing features

* Space dock for upgrading the Star Wagon
* Messages tab for log of events
* Random travel events

## Tools and Resources used for LDJam

* [Godot 4.1.1-stable](https://godotengine.org/)
* [Gimp 2.1](https://www.gimp.org/)
* [Open Dyslexic 3](https://opendyslexic.org/)
* [Kawkab Mono](https://makkuk.com/kawkab-mono/)
* [Droid Sans](https://www.fontsquirrel.com/fonts/droid-sans)
* [Google translate](https://translate.google.com)

## LD entry - how to win (SPOILERS)

<details>
<summary>How to beat LDJam 54 entry</summary>
The balance of the LDJam entry is off and workstations are not yet implemented.  As a result I tossed in a "Use Fuel" button to make water, oxygen, and energy at the cost of a unit of fuel.  This is slightly less unbalanced, though still nerfed.

Buy as much fuel and food as you can afford / store from earth.  Burn a few units right away (or 20, space limits aren't calculating correctly anyway).

As you travel, burn another unit of fuel if Air, Energy, or Water gets low.

Enjoy your new settlement.
</details>
