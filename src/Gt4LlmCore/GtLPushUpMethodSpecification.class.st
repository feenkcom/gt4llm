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
	^ GtPushUpMethodRefactoring
		model: aNamespace
		pullUp: (selectors collect: #asSymbol)
		from: methodClassName asSymbol
		to: targetClassName asSymbol
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Moves the method methodNameToPushUp from the class methodClassName to targetClassName, a direct or indirect superclass. Equivalent copies of the method in sibling subclasses are removed too.'
]

{ #category : #printing }
GtLPushUpMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Push up method ';
		nextPutAll: (', ' join: (self selectors collect: [ :each | each asString ]));
		nextPutAll: ' from ';
		nextPutAll: methodClassName asString.
	targetClassName
		ifNotNil: [ :aClassName | 
			aStream
				nextPutAll: ' to ';
				nextPutAll: aClassName asString ]
]

{ #category : #validation }
GtLPushUpMethodSpecification >> gtProblems [
	^(selectors
		flatCollect: [:each | self gtProblemsWithMethod: each inClassNamed: methodClassName])
			, (self gtProblemsWithClassNamed: targetClassName)
]

{ #category : #'as yet unclassified' }
GtLPushUpMethodSpecification >> initialize [
	super initialize.
	selectors := OrderedCollection new
]

{ #category : #descriptions }
GtLPushUpMethodSpecification >> methodClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #methodClassName;
		comment: 'The class that defines the method.';
		beRequired
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
		comment: 'The name of the method to push up.';
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
		comment: 'The superclass to move the method to.';
		beRequired
]

{ #category : #accessing }
GtLPushUpMethodSpecification >> usedClassNames [
	^ super usedClassNames , ({targetClassName} reject: [ :each | each isNil ])
]
