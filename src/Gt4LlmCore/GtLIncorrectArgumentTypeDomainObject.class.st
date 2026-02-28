Class {
	#name : #GtLIncorrectArgumentTypeDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'argumentName',
		'argumentValue',
		'expectedArgumentValueKind'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLIncorrectArgumentTypeDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitIncorrectArgumentValueDomainObject: self
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> argumentName [
	^ argumentName
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> argumentName: anObject [
	argumentName := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> argumentValue [
	^ argumentValue
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> argumentValue: anObject [
	argumentValue := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> expectedArgumentValueKind [
	^ expectedArgumentValueKind
]

{ #category : #accessing }
GtLIncorrectArgumentTypeDomainObject >> expectedArgumentValueKind: anObject [
	expectedArgumentValueKind := anObject
]

{ #category : #'api - testing' }
GtLIncorrectArgumentTypeDomainObject >> isErrorDomainObject [
	^ true
]

{ #category : #'api - accessing' }
GtLIncorrectArgumentTypeDomainObject >> messageText [
	"Return an error message"

	^ '{1} must be a kind of {2}, not a {3}'
		format: {self argumentName.
				self expectedArgumentValueKind.
				self argumentValue class}
]

{ #category : #'api - serializing' }
GtLIncorrectArgumentTypeDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #argumentName put: self argumentName;
		at: #argumentValue put: self argumentValue;
		at: #expectedArgumentValueKind put: (self expectedArgumentValueKind ifNotNil: #name);
		yourself
]
