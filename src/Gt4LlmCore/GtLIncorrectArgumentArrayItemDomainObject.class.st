Class {
	#name : #GtLIncorrectArgumentArrayItemDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'argumentName',
		'argumentValue',
		'incorrectItems',
		'expectedItemKind'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #visiting }
GtLIncorrectArgumentArrayItemDomainObject >> acceptVisitor: aVisitor [
	^ aVisitor visitIncorrectArgumentArrayItemValueDomainObject: self
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> argumentName [
	^ argumentName
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> argumentName: anObject [
	argumentName := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> argumentValue [
	^ argumentValue
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> argumentValue: anObject [
	argumentValue := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> expectedItemKind [
	^ expectedItemKind
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> expectedItemKind: anObject [
	expectedItemKind := anObject
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> incorrectItems [
	^ incorrectItems
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> incorrectItems: anObject [
	incorrectItems := anObject
]

{ #category : #'api - testing' }
GtLIncorrectArgumentArrayItemDomainObject >> isErrorDomainObject [
	^ true
]

{ #category : #'api - accessing' }
GtLIncorrectArgumentArrayItemDomainObject >> messageText [
	"Return an error message"

	^ '{1} must be an array with items of {2} kind, not a {3}'
		format: {self argumentName.
				self expectedItemKind.
				self incorrectItems anyOne class}
]

{ #category : #'api - serializing' }
GtLIncorrectArgumentArrayItemDomainObject >> serializeToOpenAIResponseJsonObject [
	"Return a JSON dictionary that represents the domain object."

	<return: #NeoJSONObject>
	^ NeoJSONObject new
		at: #error put: self messageText;
		at: #argumentName put: self argumentName;
		at: #argumentValue put: self argumentValue;
		at: #incorrectItems put: self incorrectItems;
		at: #expectedItemKind put: self expectedItemKind;
		yourself
]
