Class {
	#name : #GtLToolForClassCreation,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
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
GtLToolForClassCreation >> parametersDescription [
	^ #('className' 'superclassName' 'instanceVariables' 'classVariables' 'package')
]

{ #category : #private }
GtLToolForClassCreation >> privatePerformToolCall: aToolCall [
	| arguments classNameValue classNameString classNameSymbol superclassValue superclassName superclass instanceVariables classVariables packageValue packageName createdClass |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	classNameValue := arguments
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: aToolCall arguments;
					missingArgument: 'className' ].
	classNameString := classNameValue asString trimBoth.
	classNameString isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: aToolCall arguments;
				missingArgument: 'className' ].
	classNameSymbol := classNameString asSymbol.
	(Smalltalk globals includesKey: classNameSymbol)
		ifTrue: [ ^ GtLUnexpectedDomainObject new objectName: classNameString ].
	superclassValue := arguments
			at: 'superclassName'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: aToolCall arguments;
					missingArgument: 'superclassName' ].
	superclassName := superclassValue asString trimBoth.
	superclassName isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: aToolCall arguments;
				missingArgument: 'superclassName' ].
	superclass := Smalltalk globals
			at: superclassName asSymbol
			ifAbsent: [ ^ GtLMissingDomainObject new objectName: superclassName ].
	instanceVariables := self
			stringFromVariableNames: (arguments at: 'instanceVariables' ifAbsent: [ '' ]).
	classVariables := self
			stringFromVariableNames: (arguments at: 'classVariables' ifAbsent: [ '' ]).
	packageValue := arguments at: 'package' ifAbsent: [ '' ].
	packageName := packageValue ifNil: [ '' ].
	packageName := packageName asString trimBoth.
	packageName isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: aToolCall arguments;
				missingArgument: 'package' ].
	createdClass := [ superclass
			subclass: classNameSymbol
			instanceVariableNames: instanceVariables
			classVariableNames: classVariables
			package: packageName ]
			on: Error
			do: [ :error | 
				^ GtLCouldNotCreateClassDomainObject new
					superclass: superclass;
					targetClassName: classNameString;
					packageName: packageName;
					instanceVariableNames: instanceVariables;
					classVariableNames: classVariables;
					freeze: error ].
	^ GtLClassDomainObject new
		foundClass: createdClass;
		originalClassName: classNameString;
		originalSuperclassName: superclassName;
		originalPackageName: packageName;
		originalInstanceVariableNames: instanceVariables;
		originalClassVariableNames: classVariables;
		yourself
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
