Class {
	#name : #GtLRefactoringClassSubclassesDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'targetClass',
		'subclasses'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLRefactoringClassSubclassesDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitRefactoringClassSubclassesDomainObject: self
]

{ #category : #'api - serializing' }
GtLRefactoringClassSubclassesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'class' put: self targetClass name asString;
		at: 'subclasses'
			put: (self subclasses
					collect: [ :eachSubclass | eachSubclass name asString ]
					as: Array);
		yourself
]

{ #category : #accessing }
GtLRefactoringClassSubclassesDomainObject >> subclasses [
	^ subclasses ifNil: [ #() ]
]

{ #category : #accessing }
GtLRefactoringClassSubclassesDomainObject >> subclasses: anObject [
	subclasses := anObject
]

{ #category : #accessing }
GtLRefactoringClassSubclassesDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLRefactoringClassSubclassesDomainObject >> targetClass: anObject [
	targetClass := anObject
]
