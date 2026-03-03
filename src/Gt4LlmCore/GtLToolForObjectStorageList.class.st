Class {
	#name : #GtLToolForObjectStorageList,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLToolForObjectStorageList >> description [
	^ 'Lists the objects in the object storage of a chat.'
]

{ #category : #accessing }
GtLToolForObjectStorageList >> name [
	^ 'listObjectStorage'
]

{ #category : #accessing }
GtLToolForObjectStorageList >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| items |
	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new
			receiverName: self name;
			missingModelName: 'objectStorage' ].
	items := anExecutionContext objectStorage objectIds
		collect: [ :eachId |
			GtLObjectStorageItem new
				objectId: eachId;
				objectValue: (anExecutionContext objectStorage objectAt: eachId);
				yourself ].
	^ GtLObjectStorageItemsDomainObject new
		items: items
]
