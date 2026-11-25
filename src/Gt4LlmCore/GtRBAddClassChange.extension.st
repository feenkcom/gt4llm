Extension { #name : #GtRBAddClassChange }

{ #category : #'*Gt4LlmCore' }
GtRBAddClassChange >> gtLlmClassSlotNames [
	^ self hasClassSlots
		ifTrue: [ self classInstanceVariableNames ]
		ifFalse: [ #() ]
]

{ #category : #'*Gt4LlmCore' }
GtRBAddClassChange >> gtLlmTraitCompositionString [
	"The trait composition written in my definition string (uses: or traits:), as I do not keep it"

	| ast |
	definitionString ifNil: [ ^ super gtLlmTraitCompositionString ].
	ast := RBParser
			parseExpression: definitionString
			onError: [ :aMessage :aPosition | ^ '{}' ].
	ast
		nodesDo: [ :each | 
			each isMessage
				ifTrue: [ each keywords
						with: each arguments
						do: [ :aKeyword :anArgument | 
							(aKeyword = 'uses:' or: [ aKeyword = 'traits:' ])
								ifTrue: [ ^ ((anArgument isDynamicArray and: [ anArgument statements isEmpty ])
										or: [ anArgument isLiteralArray and: [ anArgument value isEmpty ] ])
										ifTrue: [ '{}' ]
										ifFalse: [ anArgument formattedCode ] ] ] ] ].
	^ '{}'
]
