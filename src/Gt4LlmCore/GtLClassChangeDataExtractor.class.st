"
Extracts and holds intermediate data needed to change a class signature from a GtLClassChangeRequest.
"
Class {
	#name : #GtLClassChangeDataExtractor,
	#superclass : #Object,
	#instVars : [
		'request',
		'targetClass',
		'superclass',
		'instanceVariables',
		'classVariables',
		'packageName',
		'packageTagName',
		'classInstanceVariables',
		'traitComposition'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLClassChangeDataExtractor >> classInstanceVariables [
	^ classInstanceVariables
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> classInstanceVariables: aCollection [
	classInstanceVariables := aCollection
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> classVariables [
	^ classVariables
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> classVariables: aCollection [
	classVariables := aCollection
]

{ #category : #extraction }
GtLClassChangeDataExtractor >> extractAllIfError: errorBlock [
	<gsCode: ' | composition |
 self extractTargetClassIfError: [ :error | ^ errorBlock value: error ].
 self extractSuperclassIfError: [ :error | ^ errorBlock value: error ].
 composition := (request traitCompositionString ifNil: [ '''' ]) asString trimBoth.
 (composition isEmpty or: [ composition = ''{}'' ]) ifFalse: [
 ^ errorBlock value: (GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait composition'') ].
 self extractVariables.
 traitComposition := ''{}''.
 self extractPackageIfError: [ :error | ^ errorBlock value: error ].
 self extractPackageTagIfError: [ :error | ^ errorBlock value: error ]'>
	"Extract all data from the request.
	Calls errorBlock for validation errors."
	
	self extractTargetClassIfError: errorBlock.
	self extractSuperclassIfError: errorBlock.
	self extractVariables.
	self extractTraitComposition.
	self extractPackageIfError: errorBlock.
	self extractPackageTagIfError: errorBlock
]

{ #category : #extraction }
GtLClassChangeDataExtractor >> extractPackageIfError: errorBlock [
	<gsCode: ' packageName := request package ifNil: [ targetClass category ] ifNotNil: [ :value | value asString trimBoth ].
 packageName isEmpty ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: ''package'') ]'>
	"Extract the package name from the request.
	If not provided, use the current package of the target class."
	| packageValue |
	
	packageValue := request package.
	packageValue notNil
		ifTrue: [
			| pkgName |
			pkgName := packageValue asString trimBoth.
			pkgName isEmpty
				ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'package') ].
			packageName := pkgName ]
		ifFalse: [ packageName := targetClass package name ]
]

{ #category : #extraction }
GtLClassChangeDataExtractor >> extractPackageTagIfError: errorBlock [
	<gsCode: ' packageTagName := nil'>
	"Extract the package tag name from the request.
	If not provided, use the current package of the target class."

	| packageTagValue |
	packageTagValue := request packageTag.
	packageTagValue notNil
		ifTrue: [ | pkgTagName |
			pkgTagName := packageTagValue asString trimBoth.
			pkgTagName isEmpty
				ifTrue: [ packageTagName := nil ]
				ifFalse: [ packageTagName := pkgTagName ] ]
		ifFalse: [ targetClass packageTag isRoot
				ifTrue: [ packageTagName := nil ]
				ifFalse: [ packageTagName := targetClass packageTag name ] ]
]

{ #category : #extraction }
GtLClassChangeDataExtractor >> extractSuperclassIfError: errorBlock [
	<gsCode: ' | name |
 request superclassName ifNil: [ superclass := targetClass superclass. ^ self ].
 name := request superclassName asString trimBoth.
 name = ''Trait'' ifTrue: [ ^ errorBlock value: (GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait modification'') ].
 superclass := GsSession currentSession objectNamed: name asSymbol.
 superclass ifNil: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: name) ].
 (superclass isBehavior and: [ superclass isTrait not ]) ifFalse: [
 ^ errorBlock value: (GtLProblemDomainObject new errorMessage: ''Superclass must be a class; Traits are not supported in GemStone'') ]'>
	"Extract and validate the superclass from the request.
	If not provided, use the current superclass of the target class."
	| superclassValue |
	
	superclassValue := request superclassName.
	superclassValue notNil
		ifTrue: [
			| superclassName |
			superclassName := superclassValue asString trimBoth.
			superclassName isEmpty
				ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new 
					objectName: 'superclassName') ].
			superclass := Smalltalk globals
				at: superclassName asSymbol
				ifAbsent: [ ^ errorBlock value: (GtLMissingDomainObject new
					objectName: superclassName) ] ]
		ifFalse: [
			superclass := targetClass superclass ]
]

{ #category : #extraction }
GtLClassChangeDataExtractor >> extractTargetClassIfError: errorBlock [
	<gsCode: ' | name |
 name := (request targetClassName ifNil: [ '''' ]) asString trimBoth.
 name isEmpty ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: ''targetClassName'') ].
 name = ''Trait'' ifTrue: [ ^ errorBlock value: (GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait modification'') ].
 targetClass := GsSession currentSession objectNamed: name asSymbol.
 targetClass ifNil: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: name) ].
 targetClass isBehavior ifFalse: [ ^ errorBlock value: (GtLProblemDomainObject new errorMessage: ''Target must be a class'') ].
 targetClass isTrait ifTrue: [ ^ errorBlock value: (GtLProblemDomainObject new errorMessage: ''GemStone does not support Trait modification'') ]'>
	"Extract and validate the target class from the request."
	| classNameValue classNameString |
	
	classNameValue := request targetClassName.
	classNameString := (classNameValue ifNil: [ '' ]) asString trimBoth.
	classNameString isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'targetClassName') ].
	
	targetClass := Smalltalk globals
		at: classNameString asSymbol
		ifAbsent: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: classNameString) ]
]

