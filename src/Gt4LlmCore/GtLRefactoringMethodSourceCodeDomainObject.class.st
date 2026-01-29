Class {
	#name : #GtLRefactoringMethodSourceCodeDomainObject,
	#superclass : #GtLRefactoringDomainObject,
	#instVars : [
		'method'
	],
	#category : 'Gt4LlmCore-Domain Objects'
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

{ #category : #'api - accessing' }
GtLRefactoringMethodSourceCodeDomainObject >> methodClassName [
	^ self method methodClass name asString
]

{ #category : #'api - accessing' }
GtLRefactoringMethodSourceCodeDomainObject >> methodName [
	^ self method selector asString
]

{ #category : #'api - accessing' }
GtLRefactoringMethodSourceCodeDomainObject >> methodSourceCode [
	^ self method source
]

{ #category : #'api - serializing' }
GtLRefactoringMethodSourceCodeDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: 'methodName' put: self methodName;
		at: 'className' put: self methodClassName;
		at: 'sourceCode' put: self methodSourceCode;
		yourself
]
