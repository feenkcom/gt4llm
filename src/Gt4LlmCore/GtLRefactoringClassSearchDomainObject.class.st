Class {
	#name : #GtLRefactoringClassSearchDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'query',
		'allClassNames',
		'foundClassNames'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'api - serializing' }
GtLRefactoringClassSearchDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitRefactoringClassSearchDomainObject: self
]

{ #category : #accessing }
GtLRefactoringClassSearchDomainObject >> allClassNames [
	^ allClassNames
]

{ #category : #accessing }
GtLRefactoringClassSearchDomainObject >> allClassNames: anObject [
	allClassNames := anObject
]

{ #category : #accessing }
GtLRefactoringClassSearchDomainObject >> foundClassNames [
	^ foundClassNames ifNil: [ #() ]
]

{ #category : #accessing }
GtLRefactoringClassSearchDomainObject >> foundClassNames: anObject [
	foundClassNames := anObject
]

{ #category : #accessing }
GtLRefactoringClassSearchDomainObject >> query [
	^ query
]

{ #category : #accessing }
GtLRefactoringClassSearchDomainObject >> query: anObject [
	query := anObject
]

{ #category : #'api - serializing' }
GtLRefactoringClassSearchDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'query' put: self query;
		at: 'foundClasses' put: self foundClassNames;
		yourself
]
