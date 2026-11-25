Class {
	#name : #GtLRemoveClassSpecification,
	#superclass : #GtLClassTransformationSpecification,
	#instVars : [
		'classNameToRemove'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLRemoveClassSpecification class >> jsonSchemaLabel [
	^ 'RemoveClass'
]

{ #category : #converting }
GtLRemoveClassSpecification >> asRefactoringIn: aNamespace [
	^ RBRemoveClassTransformation
		model: aNamespace
		className: classNameToRemove asSymbol
]

{ #category : #accessing }
GtLRemoveClassSpecification >> classNameToRemove [
	^ classNameToRemove
]

{ #category : #accessing }
GtLRemoveClassSpecification >> classNameToRemove: aString [
	classNameToRemove := aString
]

{ #category : #magritte }
GtLRemoveClassSpecification >> classNameToRemoveDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #classNameToRemove;
		comment: 'The name of the class or trait to remove.';
		beRequired
]

{ #category : #accessing }
GtLRemoveClassSpecification >> classToRemoveIfAbsent: anAbsentBlock [
	classNameToRemove isEmptyOrNil ifTrue: [ ^ anAbsentBlock value ].
	^ (Smalltalk globals classOrTraitNamed: classNameToRemove) ifNil: anAbsentBlock
]

{ #category : #private }
GtLRemoveClassSpecification >> dependencyProblemsOf: aBehavior [
	^ ({self
			problemDescribedBy: '{1} has subclasses: {2}. Remove the subclasses first.'
			for: aBehavior
			users: aBehavior subclasses.
		self
			problemDescribedBy: '{1} is used as a trait by: {2}. Remove it from their trait compositions, or remove them, first.'
			for: aBehavior
			users: (self traitUsersOf: aBehavior).
		self
			problemDescribedBy: '{1} is used as a shared pool by: {2}. Remove them first.'
			for: aBehavior
			users: (self sharedPoolUsersOf: aBehavior)} reject: #isNil) asArray
]

{ #category : #magritte }
GtLRemoveClassSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'The "Remove class" transformation removes the class or trait named classNameToRemove. It is refused while the class has subclasses, while the trait is used by classes or traits, or while the shared pool is used by classes or traits. Methods that reference the class do not prevent its removal.'
]

{ #category : #printing }
GtLRemoveClassSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Remove class ';
		nextPutAll: (self classNameToRemove ifNil: [ '<class>' ]) asString
]

{ #category : #accessing }
GtLRemoveClassSpecification >> gtProblems [
	| aBehavior |
	aBehavior := self
			classToRemoveIfAbsent: [ ^ {self
						problemDescribedBy: (classNameToRemove isEmptyOrNil
								ifTrue: [ 'Missing class name' ]
								ifFalse: [ 'Class not found: ' , classNameToRemove ])} ].
	aBehavior name asString = classNameToRemove asString
		ifFalse: [ ^ {self
					problemDescribedBy: ('{1} is another name of {2}. Remove a class by its own name.'
							format: {classNameToRemove.
									aBehavior name})} ].
	aBehavior isClassSide
		ifTrue: [ ^ {self
					problemDescribedBy: ('{1} is the class side of {2}. Remove {2} instead.'
							format: {aBehavior name.
									aBehavior instanceSide name})} ].
	(Smalltalk specialObjectsArray identityIncludes: aBehavior)
		ifTrue: [ ^ {self
					problemDescribedBy: aBehavior name asString , ' is needed by the virtual machine and cannot be removed.'} ].
	^ self dependencyProblemsOf: aBehavior
]

{ #category : #private }
GtLRemoveClassSpecification >> listOfNamesOf: someBehaviors [
	"Name a few of them: a class can have thousands of subclasses or users"

	| someNames |
	someNames := (someBehaviors collect: [ :each | each name ]) asSortedCollection
			asArray.
	someNames size <= self maximumListedNames ifTrue: [ ^ ', ' join: someNames ].
	^ (', ' join: (someNames first: self maximumListedNames)) , ' and '
		, (someNames size - self maximumListedNames) printString , ' more'
]

{ #category : #private }
GtLRemoveClassSpecification >> maximumListedNames [
	^ 10
]

{ #category : #private }
GtLRemoveClassSpecification >> problemDescribedBy: aString [
	^ GtLTransformationProblem description: aString
]

{ #category : #private }
GtLRemoveClassSpecification >> problemDescribedBy: aTemplateString for: aBehavior users: someBehaviors [
	someBehaviors ifEmpty: [ ^ nil ].
	^ self
		problemDescribedBy: (aTemplateString
				format: {aBehavior name.
						self listOfNamesOf: someBehaviors})
]

{ #category : #accessing }
GtLRemoveClassSpecification >> sharedPoolUsersOf: aBehavior [
	(aBehavior inheritsFrom: SharedPool) ifFalse: [ ^ #() ].
	^ Smalltalk allClassesAndTraits
		select: [ :each | each sharedPools includes: aBehavior ]
]

{ #category : #accessing }
GtLRemoveClassSpecification >> traitUsersOf: aBehavior [
	| users |
	aBehavior isTrait ifFalse: [ ^ #() ].
	users := IdentitySet withAll: aBehavior users.
	users
		addAll: (aBehavior classTrait users collect: [ :each | each instanceSide ]).
	^ users asArray
]
