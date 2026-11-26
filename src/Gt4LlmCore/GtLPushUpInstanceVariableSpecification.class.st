Class {
	#name : #GtLPushUpInstanceVariableSpecification,
	#superclass : #GtLVariableTransformationSpecification,
	#instVars : [
		'variableName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLPushUpInstanceVariableSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLPushUpInstanceVariableSpecification class >> jsonSchemaLabel [
	^ 'PushUpInstanceVariable'
]

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableSpecification >> asRefactoringIn: aGtRBNamespace [
	^ GtRBPullUpInstanceVariableRefactoring
		model: aGtRBNamespace
		variable: variableName
		class: variableClassName
]

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Moves the instance variable variableNameToPushUp from the subclasses that define it into their superclass variableClassName.'
]

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Push up slot ';
		nextPutAll: variableName;
		nextPutAll: ' to ';
		nextPutAll: variableClassName
]

{ #category : #validation }
GtLPushUpInstanceVariableSpecification >> gtParameterProblems [
	^ (self parameterProblemsWithClassName: variableClassName)
		, (variableName isEmptyOrNil
				ifTrue: [ {self parameterProblem: 'Missing variable name'} ]
				ifFalse: [ #() ])
]

{ #category : #validation }
GtLPushUpInstanceVariableSpecification >> gtPreconditionProblems [
	"RB checks that the subclasses define the variable"

	^ self preconditionProblemsWithClassNamed: variableClassName
]

{ #category : #description }
GtLPushUpInstanceVariableSpecification >> variableClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #variableClassName;
		comment: 'The superclass that defines the variable afterwards.';
		beRequired
]

{ #category : #accessing }
GtLPushUpInstanceVariableSpecification >> variableName [
	^ variableName
]

{ #category : #accessing }
GtLPushUpInstanceVariableSpecification >> variableName: anObject [
	variableName := anObject
]

{ #category : #description }
GtLPushUpInstanceVariableSpecification >> variableNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #variableNameToPushUp;
		comment: 'The name of the variable to push up.';
		beRequired
]

{ #category : #accessing }
GtLPushUpInstanceVariableSpecification >> variableNameToPushUp [
	^ variableName
]

{ #category : #accessing }
GtLPushUpInstanceVariableSpecification >> variableNameToPushUp: anObject [
	variableName := anObject
]
