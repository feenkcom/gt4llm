Class {
	#name : #GtLRefactoringClassDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'targetClass'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLRefactoringClassDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitRefactoringClassDomainObject: self
]

{ #category : #'api - serializing' }
GtLRefactoringClassDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'class' put: targetClass name asString;
		at: 'superclass'
			put: (targetClass superclass ifNil: [ nil ] ifNotNil: [ :spr | spr name asString ]);
		at: 'package' put: targetClass realClass packageName;
		at: 'instanceSlots' put: targetClass instanceVariableNames asArray;
		at: 'classSlots' put: targetClass classSide instanceVariableNames asArray;
		at: 'allInstanceMethods' put: targetClass selectors asArray;
		at: 'allClassMethods' put: targetClass classSide selectors asArray;
		yourself
]

{ #category : #accessing }
GtLRefactoringClassDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLRefactoringClassDomainObject >> targetClass: anObject [
	targetClass := anObject
]
