Class {
	#name : #GtLPushDownMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'targetClassName',
		'methodNameToPushDown'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLPushDownMethodSpecification class >> isConcrete [
	^ false
]

{ #category : #accessing }
GtLPushDownMethodSpecification class >> jsonSchemaLabel [
	^ 'PushDownMethod'
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> asRefactoringIn: aNamespace [
	"RB pushes down a collection of selectors"

	^ RBPushDownMethodRefactoring
		model: aNamespace
		pushDown: {methodNameToPushDown asSymbol}
		from: self behaviorName asSymbol
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Moves the method methodNameToPushDown from the class methodClassName down to its direct subclasses, or from and to their class sides when classSide is true. Each subclass that does not define the method gets a copy of it; a subclass that defines it keeps its own. The method is then removed from methodClassName. Refused when methodClassName is not abstract, or when a subclass sends the method to super.'
]

{ #category : #printing }
GtLPushDownMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Push down method ';
		nextPutAll: (methodNameToPushDown ifNil: [ '<selector>' ]) asString;
		nextPutAll: ' from ';
		nextPutAll: (methodClassName ifNil: [ '<class>' ] ifNotNil: [ self behaviorName ])
]

{ #category : #validation }
GtLPushDownMethodSpecification >> gtProblems [
	^ self gtProblemsWithMethodNamed: methodNameToPushDown
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> methodNameToPushDown [
	^ methodNameToPushDown
]

{ #category : #'as yet unclassified' }
GtLPushDownMethodSpecification >> methodNameToPushDown: aString [
	methodNameToPushDown := aString
]

{ #category : #description }
GtLPushDownMethodSpecification >> methodNameToPushDownDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name to push down';
		accessor: #methodNameToPushDown;
		comment: 'The selector of the method to push down.';
		beRequired
]
