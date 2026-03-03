Class {
	#name : #GtLObjectStorageItemsDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'items'
	],
	#category : #Gt4LlmCore
}

{ #category : #'gt-view' }
GtLObjectStorageItemsDomainObject >> gtItemsFor: aView [
	<gtView>
	<gtLlmView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Object storage items';
		priority: 1;
		items: [ self items ];
		column: 'Object Id' text: [ :each | each objectId ];
		column: 'Object' text: [ :each | each objectValue gtDisplayString ]
]

{ #category : #accessing }
GtLObjectStorageItemsDomainObject >> items [
	^ items ifNil: [ #() ]
]

{ #category : #accessing }
GtLObjectStorageItemsDomainObject >> items: anObject [
	items := anObject
]

{ #category : #magritte }
GtLObjectStorageItemsDomainObject >> itemsDescription [
	<magritteDescription>

	^ MAToManyRelationDescription new
		label: 'Items';
		accessor: #items;
		classes: { GtLObjectStorageItem };
		beRequired
]