{ #category : #extraction }
GtLClassChangeDataExtractor >> extractTraitComposition [
	"Extract the trait composition from the request."

	traitComposition := request traitCompositionString
			ifNil: [ targetClass traitComposition copyTraitExpression ]
			ifNotNil: [ :aString | 
				| traitCompositionString |
				traitCompositionString := aString asString trimBoth.
				traitCompositionString isEmpty
					ifTrue: [ targetClass traitComposition copyTraitExpression ]
					ifFalse: [ targetClass compiler evaluate: traitCompositionString ] ]
]

{ #category : #extraction }
GtLClassChangeDataExtractor >> extractVariables [
	<gsCode: ' instanceVariables := request instanceVariables notEmpty
 ifTrue: [ request instanceVariables collect: #asString ]
 ifFalse: [ targetClass instVarNames collect: #asString ].
 classInstanceVariables := request classInstanceVariables notEmpty
 ifTrue: [ request classInstanceVariables collect: #asString ]
 ifFalse: [ targetClass class instVarNames collect: #asString ].
 classVariables := request classVariables notEmpty
 ifTrue: [ request classVariables collect: #asString ]
 ifFalse: [ targetClass classVarNames collect: #asString ]'>
	"Extract instance and class variables from the request.
	If not provided, use the current variables of the target class."
	
	instanceVariables := request instanceVariables notEmpty
		ifTrue: [ request instanceVariables collect: [ :each | each asSymbol asSlot ] ]
		ifFalse: [ targetClass localSlots collect: [ :slot | slot copy ] ].
	
	classInstanceVariables := request classInstanceVariables notEmpty
		ifTrue: [ request classInstanceVariables collect: [ :each | each asSymbol asSlot ] ]
		ifFalse: [ targetClass classSide localSlots collect: [ :slot | slot copy ] ].
	
	classVariables := request classVariables notEmpty
		ifTrue: [ request classVariables collect: [ :each | each asSymbol asClassVariable ] ]
		ifFalse: [ targetClass classVariables collect: [ :var | var copy ] ]
]

{ #category : #views }
GtLClassChangeDataExtractor >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ {'Request' -> request.
				'Target class' -> targetClass.
				'Superclass' -> superclass.
				'Instance slots' -> instanceVariables.
				'Class slots' -> classInstanceVariables.
				'Class variables' -> classVariables.
				'Package name' -> packageName.
				'Package tag name' -> packageTagName} ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> instanceVariables [
	^ instanceVariables
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> instanceVariables: aCollection [
	instanceVariables := aCollection
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> packageName: aString [
	packageName := aString
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> packageTagName [
	^ packageTagName
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> packageTagName: aString [
	packageTagName := aString
]

{ #category : #printing }
GtLClassChangeDataExtractor >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [
		targetClass ifNotNil: [ :aClass |
			aStream nextPutAll: aClass name ].
		packageName ifNotNil: [ :aPackage |
			aStream nextPutAll: ' — ';
				nextPutAll: aPackage ] ]
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> request [
	^ request
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> request: aGtLClassChangeRequest [
	request := aGtLClassChangeRequest
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> superclass [
	^ superclass
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> superclass: aClass [
	superclass := aClass
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> targetClass: aClass [
	targetClass := aClass
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> traitComposition [
	^ traitComposition
]

{ #category : #accessing }
GtLClassChangeDataExtractor >> traitComposition: anObject [
	traitComposition := anObject
]
