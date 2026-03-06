Class {
	#name : #GtLPushUpInstanceVariableSpecification,
	#superclass : #GtLVariableTransformationSpecification,
	#instVars : [
		'variableName'
	],
	#category : 'Gt4LlmCore-Formats'
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
		comment: 'The "Push up instance variable" transformation pushes up an instance variable definition from subclasses into a target superclass. The transformation must provide the variableClassName and variableNameToPushUp. The variablClassName specifies the superclass that will define variableNameToPushUp after the transformation is executed.'
]

{ #category : #'as yet unclassified' }
GtLPushUpInstanceVariableSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Push up slot ';
		nextPutAll: variableName;
		nextPutAll: ' to ';
		nextPutAll: variableClassName
]

{ #category : #description }
GtLPushUpInstanceVariableSpecification >> variableClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #variableClassName;
		comment: 'The name of the target superclass to which the variable is to be pushed';
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
		comment: 'The name of the variable to push up';
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
