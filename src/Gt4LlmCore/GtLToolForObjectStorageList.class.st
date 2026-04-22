Class {
	#name : #GtLToolForObjectStorageList,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForObjectStorageList >> description [
	^ 'Lists the objects in the object storage of a chat.'
]

{ #category : #accessing }
GtLToolForObjectStorageList >> name [
	^ 'listObjectStorage'
]

{ #category : #private }
GtLToolForObjectStorageList >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| items |
	
	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new
			missingModelName: 'objectStorage' ].
			
	items := anExecutionContext objectStorage objectIds
		collect: [ :eachId |
			| storedObject |
			storedObject := anExecutionContext objectStorage storedObjectAt: eachId.
			GtLObjectStorageItem new
				objectId: eachId;
				objectValue: storedObject value;
				reason: storedObject reason;
				yourself ].
				
	^ GtLObjectStorageItems new
		items: items
]
