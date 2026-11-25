"
I am a trait for examples about method references and tools on methods that a class gets from a trait. I define #traitMethod and, on my class side, #classTraitMethod. See GtLExampleTraitUser and GtLExampleComposedTraitUser.
"
Trait {
	#name : #TGtLExampleTrait,
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #examples }
TGtLExampleTrait classSide >> classTraitMethod [
	^ 43
]

{ #category : #examples }
TGtLExampleTrait >> traitMethod [
	^ 42
]
