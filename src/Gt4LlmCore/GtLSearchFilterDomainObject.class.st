Class {
	#name : #GtLSearchFilterDomainObject,
	#superclass : #Object,
	#instVars : [
		'query',
		'filter',
		'items',
		'mayHaveMore'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLSearchFilterDomainObject >> filter [
	^ filter
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> filter: aSearchFilter [
	filter := aSearchFilter
]

{ #category : #'gt - extensions' }
GtLSearchFilterDomainObject >> gtItemsFor: aView [
	<gtView>
	<gtLlmView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Items';
		items: [ items ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]

{ #category : #testing }
GtLSearchFilterDomainObject >> isErrorDomainObject [
	^ false
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> items [
	^ items ifNil: [ items := #() ]
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> items: anObject [
	items := anObject
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> itemsAsPrintStrings [
	^ self items collect: #printString as: Array
]

{ #category : #magritte }
GtLSearchFilterDomainObject >> itemsDescription [
	<magritteDescription>

	^ MAToManyScalarRelationDescription new
		label: 'Items';
		accessor: #itemsAsPrintStrings;
		beRequired
]

{ #category : #'llm views' }
GtLSearchFilterDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> mayHaveMore [
	^ mayHaveMore ifNil: [ mayHaveMore := false ]
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> mayHaveMore: aBoolean [
	mayHaveMore := aBoolean
]

{ #category : #magritte }
GtLSearchFilterDomainObject >> mayHaveMoreDescription [
	<magritteDescription>

	^ MABooleanDescription new
		label: 'May have more items';
		accessor: #mayHaveMore;
		beRequired
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> query [
	^ query
]

{ #category : #accessing }
GtLSearchFilterDomainObject >> query: anObject [
	query := anObject
]

{ #category : #magritte }
GtLSearchFilterDomainObject >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
