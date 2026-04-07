Class {
	#name : #GtLRefactoringClassReferencesDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'targetClass',
		'references'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt-llm - serialization' }
GtLRefactoringClassReferencesDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonObject: [ :json |
		json
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
						as: Array) ]
]

{ #category : #accessing }
GtLRefactoringClassReferencesDomainObject >> references [
	^ references ifNil: [ #() ]
]

{ #category : #accessing }
GtLRefactoringClassReferencesDomainObject >> references: anObject [
	references := anObject
]

{ #category : #accessing }
GtLRefactoringClassReferencesDomainObject >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLRefactoringClassReferencesDomainObject >> targetClass: anObject [
	targetClass := anObject
]
