Extension { #name : #RBAddClassChange }

{ #category : #'*Gt4LlmCore' }
RBAddClassChange >> gtLlmChangeKind [
	"The kind is computed against the current image, so it should be asked before the change is applied"

	^ self changeClass isNil ifTrue: [ 'added class' ] ifFalse: [ 'changed class' ]
]

{ #category : #'*Gt4LlmCore' }
RBAddClassChange >> gtLlmClassSlotNames [
	^ builder ifNil: [ #() ] ifNotNil: [ self classInstanceVariableNames ]
]

{ #category : #'*Gt4LlmCore' }
RBAddClassChange >> gtLlmDefinitionPrinter [
	"A fluid definition from Trait defines a trait"

	| aSuperclassName |
	aSuperclassName := self superclassName.
	^ GtLClassDefinitionPrinter new
		className: self changeClassName;
		superclassName: aSuperclassName;
		isTrait: (aSuperclassName notNil and: [ aSuperclassName asString = 'Trait' ]);
		traitCompositionString: self gtLlmTraitCompositionString;
		slotNames: self instanceVariableNames;
		classVariableNames: self classVariableNames;
		classSlotNames: self gtLlmClassSlotNames;
		tagName: self tag;
		packageName: self package;
		yourself
]

{ #category : #'*Gt4LlmCore' }
RBAddClassChange >> gtLlmNewChangeEntry [
	"The new definition is the new source of the entry"

	^ GtLRefactoringClassChangeEntry new
		className: self changeClassName asString;
		yourself
]

{ #category : #'*Gt4LlmCore' }
RBAddClassChange >> gtLlmNewSource [
	"The definition of the added class, in the form of the definitions of applied refactorings"

	^ self gtLlmDefinitionPrinter definitionString
]

{ #category : #'*Gt4LlmCore' }
RBAddClassChange >> gtLlmTraitCompositionString [
	"The trait composition, such as TFoo + TBar, or {} without traits"

	| aComposition |
	builder ifNil: [ ^ '{}' ].
	aComposition := self traitComposition.
	(aComposition isNil or: [ aComposition isEmpty ]) ifTrue: [ ^ '{}' ].
	^ aComposition asTraitComposition printString
]
