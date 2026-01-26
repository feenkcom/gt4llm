Class {
	#name : #GtLRefactoringClassReferencesDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'targetClass',
		'references'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLRefactoringClassReferencesDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitRefactoringClassReferencesDomainObject: self
]

{ #category : #accessing }
GtLRefactoringClassReferencesDomainObject >> references [
	^ references ifNil: [ #() ]
]

{ #category : #accessing }
GtLRefactoringClassReferencesDomainObject >> references: anObject [
	references := anObject
]

{ #category : #'api - serializing' }
GtLRefactoringClassReferencesDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'class' put: self targetClass name asString;
		at: 'references'
			put: (self references
					collect: [ :eachReference | 
						String
							streamContents: [ :aStream | 
								aStream nextPutAll: eachReference modelClass name.
								eachReference modelClass isMeta ifTrue: [ aStream nextPutAll: ' class' ].
								aStream nextPutAll: '>>#'.
								aStream nextPutAll: eachReference selector ] ]
					as: Array);
		yourself
]

{ #category : #accessing }
GtLRefactoringClassReferencesDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLRefactoringClassReferencesDomainObject >> targetClass: anObject [
	targetClass := anObject
]
