Class {
	#name : #GtLIncorrectArgumentArrayItemDomainObject,
	#superclass : #GtLErroneousConditionDomainObject,
	#instVars : [
		'argumentName',
		'argumentValue',
		'incorrectItems',
		'expectedItemKind'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> argumentName [
	^ argumentName
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> argumentName: anObject [
	argumentName := anObject
]

{ #category : #magritte }
GtLIncorrectArgumentArrayItemDomainObject >> argumentNameDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Argument name';
			accessor: #argumentName;
			beRequired
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> argumentValue [
	^ argumentValue
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> argumentValue: anObject [
	argumentValue := anObject
]

{ #category : #magritte }
GtLIncorrectArgumentArrayItemDomainObject >> argumentValueDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Argument value';
			accessor: #argumentValue;
			beRequired
]

{ #category : #magritte }
GtLIncorrectArgumentArrayItemDomainObject >> errorMessageDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Error message';
			accessor: #messageText;
			beRequired
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
GtLIncorrectArgumentArrayItemDomainObject >> expectedItemKindName [
	^ self expectedItemKind ifNotNil: [ :each | each name ]
]

{ #category : #magritte }
GtLIncorrectArgumentArrayItemDomainObject >> expectedItemKindNameDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Expected item kind name';
			accessor: #expectedItemKindName;
			beRequired
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> incorrectItems [
	^ incorrectItems
]

{ #category : #accessing }
GtLIncorrectArgumentArrayItemDomainObject >> incorrectItems: anObject [
	incorrectItems := anObject
]

{ #category : #magritte }
GtLIncorrectArgumentArrayItemDomainObject >> incorrectItemsDescription [
	<magritteDescription>

	^ MAStringDescription new
			label: 'Incorrect items';
			accessor: #incorrectItems;
			beRequired
]

{ #category : #views }
GtLIncorrectArgumentArrayItemDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #'api - accessing' }
GtLIncorrectArgumentArrayItemDomainObject >> messageText [
	"Return an error message"

	^ '{1} must be an array with items of {2} kind, not a {3}'
		format: {self argumentName.
				self expectedItemKind.
				self incorrectItems anyOne class}
]
