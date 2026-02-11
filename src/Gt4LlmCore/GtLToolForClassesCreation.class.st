Class {
	#name : #GtLToolForClassesCreation,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassesCreation class >> leJsonV4Name [
	^ #gtLToolForClassesCreation
]

{ #category : #visiting }
GtLToolForClassesCreation >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassesCreation: self
]

{ #category : #private }
GtLToolForClassesCreation >> classResultFromDescriptor: descriptor [
	| classNameValue classNameString classNameSymbol superclassValue superclassName superclass instanceVariables classVariables packageValue packageName createdClass |
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
	packageValue := descriptor at: 'package' ifAbsent: [ '' ].
	packageName := packageValue ifNil: [ '' ].
	packageName := packageName asString trimBoth.
	packageName isEmpty
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
			receiverName: self name;
			arguments: descriptor;
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

{ #category : #accessing }
GtLToolForClassesCreation >> description [
	^ 'Creates multiple classes in a single request and reports each result.'
]

{ #category : #accessing }
GtLToolForClassesCreation >> functionResponse [
	| classSchema |
	classSchema := {'type' -> 'object'.
		'properties' -> {
			'className' -> {'type' -> 'string'} asDictionary.
			'superclassName' -> {'type' -> 'string'} asDictionary.
			'instanceVariables' -> {'type' -> 'string'} asDictionary.
			'classVariables' -> {'type' -> 'string'} asDictionary.
			'package' -> {'type' -> 'string'} asDictionary
		} asDictionary.
		'required' -> #('className' 'superclassName' 'instanceVariables' 'classVariables' 'package').
		'additionalProperties' -> false
	} asDictionary.
	^ {'name' -> self name.
		'type' -> self type.
		'description' -> self description.
		'parameters' -> {
			'type' -> 'object'.
			'properties' -> {
				'classes' -> {
					'type' -> 'array'.
					'items' -> classSchema
				} asDictionary
			} asDictionary.
			'required' -> #('classes').
			'additionalProperties' -> false
		} asDictionary.
		'strict' -> true
	} asDictionary
]

{ #category : #accessing }
GtLToolForClassesCreation >> name [
	^ 'createClasses'
]

{ #category : #accessing }
GtLToolForClassesCreation >> parameters [
	^ #('classes')
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
	classesArgument isArray
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
