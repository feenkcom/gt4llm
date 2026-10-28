"
Magritte-based tool for creating a single class.
"
Class {
	#name : #GtLMagritteToolForClassCreation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForClassCreation >> classCreationRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #classCreationRequest;
		classes: { GtLClassCreationRequest };
		beRequired
]

{ #category : #private }
GtLMagritteToolForClassCreation >> createClassFromRequest: aRequest [
	<gsCode: '	| className superclassName superclass packageName traitComposition variables createdClass description |
	(aRequest isKindOf: GtLTraitCreationRequest)
		ifTrue: [ ^ GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait creation'' ].
	className := (aRequest targetClassName ifNil: [ '''' ]) asString trimBoth.
	className isEmpty ifTrue: [ ^ GtLMissingDomainObject new objectName: ''targetClassName'' ].
	(GsSession currentSession objectNamed: className asSymbol) notNil
		ifTrue: [ ^ GtLUnexpectedDomainObject new objectName: className ].
	superclassName := (aRequest superclassName ifNil: [ '''' ]) asString trimBoth.
	superclassName = ''Trait''
		ifTrue: [ ^ GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait creation'' ].
	superclassName isEmpty ifTrue: [ ^ GtLMissingDomainObject new objectName: ''superclassName'' ].
	superclass := GsSession currentSession objectNamed: superclassName asSymbol.
	superclass ifNil: [ ^ GtLMissingDomainObject new objectName: superclassName ].
	packageName := (aRequest package ifNil: [ '''' ]) asString trimBoth.
	packageName isEmpty ifTrue: [ ^ GtLMissingDomainObject new objectName: ''package'' ].
	traitComposition := (aRequest traitCompositionString ifNil: [ '''' ]) asString trimBoth.
	(traitComposition isEmpty or: [ traitComposition = ''{}'' ]) ifFalse: [
		^ GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait composition'' ].
	variables := [ :value | value ifNil: [ #() ] ifNotNil: [
		value isString
			ifTrue: [ value asString subStrings ]
			ifFalse: [ value collect: [ :each | each asString ] ] ] ].
	[
		createdClass := superclass
			subclass: className asSymbol
			instVarNames: (variables value: aRequest instanceVariables)
			classVars: (variables value: aRequest classVariables)
			classInstVars: (variables value: aRequest classInstanceVariables)
			poolDictionaries: #()
			category: packageName
			inDictionary: System myUserProfile symbolList first
			options: #().
		ClassOrganizer gtDefault addClass: createdClass.
		aRequest comment ifNotNil: [ :comment | createdClass comment: comment asString trimBoth ].
		description := GtLClassDefinitionDescription new
			currentClassName: createdClass name asString;
			superclassName: superclass name asString;
			comment: createdClass comment;
			packageName: createdClass category;
			packageTagName: nil;
			instanceSlotNames: (createdClass instVarNames collect: [ :each | each asString ]);
			classSlotNames: (createdClass class instVarNames collect: [ :each | each asString ]);
			classVariableNames: (createdClass classVarNames collect: [ :each | each asString ]);
			traitCompositionString: ''{}'';
			yourself
	] on: Error do: [ :error | ^ GtLProblemDomainObject new errorMessage: error description ].
	^ GtLClassModificationResult new
		originalClass: nil;
		updatedClass: description;
		yourself'>
	"Create a class from a request. Returns a GtLClassModificationResult or an error domain object.
	This method is reused by GtLMagritteToolForClassesCreation."
	| extractor |
	
	extractor := GtLClassCreationDataExtractor new.
	extractor request: aRequest.
	
	extractor extractAllIfError: [ :anError | ^ anError ].
	^ self createClassUsing: extractor ifError: [ :anError | ^ anError ]
]

{ #category : #'private - creation' }
GtLMagritteToolForClassCreation >> createClassUsing: extractor ifError: errorBlock [
	| createdClass |
	createdClass := [ extractor superclass classInstaller
			make: [ :builder | 
				builder
					superclass: extractor superclass;
					name: extractor targetClassName;
					slots: extractor instanceVariables;
					classSlots: extractor classInstanceVariables;
					sharedVariables: extractor classVariables;
					traitComposition: extractor traitComposition;
					package: extractor packageName;
					tag: extractor packageTagName;
					comment: extractor comment;
					environment: extractor superclass environment.

				(extractor superclass = Trait or: extractor superclass isTrait)
					ifTrue: [ builder beTrait ] ] ]
			on: Error
			do: [ :error | 
				^ errorBlock
					value: (GtLCouldNotCreateClassDomainObject new
							superclass: extractor superclass;
							targetClassName: extractor targetClassName;
							packageName: extractor packageName;
							packageTagName: extractor packageTagName;
							instanceVariableNames: (extractor instanceVariables collect: #name) asArray;
							classVariableNames: (extractor classVariables collect: #name) asArray;
							freeze: error) ].

	^ GtLClassModificationResult new
		originalClass: nil;
		updatedClass: (GtLClassDefinitionDescription fromClass: createdClass);
		yourself
]

{ #category : #accessing }
GtLMagritteToolForClassCreation >> description [
	^ 'Creates a single class with the provided superclass, variables, traits, and package.

Example JSON arguments:
{
  "classCreationRequest": {
    "targetClassName": "MyClass",
    "superclassName": "Object",
    "package": "MyPackage",
    "packageTag": "MyTag",
    "instanceVariables": "slot1 slot2",
    "classVariables": "SharedValue",
    "traitCompositionString": "{}",
    "comment": "A description of the class"
  }
}

Example JSON response:
{
  "currentClassName": "MyClass",
  "superclassName": "Object",
  "packageName": "MyPackage",
  "instanceSlotNames": ["slot1", "slot2"],
  "classSlotNames": [],
  "classVariableNames": ["SharedValue"],
  "traitCompositionString": "{}",
  "comment": "A description of the class"
}'
]

{ #category : #accessing }
GtLMagritteToolForClassCreation >> name [
	^ 'createClass'
]

{ #category : #private }
GtLMagritteToolForClassCreation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| request |
	request := aToolCall arguments at: 'classCreationRequest'.
	^ self createClassFromRequest: request
]
