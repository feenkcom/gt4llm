Class {
	#name : #GtLIncorrectArgumentValueDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'argumentName',
		'argumentValue',
		'expectedArgumentValueKind'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLIncorrectArgumentValueDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitIncorrectArgumentValueDomainObject: self
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentName [
	^ argumentName
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentName: anObject [
	argumentName := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentValue [
	^ argumentValue
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> argumentValue: anObject [
	argumentValue := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> expectedArgumentValueKind [
	^ expectedArgumentValueKind
]

{ #category : #accessing }
GtLIncorrectArgumentValueDomainObject >> expectedArgumentValueKind: anObject [
	expectedArgumentValueKind := anObject
]

{ #category : #'api - testing' }
GtLIncorrectArgumentValueDomainObject >> isErrorDomainObject [
	^ true
]

{ #category : #'api - accessing' }
GtLIncorrectArgumentValueDomainObject >> messageText [
	"Return an error message"

	^ '{1} must be a kind of {2}, not a {3}'
		format: {self argumentName.
				self expectedArgumentValueKind.
				self argumentValue class}
]

{ #category : #'api - serializing' }
GtLIncorrectArgumentValueDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #argumentName put: self argumentName;
		at: #argumentValue put: self argumentValue;
		at: #expectedArgumentValueKind put: (self expectedArgumentValueKind ifNotNil: #name);
		yourself
]
