"
I use TGtLExampleTrait, with #aliasedTraitMethod as an alias of #traitMethod, so that examples can ask for methods that I get from a trait instead of defining them.
"
Class {
	#name : #GtLExampleTraitUser,
	#superclass : #Object,
	#traits : 'TGtLExampleTrait @ {#aliasedTraitMethod->#traitMethod}',
	#classTraits : 'TGtLExampleTrait classTrait',
	#category : #'Gt4LlmCore-Examples-Support'
}
