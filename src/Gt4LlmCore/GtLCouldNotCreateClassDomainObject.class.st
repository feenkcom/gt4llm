Class {
	#name : #GtLCouldNotCreateClassDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'superclass',
		'targetClassName',
		'packageName',
		'instanceVariableNames',
		'classVariableNames',
		'exception'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> classVariableNames [
	^ classVariableNames
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> classVariableNames: anObject [
	classVariableNames := anObject
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

{ #category : #'api - testing' }
GtLCouldNotCreateClassDomainObject >> isErrorDomainObject [
	^ true
]

{ #category : #'api - accessing' }
GtLCouldNotCreateClassDomainObject >> messageText [
	"Return an error message"

	^ 'Class creation error: {1}'
		format: {(self exception respondsTo: #messageText)
					ifTrue: [ self exception messageText ifNil: [ self exception description ] ]
					ifFalse: [ self exception description ]}
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> packageName: anObject [
	packageName := anObject
]

{ #category : #'api - serializing' }
GtLCouldNotCreateClassDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #class put: self targetClassName;
		at: #superclass put: self superclass name;
		at: #package put: self packageName;
		at: #instanceVariables put: self instanceVariableNames;
		at: #classVariables put: self classVariableNames;
		yourself
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
GtLCouldNotCreateClassDomainObject >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLCouldNotCreateClassDomainObject >> targetClassName: anObject [
	targetClassName := anObject
]
