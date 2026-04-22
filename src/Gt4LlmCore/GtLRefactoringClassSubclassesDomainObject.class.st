Class {
	#name : #GtLRefactoringClassSubclassesDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'targetClass',
		'subclasses'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'gt-llm - serialization' }
GtLRefactoringClassSubclassesDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonObject: [ :json |
		json
			at: 'class' put: self targetClass name asString;
			at: 'subclasses'
				put: (self subclasses
						collect: [ :eachSubclass | eachSubclass name asString ]
						as: Array) ]
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
