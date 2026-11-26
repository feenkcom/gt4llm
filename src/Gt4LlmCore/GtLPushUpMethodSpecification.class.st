Class {
	#name : #GtLPushUpMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'targetClassName',
		'selectors'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLPushUpMethodSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLPushUpMethodSpecification class >> jsonSchemaLabel [
	^ 'PushUpMethod'
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> asRefactoringIn: aNamespace [
	"A class-side method moves to the class side of the target"

	^ GtPushUpMethodRefactoring
		model: aNamespace
		pullUp: (selectors collect: #asSymbol)
		from: self behaviorName asSymbol
		to: (self behaviorNameOf: targetClassName) asSymbol
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Moves the method methodNameToPushUp from the class methodClassName to targetClassName, a direct or indirect superclass; with classSide true, from and to their class sides. Equivalent copies of the method in sibling subclasses are removed too.'
]

{ #category : #printing }
GtLPushUpMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Push up method ';
		nextPutAll: (', ' join: (self selectors collect: [ :each | each asString ]));
		nextPutAll: ' from ';
		nextPutAll: self behaviorName.
	targetClassName
		ifNotNil: [ :aClassName | 
			aStream
				nextPutAll: ' to ';
				nextPutAll: (self behaviorNameOf: aClassName) ]
]

{ #category : #validation }
GtLPushUpMethodSpecification >> gtProblems [
	^ (selectors flatCollect: [ :each | self gtProblemsWithMethodNamed: each ])
		, (self gtProblemsWithClassNamed: targetClassName)
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> initialize [
	super initialize.
	selectors := OrderedCollection new
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> methodNameToPushUp [
	^ selectors anyOne
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> methodNameToPushUp: aString [
	selectors := OrderedCollection with: aString
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> selector [
	^ selectors anyOne
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> selector: aString [
	selectors := OrderedCollection with: aString
]

{ #category : #description }
GtLPushUpMethodSpecification >> selectorDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name to push up';
		accessor: #methodNameToPushUp;
		comment: 'The selector of the method to push up.';
		beRequired
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> selectors [
	^ selectors
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> selectors: anObject [
	selectors := anObject
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> targetClassName: anObject [
	targetClassName := anObject
]

{ #category : #description }
GtLPushUpMethodSpecification >> targetClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #targetClassName;
		comment: 'The superclass to move the method to, without " class": classSide tells the side.';
		beRequired
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> usedClassNames [
	^ super usedClassNames , ({targetClassName} reject: [ :each | each isNil ])
]
