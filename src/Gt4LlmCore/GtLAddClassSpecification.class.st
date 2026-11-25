Class {
	#name : #GtLAddClassSpecification,
	#superclass : #GtLClassTransformationSpecification,
	#instVars : [
		'newClassName',
		'packageName',
		'slotNames',
		'tagName',
		'superclassName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #'as yet unclassified' }
GtLAddClassSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLAddClassSpecification class >> jsonSchemaLabel [
	^ 'AddClass'
]

{ #category : #accessing }
GtLAddClassSpecification >> addedClassName [
	^ newClassName
]

{ #category : #'as yet unclassified' }
GtLAddClassSpecification >> asRefactoringIn: aNamespace [
	^ (GtRBAddClassWithVarsRefactoring
		model: aNamespace
		addClass: newClassName asSymbol
		superclass: superclassName asSymbol
		subclasses: {}
		category: self category asSymbol)
		instanceVariableNames: self slotNameList;
		yourself
]

{ #category : #accessing }
GtLAddClassSpecification >> category [
	"RB takes the package and the tag of the new class as one category, Package-Tag"

	^ self hasTag
		ifTrue: [ packageName trimBoth , '-' , tagName trimBoth ]
		ifFalse: [ packageName trimBoth ]
]

{ #category : #'as yet unclassified' }
GtLAddClassSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Adds the class newClassName, a subclass of superclassName, to the package packageName, in the package tag tagName when given. slotNames are its instance variable names, separated by spaces.'
]

{ #category : #printing }
GtLAddClassSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Add class ';
		nextPutAll: newClassName asString;
		nextPutAll: ' as subclass of ';
		nextPutAll: superclassName asString.
	self slotNameList
		ifNotEmpty: [ :someNames | 
			aStream
				nextPutAll: ' with slots ';
				nextPutAll: (' ' join: someNames) ].
	self hasTag
		ifTrue: [ aStream
				nextPutAll: ' in tag ';
				nextPutAll: tagName trimBoth ]
]

{ #category : #validation }
GtLAddClassSpecification >> gtProblems [
	^ self gtProblemsAfterAdding: #()
]

{ #category : #validation }
GtLAddClassSpecification >> gtProblemsAfterAdding: someClassNames [
	"RB reports most of these problems as a failed precondition, so check them first. The superclass may be added by an earlier transformation of the same call"

	| problems |
	problems := OrderedCollection new.
	newClassName isEmptyOrNil
		ifTrue: [ problems add: 'Missing new class name' ]
		ifFalse: [ (RBCondition isValidClassName: newClassName asString) check
				ifFalse: [ problems
						add: newClassName
								, ' is not a valid class name: it must start with an uppercase letter and contain only letters, digits and underscores' ].
			((Smalltalk globals includesKey: newClassName asSymbol)
				or: [ someClassNames includes: newClassName asString ])
				ifTrue: [ problems
						add: newClassName , ' is already the name of a class or global variable' ] ].
	superclassName isEmptyOrNil
		ifTrue: [ problems add: 'Missing superclass name' ]
		ifFalse: [ ((Smalltalk globals classNamed: superclassName) isNil
				and: [ (someClassNames includes: superclassName asString) not ])
				ifTrue: [ problems add: 'Class not found: ' , superclassName ] ].
	(packageName isNil or: [ packageName trimBoth isEmpty ])
		ifTrue: [ problems add: 'Missing package name' ].
	^ problems
		collect: [ :each | GtLTransformationProblem description: each ]
		as: Array
]

{ #category : #testing }
GtLAddClassSpecification >> hasTag [
	^ tagName notNil and: [ tagName trimBoth notEmpty ]
]

{ #category : #accessing }
GtLAddClassSpecification >> newClassName [
	^ newClassName
]

{ #category : #accessing }
GtLAddClassSpecification >> newClassName: anObject [
	newClassName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> newClassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #newClassName;
		  beRequired
]

{ #category : #accessing }
GtLAddClassSpecification >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLAddClassSpecification >> packageName: anObject [
	packageName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> packageNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #packageName;
		  beRequired
]

{ #category : #accessing }
GtLAddClassSpecification >> slotNameList [
	"The slot names are optional and separated by any whitespace"

	^ slotNames ifNil: [ #() ] ifNotNil: [ :aString | aString substrings asArray ]
]

{ #category : #accessing }
GtLAddClassSpecification >> slotNames [
	^ slotNames
]

{ #category : #accessing }
GtLAddClassSpecification >> slotNames: anObject [
	slotNames := anObject
]

{ #category : #description }
GtLAddClassSpecification >> slotNamesDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #slotNames;
		comment: 'The instance variable names, separated by spaces.'
]

{ #category : #accessing }
GtLAddClassSpecification >> superclassName [
	^ superclassName
]

{ #category : #accessing }
GtLAddClassSpecification >> superclassName: anObject [
	superclassName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> superclassNameDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #superclassName;
		  beRequired
]

{ #category : #accessing }
GtLAddClassSpecification >> tagName [
	^ tagName
]

{ #category : #accessing }
GtLAddClassSpecification >> tagName: anObject [
	tagName := anObject
]

{ #category : #description }
GtLAddClassSpecification >> tagNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #tagName;
		comment: 'The package tag of the class.'
]

{ #category : #accessing }
GtLAddClassSpecification >> usedClassNames [
	^ {superclassName} reject: [ :each | each isNil ]
]
