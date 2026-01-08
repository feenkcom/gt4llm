Class {
	#name : #GtLToolForClassCreation,
	#superclass : #GtLAbstractFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLToolForClassCreation class >> leJsonV4Name [
	^ #gtLToolForClassCreation
]

{ #category : #visiting }
GtLToolForClassCreation >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassCreation: self
]

{ #category : #accessing }
GtLToolForClassCreation >> description [
	^ 'Creates a class with the provided superclass, variables, and package.'
]

{ #category : #accessing }
GtLToolForClassCreation >> name [
	^ 'createClass'
]

{ #category : #accessing }
GtLToolForClassCreation >> parameters [
	^ #('className' 'superclassName' 'instanceVariables' 'classVariables' 'package')
]

{ #category : #private }
GtLToolForClassCreation >> privatePerformToolCall: aToolCall [
	| arguments classNameValue classNameString classNameSymbol superclassValue superclassName superclass instanceVariables classVariables packageValue packageName createdClass |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	classNameValue := arguments at: 'className' ifAbsent: [ ^ 'Class name not provided' ].
	classNameString := classNameValue asString trimBoth.
	classNameString isEmpty ifTrue: [ ^ 'Class name not provided' ].
	classNameSymbol := classNameString asSymbol.
	(Smalltalk globals includesKey: classNameSymbol)
		ifTrue: [ ^ 'Class already exists' ].
	superclassValue := arguments at: 'superclassName' ifAbsent: [ ^ 'Superclass name not provided' ].
	superclassName := superclassValue asString trimBoth.
	superclassName isEmpty ifTrue: [ ^ 'Superclass name not provided' ].
	superclass := Smalltalk globals
		at: superclassName asSymbol
		ifAbsent: [ ^ 'Superclass not found' ].
	instanceVariables := self stringFromVariableNames: (arguments at: 'instanceVariables' ifAbsent: [ '' ]).
	classVariables := self stringFromVariableNames: (arguments at: 'classVariables' ifAbsent: [ '' ]).
	packageValue := arguments at: 'package' ifAbsent: [ '' ].
	packageName := packageValue ifNil: [ '' ].
	packageName := packageName asString trimBoth.
	packageName isEmpty ifTrue: [ ^ 'Package name not provided' ].
	createdClass := [
		superclass
			subclass: classNameSymbol
			instanceVariableNames: instanceVariables
			classVariableNames: classVariables
			package: packageName ]
		on: Error
		do: [ :error | ^ 'Class creation error: '
				, ((error respondsTo: #messageText)
					ifTrue: [ error messageText ifNil: [ error description ] ]
					ifFalse: [ error description ]) ].
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'Class created: ';
			nextPutAll: createdClass name ]
]

{ #category : #private }
GtLToolForClassCreation >> stringFromVariableNames: variableInput [
	| names namesSize stringValue |
	variableInput ifNil: [ ^ '' ].
	(variableInput isString or: [ variableInput isSymbol ])
		ifTrue: [ ^ variableInput asString trimBoth ].
	(variableInput respondsTo: #asArray)
		ifTrue: [
			names := variableInput asArray
				collect: [ :each | (each ifNil: [ '' ]) asString trimBoth ].
			names := names reject: [ :each | each isEmpty ].
			names isEmpty ifTrue: [ ^ '' ].
			namesSize := names size.
			^ String streamContents: [ :stream |
				names withIndexDo: [ :each :index |
					stream nextPutAll: each.
					index < namesSize ifTrue: [ stream space ] ] ] ].
	stringValue := variableInput asString trimBoth.
	^ stringValue
]
