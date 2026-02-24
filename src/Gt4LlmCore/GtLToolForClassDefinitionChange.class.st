Class {
	#name : #GtLToolForClassDefinitionChange,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #visiting }
GtLToolForClassDefinitionChange >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassSignatureChange: self
]

{ #category : #accessing }
GtLToolForClassDefinitionChange >> description [
	^ 'Changes a class signature by updating superclass, instance variables, class variables, and package.'
]

{ #category : #accessing }
GtLToolForClassDefinitionChange >> name [
	^ 'changeClassSignature'
]

{ #category : #accessing }
GtLToolForClassDefinitionChange >> parametersDescription [
	^ #('className' 'superclassName' 'instanceVariables' 'classVariables' 'package')
]

{ #category : #private }
GtLToolForClassDefinitionChange >> privatePerformToolCall: aToolCall [
	| arguments classNameValue classNameString classNameSymbol targetClass superclassValue superclassName superclass instanceVariables classVariables packageValue packageName updatedClass builder |
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
	targetClass := Smalltalk globals
		at: classNameSymbol
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: classNameString ].
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
	updatedClass := [
		builder := ShiftClassBuilder new.
		builder fillFor: targetClass.
		builder superclass: superclass.
		builder slotsFromString: instanceVariables.
		builder sharedVariablesFromString: classVariables.
		builder package: packageName.
		builder install ]
		on: Error
		do: [ :error |
			^ GtLExceptionDomainObject new
				freeze: error;
				description: 'Error while changing class signature';
				yourself ].
	^ GtLClassDomainObject new
		foundClass: updatedClass;
		originalClassName: classNameString;
		originalSuperclassName: superclassName;
		originalPackageName: packageName;
		originalInstanceVariableNames: instanceVariables;
		originalClassVariableNames: classVariables;
		originalTraitCompositionString: updatedClass traitCompositionString;
		yourself
]

{ #category : #private }
GtLToolForClassDefinitionChange >> stringFromVariableNames: variableInput [
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
