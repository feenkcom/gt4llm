Class {
	#name : #GtLCouldNotCreateClassDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'superclass',
		'targetClassName',
		'packageName',
		'instanceVariableNames',
		'classVariableNames',
		'exception',
		'packageTagName'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> classVariableNames [
	^ classVariableNames
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> classVariableNames: anObject [
	classVariableNames := anObject
]

{ #category : #'magritte-description' }
GtLCouldNotCreateClassDomainObject >> classVariableNamesDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class variables';
		accessor: #classVariableNames
]

{ #category : #'magritte-description' }
GtLCouldNotCreateClassDomainObject >> errorDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Error';
		accessor: #messageText;
		beRequired
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> exception [
	^ exception
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> exception: anObject [
	exception := anObject
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> freeze: anException [
	self exception: (GtSystemUtility freeze: anException)
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> instanceVariableNames [
	^ instanceVariableNames
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> instanceVariableNames: anObject [
	instanceVariableNames := anObject
]

{ #category : #'magritte-description' }
GtLCouldNotCreateClassDomainObject >> instanceVariableNamesDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Instance variables';
		accessor: #instanceVariableNames
]

{ #category : #'llm - views' }
GtLCouldNotCreateClassDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> messageText [
	"Return an error message"
	^ exception 
		ifNil: [ 'Class creation error: unknown error' ]
		ifNotNil: [
			'Class creation error: {1}'
				format: {(exception respondsTo: #messageText)
						ifTrue: [ exception messageText ifNil: [ exception description ] ]
						ifFalse: [ exception description ]} ]
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> packageName: anObject [
	packageName := anObject
]

{ #category : #'magritte-description' }
GtLCouldNotCreateClassDomainObject >> packageNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package';
		accessor: #packageName;
		beRequired
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> packageTagName [
	^ packageTagName
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> packageTagName: anObject [
	packageTagName := anObject
]

{ #category : #'magritte-description' }
GtLCouldNotCreateClassDomainObject >> packageTagNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package tag';
		accessor: #packageTagName;
		beRequired
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> superclass [
	^ superclass
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> superclass: anObject [
	superclass := anObject
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> superclassName [
	^ superclass ifNotNil: [ :sc | sc name ] ifNil: [ nil ]
]

{ #category : #'magritte - descriptions' }
GtLCouldNotCreateClassDomainObject >> superclassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Superclass';
		accessor: #superclassName;
		beOptional
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> targetClassName: anObject [
	targetClassName := anObject
]

{ #category : #'magritte-description' }
GtLCouldNotCreateClassDomainObject >> targetClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Target class name';
		accessor: #targetClassName;
		beRequired
]
