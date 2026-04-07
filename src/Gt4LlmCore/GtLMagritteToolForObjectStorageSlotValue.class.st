"
Magritte-based tool for retrieving the serialized value of a named slot from an object stored in the object storage.
"
Class {
	#name : #GtLMagritteToolForObjectStorageSlotValue,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForObjectStorageSlotValue >> description [
	^ 'Retrieves the value of a named slot from an object in the object storage and returns a serialized object value result for that slot value.'
]

{ #category : #accessing }
GtLMagritteToolForObjectStorageSlotValue >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLMagritteToolForObjectStorageSlotValue >> name [
	^ 'getObjectStorageSlotValue'
]

{ #category : #descriptions }
GtLMagritteToolForObjectStorageSlotValue >> objectIdDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Object id';
		accessor: #objectId;
		beRequired
]

{ #category : #private }
GtLMagritteToolForObjectStorageSlotValue >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments objectId slotName object slot slotValue |
	arguments := aToolCall arguments.
	objectId := arguments at: 'objectId'.
	slotName := arguments at: 'slotName'.
	(objectId isNil or: [ objectId isString and: [ objectId trimBoth isEmpty ] ]) ifTrue: [
		^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'objectId' ].
	(slotName isNil or: [ slotName isString and: [ slotName trimBoth isEmpty ] ]) ifTrue: [
		^ GtLMissingArgumentDomainObject new
			arguments: arguments;
			missingArgument: 'slotName' ].
	anExecutionContext objectStorage
		ifNil: [ ^ GtLMissingInformationDomainObject new
			missingModelName: 'objectStorage' ].
	object := anExecutionContext objectStorage
		objectAt: objectId
		ifPresent: [ :storedObject | storedObject ]
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: objectId ].
	slot := object class allSlots
		detect: [ :each | each name asString = slotName asString ]
		ifNone: [ ^ GtLMissingDomainObject new objectName: slotName ].
	slotValue := [ object readSlotNamed: slot name ]
		on: Error
		do: [ :anError | ^ GtLExceptionDomainObject freeze: anError ].
	^ GtLObjectStorageValueResult 
			forObject:  slotValue
			withId: objectId
]

{ #category : #descriptions }
GtLMagritteToolForObjectStorageSlotValue >> slotNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Slot name';
		accessor: #slotName;
		beRequired
]
