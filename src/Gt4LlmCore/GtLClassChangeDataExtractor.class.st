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
		'packageTagName'
	],
	#category : #'Gt4LlmCore-Tools'
}

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
	"Extract all data from the request.
	Calls errorBlock for validation errors."
	
	self extractTargetClassIfError: errorBlock.
	self extractSuperclassIfError: errorBlock.
	self extractVariables.
	self extractPackageIfError: errorBlock.
	self extractPackageTagIfError: errorBlock
]

{ #category : #extraction }
GtLClassChangeDataExtractor >> extractPackageIfError: errorBlock [
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
GtLClassChangeDataExtractor >> extractVariables [
	"Extract instance and class variables from the request.
	If not provided, use the current variables of the target class."
	
	instanceVariables := request instanceVariables notEmpty
		ifTrue: [ request instanceVariables collect: [ :each | each asSymbol asSlot ] ]
		ifFalse: [ targetClass localSlots collect: [ :slot | slot copy ] ].
	
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
		items: [
			{ 'Request' -> request.
			  'Target class' -> targetClass.
			  'Superclass' -> superclass.
			  'Instance variables' -> instanceVariables.
			  'Class variables' -> classVariables.
			  'Package name' -> packageName } ];
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
