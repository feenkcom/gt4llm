Class {
	#name : #GtLlmCoderViewModelProposeRenameAction,
	#superclass : #GtCoderViewModelRenameAction,
	#instVars : [
		'choices'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmCoderViewModelProposeRenameAction >> addRenameAttributes [
	| text cursorInLocation original |
	super addRenameAttributes.

	text := self pharoSourceCoderViewModel styledText
			ifNil: [ self pharoSourceCoderViewModel sourceText ].

	original := (text
			from: originalLocations first first
			to: originalLocations first last) asString.

	cursorInLocation := originalLocations
			anySatisfy: [ :each | 
				originalCursors
					anySatisfy: [ :eachCursor | eachCursor position between: each first - 1 and: each last ] ].

	originalLocations
		do: [ :each | 
			| attribute |
			(cursorInLocation not
				or: [ originalCursors
						anySatisfy: [ :eachCursor | eachCursor position between: each first - 1 and: each last ] ])
				ifTrue: [ attribute := GtProposeRenamesAttribute new
							renameAction: self;
							original: original;
							possibilities: self choices.
					coderAttributes
						add: (self pharoSourceCoderViewModel
								addTextAttribute: attribute
								from: each first
								to: each last) ].
			cursorInLocation := true ]
]

{ #category : #accessing }
GtLlmCoderViewModelProposeRenameAction >> choices [
	^ choices
]

{ #category : #accessing }
GtLlmCoderViewModelProposeRenameAction >> choices: anObject [
	choices := anObject
]

{ #category : #'as yet unclassified' }
GtLlmCoderViewModelProposeRenameAction >> updateCompleteName: aString [
	^ self updateName: aString
]
