Class {
	#name : #GtLObjectStorageItems,
	#superclass : #Object,
	#instVars : [
		'items'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'gt views' }
GtLObjectStorageItems >> gtItemsFor: aView [
	<gtView>
	<gtLlmView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Object storage items';
		priority: 1;
		items: [ self items ];
		column: 'Object Id' text: [ :each | each objectId ];
		column: 'Object' text: [ :each | each objectValue gtDisplayString ];
		column: 'Reason' text: [ :each | each reasonString ]
]

{ #category : #accessing }
GtLObjectStorageItems >> items [
	^ items ifNil: [ #() ]
]

{ #category : #accessing }
GtLObjectStorageItems >> items: anObject [
	items := anObject
]

{ #category : #magritte }
GtLObjectStorageItems >> itemsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Items';
		accessor: #items;
		classes: { GtLObjectStorageItem };
		beRequired
]
