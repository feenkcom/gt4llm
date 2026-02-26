Class {
	#name : #GtLToolForClassesCreation,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #visiting }
GtLToolForClassesCreation >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassesCreation: self
]

{ #category : #private }
GtLToolForClassesCreation >> classResultFromDescriptor: descriptor [
	| classNameValue classNameString classNameSymbol superclassValue superclassName superclass instanceVariables classVariables traitCompositionValue traitCompositionString packageValue packageName commentValue commentString createdClass |
	classNameValue := descriptor
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: descriptor;
					missingArgument: 'className' ].
	classNameString := classNameValue asString trimBoth.
	classNameString isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: descriptor;
				missingArgument: 'className' ].
	classNameSymbol := classNameString asSymbol.
	(Smalltalk globals includesKey: classNameSymbol)
		ifTrue: [ ^ GtLUnexpectedDomainObject new objectName: classNameString ].
	superclassValue := descriptor
			at: 'superclassName'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: descriptor;
					missingArgument: 'superclassName' ].
	superclassName := superclassValue asString trimBoth.
	superclassName isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: descriptor;
				missingArgument: 'superclassName' ].
	superclass := Smalltalk globals
			at: superclassName asSymbol
			ifAbsent: [ ^ GtLMissingDomainObject new objectName: superclassName ].
	instanceVariables := self
			stringFromVariableNames: (descriptor at: 'instanceVariables' ifAbsent: [ '' ]).
	classVariables := self
			stringFromVariableNames: (descriptor at: 'classVariables' ifAbsent: [ '' ]).
	traitCompositionValue := descriptor
			at: 'traitCompositionString'
			ifAbsent: [ nil ].
	traitCompositionString := traitCompositionValue
			ifNil: [ Behavior traitCompositionString ].
	traitCompositionString := traitCompositionString asString trimBoth.
	traitCompositionString isEmpty
		ifTrue: [ traitCompositionString := Behavior traitCompositionString ].
	packageValue := descriptor at: 'package' ifAbsent: [ '' ].
	packageName := packageValue ifNil: [ '' ].
	packageName := packageName asString trimBoth.
	packageName isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: descriptor;
				missingArgument: 'package' ].
	commentValue := descriptor at: 'comment' ifAbsent: [ nil ].
	commentString := commentValue ifNil: [ nil ] ifNotNil: [ commentValue asString trimBoth ].
	(commentString notNil and: [ commentString isEmpty ]) ifTrue: [ commentString := nil ].
	createdClass := [ superclass classInstaller
			make: [ :builder | 
				builder
					superclass: superclass;
					name: classNameSymbol;
					slotsFromString: instanceVariables;
					sharedVariablesFromString: classVariables;
					traitComposition: (self class compiler evaluate: traitCompositionString);
					package: packageName;
					comment: commentString;
					environment: superclass environment ] ]
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
		originalTraitCompositionString: traitCompositionString;
		yourself
]

{ #category : #private }
GtLToolForClassesCreation >> classResultsFrom: classesArgument ifInvalid: invalidBlock [
	| results incorrectItems |
	results := OrderedCollection new: classesArgument size.
	incorrectItems := OrderedCollection new.
	classesArgument do: [ :eachDescriptor |
		eachDescriptor isDictionary
			ifFalse: [ incorrectItems add: eachDescriptor ]
			ifTrue: [ results add: (self classResultFromDescriptor: eachDescriptor) ] ].
	incorrectItems isEmpty ifFalse: [ ^ invalidBlock value: incorrectItems ].
	^ results asArray
]

{ #category : #private }
GtLToolForClassesCreation >> classesListJsonSchemaDictionary [
	| classSchema |
	classSchema := {'type' -> 'object'.
			'properties'
				-> {'className' -> {'type' -> 'string'} asDictionary.
						'superclassName' -> {'type' -> 'string'} asDictionary.
						'instanceVariables' -> {'type' -> 'string'} asDictionary.
						'classVariables' -> {'type' -> 'string'} asDictionary.
						'traitCompositionString' -> {'type' -> 'string'} asDictionary.
						'package' -> {'type' -> 'string'} asDictionary.
						'comment' -> {'type' -> 'string'} asDictionary} asDictionary.
			'required'
				-> #('className' 'superclassName' 'package').
			'additionalProperties' -> false} asDictionary.
	^ {'type' -> 'object'.
		'properties'
			-> {'classes'
						-> {'type' -> 'array'.
								'items' -> classSchema} asDictionary} asDictionary.
		'required' -> #('classes').
		'additionalProperties' -> false} asDictionary
]

{ #category : #accessing }
GtLToolForClassesCreation >> description [
	^ 'Creates multiple classes in a single request and reports each result.'
]

{ #category : #accessing }
GtLToolForClassesCreation >> name [
	^ 'createClasses'
]

{ #category : #private }
GtLToolForClassesCreation >> parametersDescription [
	^ GtLResponseJsonSchemaFormat new
			name: 'Parameters'; 
			schemaDictionary: self classesListJsonSchemaDictionary
]

{ #category : #private }
GtLToolForClassesCreation >> privatePerformToolCall: aToolCall [
	| arguments classesArgument classes |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	classesArgument := arguments
		at: 'classes'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: arguments;
			missingArgument: 'classes' ].
	(classesArgument isCollection and: [classesArgument isString not ])
		ifFalse: [ ^ GtLIncorrectArgumentValueDomainObject new
			argumentName: 'classes';
			argumentValue: classesArgument;
			expectedArgumentValueKind: Array ].
	classes := self
		classResultsFrom: classesArgument
		ifInvalid: [ :incorrectItems |
			^ GtLIncorrectArgumentArrayItemDomainObject new
				argumentName: 'classes';
				argumentValue: classesArgument;
				expectedItemKind: Dictionary;
				incorrectItems: incorrectItems ].
	^ GtLClassesCreationDomainObject new classes: classes
]

{ #category : #private }
GtLToolForClassesCreation >> stringFromVariableNames: variableInput [
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
