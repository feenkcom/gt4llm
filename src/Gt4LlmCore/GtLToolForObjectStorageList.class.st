Class {
	#name : #GtLToolForObjectStorageList,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
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
			missingModelName: 'objectStorage' ].
	items := anExecutionContext objectStorage objectIds
		collect: [ :eachId |
			GtLObjectStorageItem new
				objectId: eachId;
				objectValue: (anExecutionContext objectStorage objectAt: eachId);
				yourself ].
	^ GtLObjectStorageItems new
		items: items
]
