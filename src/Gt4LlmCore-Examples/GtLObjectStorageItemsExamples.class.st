"
Examples for GtLObjectStorageItems and GtLObjectStorageItem, including data view serialization tests.
"
Class {
	#name : #GtLObjectStorageItemsExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLObjectStorageItemsExamples >> basicStorageItem [
	<gtExample>
	| item |
	item := GtLObjectStorageItem new
		objectId: 'abc123def456';
		objectValue: 42;
		reason: (GtLStoredObjectStringReason text: 'test reason');
		yourself.
	
	self assert: item objectId equals: 'abc123def456'.
	self assert: item objectValue equals: 42.
	self assert: item objectValueString equals: '42'.
	self assert: item reasonString equals: 'test reason'.
	
	^ item
]

{ #category : #examples }
GtLObjectStorageItemsExamples >> basicStorageItems [
	<gtExample>
	| items |
	items := GtLObjectStorageItems new
		items: { self basicStorageItem }.
	
	self assert: items items size equals: 1.
	self assert: items items first objectId equals: 'abc123def456'.
	
	^ items
]

{ #category : #examples }
GtLObjectStorageItemsExamples >> storageItemDataViewSerialization [
	<gtExample>
	| item compositeView dataBlock expected |
	item := self basicStorageItem.
	compositeView := item llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := Dictionary new
		at: #objectId put: 'abc123def456';
		at: #objectValueString put: '42';
		at: #reasonString put: 'test reason';
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLObjectStorageItemsExamples >> storageItemsDataViewSerialization [
	<gtExample>
	| items compositeView dataBlock expected |
	items := self basicStorageItems.
	compositeView := items llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := Dictionary new
		at: #items put: (NeoJSONArray with: (NeoJSONObject new
			at: #objectId put: 'abc123def456';
			at: #objectValueString put: '42';
			at: #reasonString put: 'test reason';
			yourself));
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]
