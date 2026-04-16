Class {
	#name : #GtLSmaCCAbstractRewriteSpecification,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #converting }
GtLSmaCCAbstractRewriteSpecification >> asSmaCCRewriteIn: aModel [
	self subclassResponsibility
]

{ #category : #accessing }
GtLSmaCCAbstractRewriteSpecification >> errorMessage [
	^ nil
]

{ #category : #actions }
GtLSmaCCAbstractRewriteSpecification >> generateNewId [
	id := UUID new asString
]

{ #category : #accessing }
GtLSmaCCAbstractRewriteSpecification >> id [
	^ id
]

{ #category : #accessing }
GtLSmaCCAbstractRewriteSpecification >> id: aString [
	aString isEmptyOrNil ifTrue: [ ^ self ].
	(UUID gtFromString: aString) isNilUUID ifTrue: [ ^ self ].
	id := aString
]

{ #category : #accessing }
GtLSmaCCAbstractRewriteSpecification >> idDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'UUID';
		withUUIDFormatCommentWith: 'The UUID for the rewrite.';
		accessor: #id;
		beRequired
]

{ #category : #initialization }
GtLSmaCCAbstractRewriteSpecification >> initialize [
	super initialize.
	self generateNewId
]

{ #category : #testing }
GtLSmaCCAbstractRewriteSpecification >> isRewriteFile [
	^ false
]

{ #category : #'llm views' }
GtLSmaCCAbstractRewriteSpecification >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]
