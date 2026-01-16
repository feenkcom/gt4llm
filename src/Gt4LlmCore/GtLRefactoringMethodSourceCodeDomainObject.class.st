Class {
	#name : #GtLRefactoringMethodSourceCodeDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'method'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLRefactoringMethodSourceCodeDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitRefactoringMethodSourceCodeDomainObject: self
]

{ #category : #accessing }
GtLRefactoringMethodSourceCodeDomainObject >> method [
	^ method
]

{ #category : #accessing }
GtLRefactoringMethodSourceCodeDomainObject >> method: anObject [
	method := anObject
]

{ #category : #'api - serializing' }
GtLRefactoringMethodSourceCodeDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methodName' put: self method selector;
		at: 'className'
			put: (String streamContents: [ :a | self method methodClass name asString ]);
		at: 'sourceCode' put: self method source;
		yourself
]
